<?php
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/AuthMiddleware.php';
require_once __DIR__ . '/../models/LogModel.php';

class AuthController {
    private $usuarioModel;
    private $logModel;

    public function __construct() {
        $this->usuarioModel = new UsuarioModel();
        $this->logModel = new LogModel();
    }

    public function login() {
        if (session_status() === PHP_SESSION_NONE) session_start();
        $erro = null;
        $alertaSeguranca = null;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $email = $_POST['email'] ?? '';
            $senha = $_POST['senha'] ?? '';
            $lembrar = isset($_POST['remember_me']);

            // 1. Verificação Visual de SQL Injection
            if (AuthMiddleware::detectarSqlInjection($email) || AuthMiddleware::detectarSqlInjection($senha)) {
                // Log de segurança em arquivo
                error_log("[" . date('Y-m-d H:i:s') . "] ALERTA DE SEGURANÇA: Tentativa de SQL Injection detectada no login! Email inserido: {$email}\n", 3, __DIR__ . '/../../logs/error.log');
                
                $alertaSeguranca = "Tentativa de SQL Injection rejeitada pelo sistema de segurança!";
                require __DIR__ . '/../views/auth/login.php';
                return;
            }

            // Deteção de XSS
            if (AuthMiddleware::detectarXSS($email) || AuthMiddleware::detectarXSS($senha)) {
                $this->logModel->registrar($email, 'tentativa de invasao xss', 'Bloqueado');
                $alertaSeguranca = "Tentativa de ataque XSS rejeitada pelo sistema!";
                require __DIR__ . '/../views/auth/login.php';
                return;
            }

            // 2. Consulta Segura via PDO Prepared Statements
            $usuario = $this->usuarioModel->buscarPorEmail($email);

            if ($usuario && password_verify($senha, $usuario['senha'])) {
                if ($usuario['status'] === 'inativo') {
                    $_SESSION['usuario_bloqueado_id'] = $usuario['id'];
                    header('Location: /conta-inativa');
                    exit;
                }

                $_SESSION['usuario_id'] = $usuario['id'];
                $_SESSION['usuario_nome'] = $usuario['nome'];
                $_SESSION['tipo_perfil'] = $usuario['tipo_perfil'];

                if ($lembrar) {
                    $token = bin2hex(random_bytes(32));
                    $this->usuarioModel->salvarRememberToken($usuario['id'], $token);
                    setcookie('remember_token', $token, time() + (7 * 24 * 60 * 60), '/', '', false, true);
                }

                if ($usuario['primeiro_acesso'] == 1) {
                    header('Location: /alterar-senha-inicial');
                    exit;
                }

                $redirecionar = ($usuario['tipo_perfil'] === 'admin') ? '/admin/dashboard' : '/user/perfil';
                header("Location: {$redirecionar}");
                exit;
            } else {
                $erro = "E-mail ou senha incorretos.";
            }
        }

        require __DIR__ . '/../views/auth/login.php';
    }

    public function logout() {
        if (session_status() === PHP_SESSION_NONE) session_start();
        
        if (isset($_SESSION['usuario_nome'])) {
            $this->logModel->registrar($_SESSION['usuario_nome'], 'Encerramento de sessão (Logout)', 'Sucesso');
        }

        $_SESSION = array();
        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $params["path"], $params["domain"], $params["secure"], $params["httponly"]);
        }
        if (isset($_COOKIE['remember_token'])) {
            setcookie('remember_token', '', time() - 3600, '/');
        }

        session_destroy();
        header('Location: /login');
        exit;
    }

    // app/controllers/AuthController.php

public function registro() {
    if (session_status() === PHP_SESSION_NONE) session_start();
    $erro = null;
    $alertaSeguranca = null;

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $nome     = trim($_POST['nome'] ?? '');
        $email    = trim($_POST['email'] ?? '');
        $username = trim($_POST['username'] ?? '');
        $senha    = $_POST['senha'] ?? '';
        $confirmar = $_POST['confirmar_senha'] ?? '';

        // 1. Verificação de XSS nos campos de texto
        if (AuthMiddleware::detectarXSS($nome) || AuthMiddleware::detectarXSS($email) || AuthMiddleware::detectarXSS($username)) {
            $this->logModel->registrar($email ?: 'Visitante', 'tentativa de invasao xss', 'Bloqueado');
            $alertaSeguranca = "Tentativa de ataque XSS rejeitada pelo sistema!";
            require __DIR__ . '/../views/auth/registro.php';
            return;
        }

        // 2. Verificação de SQL Injection
        if (AuthMiddleware::detectarSqlInjection($nome) || AuthMiddleware::detectarSqlInjection($email) || AuthMiddleware::detectarSqlInjection($username)) {
            $this->logModel->registrar($email ?: 'Visitante', 'tentativa de invasao dql injecion', 'Bloqueado');
            $alertaSeguranca = "Tentativa de SQL Injection rejeitada pelo sistema!";
            require __DIR__ . '/../views/auth/registro.php';
            return;
        }

        // Validações de formulário
        if (empty($nome) || empty($email) || empty($senha)) {
            $erro = "Por favor, preencha todos os campos obrigatórios.";
        } elseif ($senha !== $confirmar) {
            $erro = "As senhas digitadas não coincidem.";
        } elseif ($this->usuarioModel->buscarPorEmail($email)) {
            $erro = "O e-mail informado já está registado.";
        } else {
            // Upload opcional de Foto de Perfil
            $caminhoFoto = null;
            if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
                $ext = pathinfo($_FILES['foto']['name'], PATHINFO_EXTENSION);
                $nomeFoto = md5(uniqid(rand(), true)) . '.' . $ext;
                $destino = __DIR__ . '/../../public/uploads/' . $nomeFoto;
                
                if (move_uploaded_file($_FILES['foto']['tmp_name'], $destino)) {
                    $caminhoFoto = '/uploads/' . $nomeFoto;
                }
            }

            $sucesso = $this->usuarioModel->cadastrar([
                'nome'     => $nome,
                'email'    => $email,
                'username' => $username,
                'senha'    => $senha,
                'foto'     => $caminhoFoto
            ]);

            if ($sucesso) {
                // Registo legítimo de criação de conta na tabela de logs
                $this->logModel->registrar($nome, 'Criou uma nova conta (Registo)', 'Sucesso');

                $_SESSION['sucesso_registro'] = "Conta criada com sucesso! Faça login para continuar.";
                header('Location: /login');
                exit;
            } else {
                $this->logModel->registrar($email, 'Falha ao cadastrar conta', 'Falha');
                $erro = "Erro interno ao cadastrar utilizador. Tente novamente.";
            }
        }
    }

    require __DIR__ . '/../views/auth/registro.php';
}
}