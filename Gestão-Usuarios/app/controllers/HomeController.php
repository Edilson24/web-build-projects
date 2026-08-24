<?php
require_once __DIR__ . '/Controller.php';

class HomeController extends Controller {
    public function index(): void {
        // Exemplo de verificação inicial de cookie 'Lembrar-me'
        $remembered = isset($_COOKIE['remember_me']);

        $this->render('user/landing', [
            'titulo'     => 'Bem-vindo ao Sistema de Gestão de Utilizadores',
            'remembered' => $remembered
        ]);
    }
}