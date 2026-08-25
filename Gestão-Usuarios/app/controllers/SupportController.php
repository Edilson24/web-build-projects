<?php
require_once __DIR__ . '/Controller.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/SupportTicket.php';

class SupportController extends Controller {
    private User $userModel;
    private SupportTicket $supportModel;

    public function __construct() {
        $this->userModel = new User();
        $this->supportModel = new SupportTicket();
    }

    private function checkAuth(): array {
        if (!isset($_SESSION['user_id'])) {
            header('Location: /login');
            exit;
        }
        $user = $this->userModel->findById($_SESSION['user_id']);
        if (!$user || $user['status'] === 'inativo') {
            session_destroy();
            header('Location: /login');
            exit;
        }
        return $user;
    }

    /**
     * Lista os chamados do utilizador
     */
    public function index(): void {
        $user = $this->checkAuth();
        $tickets = $this->supportModel->getTicketsByUser($user['id']);

        $this->render('support/index', [
            'user'    => $user,
            'tickets' => $tickets
        ]);
    }

    /**
     * Processa a criação de um novo chamado
     */
    public function store(): void {
        $user = $this->checkAuth();
        $assunto  = trim($_POST['assunto'] ?? '');
        $mensagem = trim($_POST['mensagem'] ?? '');

        if (!empty($assunto) && !empty($mensagem)) {
            $this->supportModel->createTicket($user['id'], $assunto, $mensagem);
        }

        header('Location: /suporte');
        exit;
    }

    /**
     * Exibe o chat interativo de um chamado específico
     */
    public function view(): void {
        $user     = $this->checkAuth();
        $ticketId = (int)($_GET['id'] ?? 0);

        $ticket = $this->supportModel->getTicketById($ticketId, $user['id'], $user['tipo_perfil']);

        if (!$ticket) {
            header('Location: /suporte');
            exit;
        }

        $messages = $this->supportModel->getTicketMessages($ticketId);

        $this->render('support/view', [
            'user'     => $user,
            'ticket'   => $ticket,
            'messages' => $messages
        ]);
    }

    /**
     * Processa o envio de uma resposta na conversa
     */
    public function reply(): void {
        $user     = $this->checkAuth();
        $ticketId = (int)($_POST['chamado_id'] ?? 0);
        $mensagem = trim($_POST['mensagem'] ?? '');

        $ticket = $this->supportModel->getTicketById($ticketId, $user['id'], $user['tipo_perfil']);

        if ($ticket && !empty($mensagem)) {
            $this->supportModel->addMessage($ticketId, $user['id'], $mensagem);
        }

        header('Location: /suporte/ver?id=' . $ticketId);
        exit;
    }
}