<?php
session_start();
require_once __DIR__ . '/../config/database.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Rota para salvar a preferência de tema via AJAX/Fetch
if ($uri === '/user/salvar-tema' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_SESSION['usuario_id'])) {
        require_once __DIR__ . '/../app/models/UsuarioModel.php';
        $tema = $_POST['tema'] ?? 'dark';
        $usuarioModel = new UsuarioModel();
        
        $stmt = Database::getConnection()->prepare("UPDATE usuarios SET tema_preferido = :tema WHERE id = :id");
        $stmt->execute([':tema' => $tema, ':id' => $_SESSION['usuario_id']]);
    }
    http_response_code(200);
    echo json_encode(['success' => true]);
    exit;
}

// Demais Rotas Principais
switch ($uri) {
    case '/':
    case '/index.php':
        require_once __DIR__ . '/../app/views/auth/landing.php';
        break;

    case '/login':
        require_once __DIR__ . '/../app/controllers/AuthController.php';
        $auth = new AuthController();
        $auth->login();
        break;

        case '/registro':
        require_once __DIR__ . '/../app/controllers/AuthController.php';
        $auth = new AuthController();
        $auth->registro();
        break;

    case '/logout':
        require_once __DIR__ . '/../app/controllers/AuthController.php';
        $auth = new AuthController();
        $auth->logout();
        break;

        case '/admin/logs':
        require_once __DIR__ . '/../app/controllers/AuthMiddleware.php';
        AuthMiddleware::protegerRota();
        require_once __DIR__ . '/../app/models/LogModel.php';
        $logModel = new LogModel();
        $logs = $logModel->obterTodos();
        require_once __DIR__ . '/../app/views/admin/logs.php';
        break;

    case '/admin/dashboard':
        require_once __DIR__ . '/../app/controllers/AdminController.php';
        $admin = new AdminController();
        $admin->dashboard();
        break;

    case '/admin/alertas-seguranca':
        require_once __DIR__ . '/../app/controllers/AdminController.php';
        $admin = new AdminController();
        $admin->alertasSeguranca();
        break;

        case '/admin/usuarios':
        require_once __DIR__ . '/../app/controllers/UsuarioController.php';
        (new UsuarioController())->index();
        break;

    case '/admin/usuarios/salvar':
        require_once __DIR__ . '/../app/controllers/UsuarioController.php';
        (new UsuarioController())->salvar();
        break;

    case '/admin/usuarios/atualizar':
        require_once __DIR__ . '/../app/controllers/UsuarioController.php';
        (new UsuarioController())->atualizar();
        break;

    case '/admin/usuarios/status':
        require_once __DIR__ . '/../app/controllers/UsuarioController.php';
        (new UsuarioController())->alternarStatus();
        break;

    case '/admin/usuarios/excluir':
        require_once __DIR__ . '/../app/controllers/UsuarioController.php';
        (new UsuarioController())->excluir();
        break;

        // Rotas de perfil e configurações do usuário
// Suporta /perfil e /user/perfil para evitar o erro 404
    case '/perfil':
    case '/user/perfil':
        require_once __DIR__ . '/../app/controllers/PerfilController.php';
        (new PerfilController())->exibirPerfil();
        break;

    case '/configuracoes':
    case '/user/configuracoes':
        require_once __DIR__ . '/../app/controllers/PerfilController.php';
        (new PerfilController())->exibirConfiguracoes();
        break;

    case '/configuracoes/salvar':
        require_once __DIR__ . '/../app/controllers/PerfilController.php';
        (new PerfilController())->salvarConfiguracoes();
        break;

    default:
        http_response_code(404);
        echo "Página não encontrada.";
        break;
}