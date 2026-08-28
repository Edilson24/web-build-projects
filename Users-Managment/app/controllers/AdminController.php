<?php
require_once __DIR__ . '/AuthMiddleware.php';
require_once __DIR__ . '/../models/AdminModel.php';

class AdminController {
public function dashboard() {
        AuthMiddleware::protegerRota();

        if ($_SESSION['tipo_perfil'] !== 'admin') {
            header('Location: /user/perfil');
            exit;
        }

        $adminModel = new AdminModel();
        $logModel   = new LogModel();

        // 1. Prepara as variáveis consumidas pela View
        $totais         = $adminModel->obterTotaisCards();
        $fluxoCadastros = $adminModel->obterFluxoCadastrosMensal();
        $ultimosLogs    = $logModel->obterUltimosLogs(3); // Obtido via LogModel

        // 2. Carrega a View (as variáveis acima ficam disponíveis no HTML)
        require __DIR__ . '/../views/admin/dashboard.php';
    }

    // Endpoint JSON para o sininho de notificações em JS
    public function alertasSeguranca() {
        AuthMiddleware::protegerRota();
        header('Content-Type: application/json');
        
        $logModel = new LogModel();
        echo json_encode($logModel->obterAlertasSegurancaRecentes(5));
        exit;
    }
}