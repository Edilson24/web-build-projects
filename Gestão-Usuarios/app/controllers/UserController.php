<?php
require_once __DIR__ . '/Controller.php';
require_once __DIR__ . '/../models/User.php';

class UserController extends Controller {
    private User $userModel;

    public function __construct() {
        $this->userModel = new User();
    }

    /**
     * Verifica se o utilizador está autenticado na sessão
     */
    private function checkAuth(): array {
        if (!isset($_SESSION['user_id'])) {
            header('Location: /login');
            exit;
        }

        $user = $this->userModel->findById($_SESSION['user_id']);
        
        // Bloqueio de utilizador inativo
        if (!$user || $user['status'] === 'inativo') {
            session_destroy();
            header('Location: /login');
            exit;
        }

        return $user;
    }

    /**
     * Exibe o perfil do utilizador
     */
public function profile(): void {
        $user = $this->checkAuth();
        $socialLinks = $this->userModel->getSocialLinks($user['id']);

        // Avatar Padrão via UI-Avatars se não houver foto enviada
        $avatarUrl = $user['foto_perfil'] 
            ? '/uploads/' . $user['foto_perfil'] 
            : 'https://ui-avatars.com/api/?name=' . urlencode($user['nome']) . '&background=38bdf8&color=0f172a&size=128';

        $this->render('user/profile', [
            'title'       => 'Meu Perfil',
            'user'        => $user,
            'avatarUrl'   => $avatarUrl,
            'socialLinks' => $socialLinks
        ]);
    }

    /**
     * Atualiza dados do Perfil e Upload de Foto
     */
    public function updateProfile(): void {
        $user = $this->checkAuth();

        $nome          = trim($_POST['nome'] ?? '');
        $userName      = trim($_POST['user_name'] ?? '');
        $bio           = trim($_POST['bio'] ?? '');
        $musicaUrl     = trim($_POST['musica_url'] ?? '');
        $temaPreferido = $_POST['tema_preferido'] ?? 'dark';
        $fotoNome      = null;

        // Processamento do Upload da Foto de Perfil
        if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
            $fileTmpPath = $_FILES['foto']['tmp_name'];
            $fileName    = $_FILES['foto']['name'];
            $fileSize    = $_FILES['foto']['size'];
            $fileExtension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

            $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
            $maxFileSize = 2 * 1024 * 1024; // 2MB máximo

            if (in_array($fileExtension, $allowedExtensions) && $fileSize <= $maxFileSize) {
                $uploadFileDir = __DIR__ . '/../../public/uploads/';
                if (!is_dir($uploadFileDir)) {
                    mkdir($uploadFileDir, 0777, true);
                }

                $newFileName = md5(time() . $fileName) . '.' . $fileExtension;
                $dest_path = $uploadFileDir . $newFileName;

                if (move_uploaded_file($fileTmpPath, $dest_path)) {
                    $fotoNome = $newFileName;
                }
            }
        }

        $this->userModel->updateProfile($user['id'], [
            'nome'           => $nome ?: $user['nome'],
            'user_name'      => $userName,
            'bio'            => $bio,
            'foto_perfil'     => $fotoNome,
            'musica_url'     => $musicaUrl,
            'tema_preferido' => $temaPreferido
        ]);

        header('Location: /perfil?updated=1');
        exit;
    }

    /**
     * Adiciona Link de Rede Social
     */
    public function addSocial(): void {
        $user = $this->checkAuth();
        $url  = filter_var(trim($_POST['url_link'] ?? ''), FILTER_VALIDATE_URL);

        if ($url) {
            $this->userModel->addSocialLink($user['id'], $url);
        }

        header('Location: /perfil');
        exit;
    }

    /**
     * Remove Link de Rede Social
     */
    public function removeSocial(): void {
        $user   = $this->checkAuth();
        $linkId = (int)($_GET['id'] ?? 0);

        if ($linkId > 0) {
            $this->userModel->deleteSocialLink($user['id'], $linkId);
        }

        header('Location: /perfil');
        exit;
    }
}