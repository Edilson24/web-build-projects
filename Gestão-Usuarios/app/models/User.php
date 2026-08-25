<?php
require_once __DIR__ . '/../../config/database.php';

class User {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    /**
     * Busca um utilizador pelo E-mail
     */
    public function findByEmail(string $email): ?array {
        $stmt = $this->db->prepare("SELECT * FROM usuarios WHERE email = :email LIMIT 1");
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch();
        return $user ?: null;
    }

    /**
     * Busca um utilizador pelo ID
     */
    public function findById(int $id): ?array {
        $stmt = $this->db->prepare("SELECT * FROM usuarios WHERE id = :id LIMIT 1");
        $stmt->execute([':id' => $id]);
        $user = $stmt->fetch();
        return $user ?: null;
    }

    /**
     * Cadastra um novo utilizador com senha hash[cite: 2]
     */
    public function create(array $data): bool {
        $sql = "INSERT INTO usuarios (nome, email, senha, user_name, tipo_perfil, status) 
                VALUES (:nome, :email, :senha, :user_name, :tipo_perfil, :status)";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':nome'        => $data['nome'],
            ':email'       => $data['email'],
            ':senha'       => password_hash($data['senha'], PASSWORD_DEFAULT), //[cite: 2]
            ':user_name'   => $data['user_name'] ?? null,
            ':tipo_perfil' => $data['tipo_perfil'] ?? 'usuario',
            ':status'      => $data['status'] ?? 'ativo'
        ]);
    }

    /**
     * Salva o token da funcionalidade "Lembrar-me" (Cookie 7 dias)
     */
    public function updateRememberToken(int $userId, ?string $token): bool {
        $stmt = $this->db->prepare("UPDATE usuarios SET remember_token = :token WHERE id = :id");
        return $stmt->execute([
            ':token' => $token,
            ':id'    => $userId
        ]);
    }

    /**
     * Busca utilizador pelo token do cookie "Lembrar-me"[cite: 2, 3]
     */
    public function findByRememberToken(string $token): ?array {
        $stmt = $this->db->prepare("SELECT * FROM usuarios WHERE remember_token = :token LIMIT 1");
        $stmt->execute([':token' => $token]);
        $user = $stmt->fetch();
        return $user ?: null;
    }

    /**
     * Atualiza os dados do perfil do utilizador (Foto, Bio, Tema, Username, Música)
     */
    public function updateProfile(int $userId, array $data): bool {
        $sql = "UPDATE usuarios SET 
                    nome = :nome, 
                    user_name = :user_name, 
                    bio = :bio, 
                    foto_perfil = COALESCE(:foto_perfil, foto_perfil), 
                    musica_url = :musica_url, 
                    tema_preferido = :tema_preferido 
                WHERE id = :id";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':nome'           => $data['nome'],
            ':user_name'      => $data['user_name'] ?: null,
            ':bio'            => $data['bio'] ?: null,
            ':foto_perfil'     => $data['foto_perfil'] ?? null,
            ':musica_url'     => $data['musica_url'] ?: null,
            ':tema_preferido' => $data['tema_preferido'] ?? 'dark',
            ':id'             => $userId
        ]);
    }

    /**
     * Adiciona uma nova rede social ao perfil do utilizador
     */
    public function addSocialLink(int $userId, string $url): bool {
        $stmt = $this->db->prepare("INSERT INTO usuario_redes_sociais (usuario_id, url_link) VALUES (:usuario_id, :url_link)");
        return $stmt->execute([
            ':usuario_id' => $userId,
            ':url_link'   => $url
        ]);
    }

    /**
     * Busca todas as redes sociais cadastradas do utilizador
     */
    public function getSocialLinks(int $userId): array {
        $stmt = $this->db->prepare("SELECT * FROM usuario_redes_sociais WHERE usuario_id = :usuario_id ORDER BY id DESC");
        $stmt->execute([':usuario_id' => $userId]);
        return $stmt->fetchAll();
    }

    /**
     * Remove um link de rede social
     */
    public function deleteSocialLink(int $userId, int $linkId): bool {
        $stmt = $this->db->prepare("DELETE FROM usuario_redes_sociais WHERE id = :id AND usuario_id = :usuario_id");
        return $stmt->execute([':id' => $linkId, ':usuario_id' => $userId]);
    }
}