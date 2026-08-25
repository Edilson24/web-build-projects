<?php
require_once __DIR__ . '/Controller.php';
require_once __DIR__ . '/../models/User.php';

class AuthController extends Controller {
    private User $userModel;

    public function __construct() {
        $this->userModel = new User();
    }

    /**
     * Exibe o formulário de Cadastro
     */
    public function showRegister(): void {
        $this->render('auth/register', ['title' => 'Criar Nova Conta']);
    }

    /**
     * Processa o formulário de Cadastro
     */
    public function register(): void {
        $nome     = trim($_POST['nome'] ?? '');
        $email    = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
        $userName = trim($_POST['user_name'] ?? '');
        $senha    = $_POST['senha'] ?? '';
        $confirm  = $_POST['confirmar_senha'] ?? '';

        if (!$nome || !$email || !$senha) {
            $this->render('auth/register', ['error' => 'Por favor, preencha todos os campos obrigatórios.']);
            return;
        }

        if ($senha !== $confirm) {
            $this->render('auth/register', ['error' => 'As senhas digitadas não coincidem.']);
            return;
        }

        if ($this->userModel->findByEmail($email)) {
            $this->render('auth/register', ['error' => 'O e-mail informado já está registado.']);
            return;
        }

        $success = $this->userModel->create([
            'nome'      => $nome,
            'email'     => $email,
            'user_name' => $userName ?: null,
            'senha'     => $senha
        ]);

        if ($success) {
            header('Location: /login?registered=1');
            exit;
        } else {
            $this->render('auth/register', ['error' => 'Erro interno ao realizar o cadastro.']);
        }
    }

    /**
     * Exibe a tela de Login
     */
    public function showLogin(): void {
        $this->render('auth/login', ['title' => 'Iniciar Sessão']);
    }

    /**
     * Processa o Login de Utilizador e Cookie "Lembrar-me"[cite: 2, 3]
     */
    public function login(): void {
        $email      = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
        $senha      = $_POST['senha'] ?? '';
        $rememberMe = isset($_POST['remember_me']);

        if (!$email || !$senha) {
            $this->render('auth/login', ['error' => 'Informe o e-mail e a senha.']);
            return;
        }

        $user = $this->userModel->findByEmail($email);

        if ($user && password_verify($senha, $user['senha'])) { //[cite: 2]
            if ($user['status'] === 'inativo') {
                $this->render('auth/login', ['error' => 'A sua conta está inativa. Contacte o suporte.']);
                return;
            }

            // Criar sessão PHP[cite: 2]
            $_SESSION['user_id']     = $user['id'];
            $_SESSION['user_nome']   = $user['nome'];
            $_SESSION['user_perfil'] = $user['tipo_perfil'];

            // Lógica do Cookie "Lembrar-me" de 7 dias[cite: 2, 3]
            if ($rememberMe) {
                $token = bin2hex(random_bytes(32));
                $this->userModel->updateRememberToken($user['id'], $token);
                
                // Cookie válido por 7 dias (604800 segundos)[cite: 3]
                setcookie('remember_me', $token, time() + (86400 * 7), "/", "", false, true);
            }

            // Redireciona de acordo com o perfil
            if ($user['tipo_perfil'] === 'admin') {
                header('Location: /admin');
            } else {
                header('Location: /perfil');
            }
            exit;
        }

        $this->render('auth/login', ['error' => 'Credenciais de acesso inválidas.']);
    }

    /**
     * Encerra a Sessão (Logout)[cite: 2, 3]
     */
    public function logout(): void {
        if (isset($_SESSION['user_id'])) {
            $this->userModel->updateRememberToken($_SESSION['user_id'], null);
        }

        session_destroy();
        setcookie('remember_me', '', time() - 3600, "/");

        header('Location: /login');
        exit;
    }
}