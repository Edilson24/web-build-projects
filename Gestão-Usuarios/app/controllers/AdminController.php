<?php
require_once __DIR__ . '/Controller.php';
require_once __DIR__ . '/../models/User.php';

use app\models\User;

class AdminController extends Controller {
    private ?User $userModel = null;

    public function __construct() {
        $this->userModel = new User();
    }

    private function checkAdmin(): array {
        if (!isset($_SESSION['user_id'])) {
            header('Location: /login');
            exit;
        }

        $user = $this->userModel->findById($_SESSION['user_id']);

        if (!$user || $user['status'] !== 'ativo' || $user['tipo_perfil'] !== 'admin') {
            header('Location: /perfil');
            exit;
        }

        return $user;
    }

    public function dashboard(): void {
        $currentUser = $this->checkAdmin();
        $users       = $this->userModel->getAllUsers();
        $stats       = $this->userModel->getSystemStats();

        $this->render('admin/dashboard', [
            'currentUser' => $currentUser,
            'users'       => $users,
            'stats'       => $stats
        ]);
    }

    public function storeUser(): void {
        $this->checkAdmin();
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $data = [
                'nome'        => trim($_POST['nome'] ?? ''),
                'email'       => trim($_POST['email'] ?? ''),
                'senha'       => $_POST['senha'] ?? '',
                'tipo_perfil' => $_POST['tipo_perfil'] ?? 'usuario',
                'status'      => $_POST['status'] ?? 'ativo'
            ];

            if (!empty($data['nome']) && !empty($data['email']) && !empty($data['senha'])) {
                $this->userModel->createUserByAdmin($data);
            }
        }

        header('Location: /admin');
        exit;
    }

    public function updateUser(): void {
        $this->checkAdmin();

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $userId = (int)($_POST['id'] ?? 0);
            
            if ($userId > 0) {
                $data = [
                    'nome'        => trim($_POST['nome'] ?? ''),
                    'email'       => trim($_POST['email'] ?? ''),
                    'senha'       => $_POST['senha'] ?? '',
                    'tipo_perfil' => $_POST['tipo_perfil'] ?? 'usuario',
                    'status'      => $_POST['status'] ?? 'ativo'
                ];

                $this->userModel->updateUserByAdmin($userId, $data);
            }
        }

        header('Location: /admin');
        exit;
    }

    public function deleteUser(): void {
        $this->checkAdmin();
        $targetUserId = (int)($_GET['id'] ?? 0);

        if ($targetUserId > 0 && $targetUserId !== (int)$_SESSION['user_id']) {
            $this->userModel->deleteUser($targetUserId);
        }

        header('Location: /admin');
        exit;
    }
}
