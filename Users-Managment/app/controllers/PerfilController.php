<?php
// app/controllers/PerfilController.php

require_once __DIR__ . '/../models/UsuarioModel.php';

class PerfilController {

    public function __construct() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        
        // Redireciona para o login se o usuário não estiver autenticado
        if (!isset($_SESSION['usuario_id']) && !isset($_SESSION['user_id'])) {
            header('Location: /login');
            exit;
        }
    }

    /**
     * Exibe a tela de visualização do Perfil (/perfil)
     */
    public function exibirPerfil() {
        $idUsuario = $_SESSION['usuario_id'] ?? $_SESSION['user_id'];
        
        $usuarioModel = new UsuarioModel();
        $usuario = $usuarioModel->buscarPorId($idUsuario);

        require_once __DIR__ . '/../views/user/perfil.php';
    }

    /**
     * Exibe o formulário de Configurações (/configuracoes)
     */
    public function exibirConfiguracoes() {
        $idUsuario = $_SESSION['usuario_id'] ?? $_SESSION['user_id'];
        
        $usuarioModel = new UsuarioModel();
        $usuario = $usuarioModel->buscarPorId($idUsuario);

        require_once __DIR__ . '/../views/user/configuracoes.php';
    }

    /**
     * Processa a atualização dos dados do usuário (/configuracoes/salvar)
     */
public function salvarConfiguracoes() {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $idUsuario = $_SESSION['usuario_id'] ?? $_SESSION['user_id'] ?? $_SESSION['id'];
        $dados = $_POST;

        // Trata o envio de imagem via Upload
        if (isset($_FILES['foto_perfil_file']) && $_FILES['foto_perfil_file']['error'] === UPLOAD_ERR_OK) {
            $ext = pathinfo($_FILES['foto_perfil_file']['name'], PATHINFO_EXTENSION);
            $nomeArquivo = 'avatar_' . $idUsuario . '_' . time() . '.' . $ext;
            $destino = __DIR__ . '/../../public/uploads/' . $nomeArquivo;

            // Garante que a pasta uploads exista
            if (!is_dir(__DIR__ . '/../../public/uploads/')) {
                mkdir(__DIR__ . '/../../public/uploads/', 0777, true);
            }

            if (move_uploaded_file($_FILES['foto_perfil_file']['tmp_name'], $destino)) {
                $dados['foto_perfil'] = '/uploads/' . $nomeArquivo;
            }
        }

        $usuarioModel = new UsuarioModel();
        $sucesso = $usuarioModel->atualizarPerfilCompleto($idUsuario, $dados);

        if ($sucesso) {
            $_SESSION['usuario_nome'] = $dados['nome'] ?? $_SESSION['usuario_nome'];
            $_SESSION['sucesso'] = "Configurações atualizadas com sucesso!";
        } else {
            $_SESSION['erro'] = "Erro ao atualizar dados.";
        }

        header('Location: /configuracoes');
        exit;
    }
}
}