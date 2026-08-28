// app/controllers/DashboardController.php
require_once __DIR__ . '/AuthMiddleware.php';

class DashboardController {
    public function index() {
        // Bloqueia tentativas de colar a URL em aba anónima
        AuthMiddleware::protegerRota();

        require __DIR__ . '/../views/admin/dashboard.php';
    }
}