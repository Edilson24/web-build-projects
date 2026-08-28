<?php
require_once __DIR__ . '/../models/LogModel.php';
class AuthMiddleware {

    public static function protegerRota() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        // Tenta reconectar via cookie "Lembrar-me" se a sessão tiver expirado
        if (!isset($_SESSION['usuario_id']) && isset($_COOKIE['remember_token'])) {
            require_once __DIR__ . '/../models/UsuarioModel.php';
            $usuarioModel = new UsuarioModel();
            $user = $usuarioModel->buscarPorRememberToken($_COOKIE['remember_token']);
            
            if ($user && $user['status'] === 'ativo') {
                $_SESSION['usuario_id'] = $user['id'];
                $_SESSION['usuario_nome'] = $user['nome'];
                $_SESSION['tipo_perfil'] = $user['tipo_perfil'];
            }
        }

        // Verificação executada após confirmar que o utilizador está autenticado
        if (isset($_SESSION['usuario_status']) && $_SESSION['usuario_status'] === 'inativo') {
            // Permite apenas acessar a página de conta bloqueada, envio de suporte e logout
            $rotaAtual = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
            $rotasPermitidas = ['/conta-bloqueada', '/suporte/enviar', '/logout'];

            if (!in_array($rotaAtual, $rotasPermitidas)) {
                header('Location: /conta-bloqueada');
                exit;
            }
        }

        // Se ainda não estiver logado, bloqueia a navegação anónima
        if (!isset($_SESSION['usuario_id'])) {
            $_SESSION['erro_acesso'] = "Acesso negado! Inicie sessão para acessar a página solicitada.";
            header('Location: /login');
            exit;
        }
    }

    /**
     * Inspeciona inputs contra padrões maliciosos comuns de SQL Injection
     */
    public static function detectarSqlInjection($input) {
        if (is_array($input)) {
            foreach ($input as $valor) {
                if (self::detectarSqlInjection($valor)) return true;
            }
            return false;
        }

        $padroes = [
            '/\b(SELECT|INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|TRUNCATE|EXEC|UNION)\b/i',
            '/(--|\#|\/\*|\*\/)/',
            '/\bOR\b\s+[\'"]?\d+[\'"]?\s*=\s*[\'"]?\d+/i',
            '/[\'"]\s*OR\s*[\'"]?1[\'"]?\s*=\s*[\'"]?1/i'
        ];

        foreach ($padroes as $padrao) {
            if (preg_match($padrao, $input)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Inspeciona inputs contra XSS (Cross-Site Scripting)
     */
    public static function detectarXSS($input) {
        if (is_array($input)) {
            foreach ($input as $valor) {
                if (self::detectarXSS($valor)) return true;
            }
            return false;
        }

        $padroes = [
            '/<script\b[^>]*>(.*?)<\/script>/is',
            '/javascript\s*:/i',
            '/on\w+\s*=/i', // Detecta onmouseover=, onload=, onerror=, etc.
            '/<iframe\b[^>]*>/i',
            '/<img\b[^>]*onerror\s*=/i'
        ];

        foreach ($padroes as $padrao) {
            if (preg_match($padrao, $input)) {
                return true;
            }
        }
        return false;
    }
}