<?php
// app/controllers/UsuarioController.php

require_once __DIR__ . '/../models/UsuarioModel.php';

class UsuarioController {
    
    public function index() {
        // Exemplo de captura de filtros via GET
        $busca  = $_GET['busca'] ?? '';
        $status = $_GET['status'] ?? '';

$usuarioModel = new UsuarioModel();
        $usuarios = $usuarioModel->listarComFiltro($busca, $status);

        require_once __DIR__ . '/../views/admin/usuarios.php';
    }

    public function salvar() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $usuarioModel = new UsuarioModel();
            $usuarioModel->salvar($_POST);
            header('Location: /admin/usuarios');
            exit;
        }
    }

    public function atualizar() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $usuarioModel = new UsuarioModel();
            $usuarioModel->atualizar($_POST['id'], $_POST);
            header('Location: /admin/usuarios');
            exit;
        }
    }

    public function alternarStatus() {
        $id = $_GET['id'] ?? null;
        if ($id) {
            $usuarioModel = new UsuarioModel();
            $usuarioModel->alternarStatus($id);
        }
        header('Location: /admin/usuarios');
        exit;
    }

public function excluir() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $id = $_GET['id'] ?? null;
    $idAdminLogado = $_SESSION['usuario_id'] ?? $_SESSION['user_id'] ?? 0;

    // Impede que o administrador delete a si mesmo
    if ($id && $id != $idAdminLogado) {
        $usuarioModel = new UsuarioModel();
        $usuarioModel->excluir($id);
    }

    header('Location: /admin/usuarios');
    exit;
}
}