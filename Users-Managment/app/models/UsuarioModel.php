<?php
require_once __DIR__ . '/../../config/database.php';

class UsuarioModel {
    private $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function buscarPorEmail($email) {
        $stmt = $this->db->prepare("SELECT * FROM usuarios WHERE email = :email LIMIT 1");
        $stmt->execute([':email' => $email]);
        return $stmt->fetch();
    }

    public function salvarRememberToken($id, $token) {
        $stmt = $this->db->prepare("UPDATE usuarios SET remember_token = :token WHERE id = :id");
        $stmt->execute([':token' => $token, ':id' => $id]);
    }

    // app/models/UsuarioModel.php

    public function buscarPorRememberToken($token) {
        $stmt = $this->db->prepare("SELECT * FROM usuarios WHERE remember_token = :token LIMIT 1");
        $stmt->execute([':token' => $token]);
        return $stmt->fetch();
    }

// app/models/UsuarioModel.php

    public function cadastrar($dados) {
        // Fallback de avatar público via ui-avatars.com caso a foto não seja enviada
        $foto = !empty($dados['foto']) 
            ? $dados['foto'] 
            : (!empty($dados['foto_perfil']) 
                ? $dados['foto_perfil'] 
                : 'https://ui-avatars.com/api/?name=' . urlencode($dados['nome']) . '&background=random');

        // Trata o campo de nome de utilizador (@user_name) de forma opcional
        $userName = !empty($dados['user_name']) 
            ? $dados['user_name'] 
            : (!empty($dados['username']) ? $dados['username'] : null);

        $stmt = $this->db->prepare("
            INSERT INTO usuarios (nome, email, senha, user_name, foto_perfil, tipo_perfil, status, primeiro_acesso) 
            VALUES (:nome, :email, :senha, :user_name, :foto_perfil, 'usuario', 'ativo', 0)
        ");

        return $stmt->execute([
            ':nome'        => $dados['nome'],
            ':email'       => $dados['email'],
            ':senha'       => password_hash($dados['senha'], PASSWORD_DEFAULT),
            ':user_name'   => $userName,
            ':foto_perfil' => $foto
        ]);
    }

    /**
     * Lista os usuários aplicando busca por nome/e-mail e filtro por status
     */
/**
     * Lista os usuários aplicando busca por nome, e-mail ou user_name e filtro por status
     */
    public function listarComFiltro($busca = '', $status = '') {
        // Mapeia tipo_perfil como perfil para bater com a View
        $sql = "SELECT id, nome, email, user_name, tipo_perfil AS perfil, status, foto_perfil FROM usuarios WHERE 1=1";
        $params = [];

        if (!empty($busca)) {
            $sql .= " AND (nome LIKE :busca OR email LIKE :busca OR user_name LIKE :busca)";
            $params[':busca'] = "%{$busca}%";
        }

        if (!empty($status)) {
            $sql .= " AND status = :status";
            $params[':status'] = $status;
        }

        $sql .= " ORDER BY id DESC";

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Cadastra um novo usuário usando a coluna 'tipo_perfil'
     */
    public function salvar($dados) {
        $sql = "INSERT INTO usuarios (nome, email, senha, tipo_perfil, status) 
                VALUES (:nome, :email, :senha, :tipo_perfil, 'ativo')";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':nome'        => $dados['nome'],
            ':email'       => $dados['email'],
            ':senha'       => password_hash($dados['senha'], PASSWORD_BCRYPT),
            ':tipo_perfil' => $dados['perfil'] ?? 'usuario'
        ]);
    }

    /**
     * Atualiza o cadastro do usuário (Nome, E-mail e Tipo de Perfil)
     */
    public function atualizar($id, $dados) {
        $sql = "UPDATE usuarios 
                SET nome = :nome, email = :email, tipo_perfil = :tipo_perfil 
                WHERE id = :id";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':id'          => $id,
            ':nome'        => $dados['nome'],
            ':email'       => $dados['email'],
            ':tipo_perfil' => $dados['perfil']
        ]);
    }

    /**
     * Alterna o status do usuário entre 'ativo' e 'inativo'
     */
    public function alternarStatus($id) {
        $sql = "UPDATE usuarios SET status = IF(status = 'ativo', 'inativo', 'ativo') WHERE id = :id";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':id' => $id]);
    }

    /**
     * Exclui o registro do usuário
     */
    public function excluir($id) {
        $sql = "DELETE FROM usuarios WHERE id = :id";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':id' => $id]);
    }

    /**
 * Busca os dados completos de um único usuário pelo ID
 */
public function buscarPorId($id) {
    $sql = "SELECT * FROM usuarios WHERE id = :id";
    $stmt = $this->db->prepare($sql);
    $stmt->execute([':id' => $id]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

/**
 * Atualiza todos os dados de perfil e configurações do próprio usuário
 */
public function atualizarPerfilCompleto($id, $dados) {
    $sql = "UPDATE usuarios SET 
                nome = :nome, 
                user_name = :user_name, 
                email = :email, 
                foto_perfil = :foto_perfil, 
                bio = :bio, 
                tema_preferido = :tema_preferido";

    $params = [
        ':id'             => $id,
        ':nome'           => $dados['nome'],
        ':user_name'      => !empty($dados['user_name']) ? $dados['user_name'] : null,
        ':email'          => $dados['email'],
        ':foto_perfil'    => !empty($dados['foto_perfil']) ? $dados['foto_perfil'] : null,
        ':bio'            => !empty($dados['bio']) ? $dados['bio'] : null,
        ':tema_preferido' => $dados['tema_preferido'] ?? 'dark'
    ];

    // Se uma nova senha foi informada, inclui na atualização
    if (!empty($dados['nova_senha'])) {
        $sql .= ", senha = :senha";
        $params[':senha'] = password_hash($dados['nova_senha'], PASSWORD_BCRYPT);
    }

    $sql .= " WHERE id = :id";

    $stmt = $this->db->prepare($sql);
    return $stmt->execute($params);
}


}