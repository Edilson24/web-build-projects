<?php
require_once __DIR__ . '/../../config/database.php';

class SupportTicket {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    /**
     * Cria um novo chamado de suporte
     */
    public function createTicket(int $userId, string $assunto, string $mensagem): bool {
        try {
            $this->db->beginTransaction();

            // Insere o ticket principal
            $stmt = $this->db->prepare("INSERT INTO chamados_suporte (usuario_id, assunto, status) VALUES (:usuario_id, :assunto, 'aberto')");
            $stmt->execute([
                ':usuario_id' => $userId,
                ':assunto'    => $assunto
            ]);

            $ticketId = (int)$this->db->lastInsertId();

            // Insere a primeira mensagem
            $stmtMsg = $this->db->prepare("INSERT INTO mensagens_suporte (chamado_id, usuario_id, mensagem) VALUES (:chamado_id, :usuario_id, :mensagem)");
            $stmtMsg->execute([
                ':chamado_id' => $ticketId,
                ':usuario_id' => $userId,
                ':mensagem'   => $mensagem
            ]);

            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }

    /**
     * Busca os chamados de um utilizador específico
     */
    public function getTicketsByUser(int $userId): array {
        $stmt = $this->db->prepare("SELECT * FROM chamados_suporte WHERE usuario_id = :usuario_id ORDER BY atualizado_em DESC");
        $stmt->execute([':usuario_id' => $userId]);
        return $stmt->fetchAll();
    }

    /**
     * Busca um chamado específico e valida a quem pertence
     */
    public function getTicketById(int $ticketId, int $userId, string $userPerfil): ?array {
        if ($userPerfil === 'admin') {
            $stmt = $this->db->prepare("SELECT c.*, u.nome as cliente_nome FROM chamados_suporte c JOIN usuarios u ON c.usuario_id = u.id WHERE c.id = :id LIMIT 1");
            $stmt->execute([':id' => $ticketId]);
        } else {
            $stmt = $this->db->prepare("SELECT c.*, u.nome as cliente_nome FROM chamados_suporte c JOIN usuarios u ON c.usuario_id = u.id WHERE c.id = :id AND c.usuario_id = :usuario_id LIMIT 1");
            $stmt->execute([':id' => $ticketId, ':usuario_id' => $userId]);
        }
        $ticket = $stmt->fetch();
        return $ticket ?: null;
    }

    /**
     * Busca todas as mensagens de um chamado
     */
    public function getTicketMessages(int $ticketId): array {
        $sql = "SELECT m.*, u.nome as remetente_nome, u.tipo_perfil 
                FROM mensagens_suporte m 
                JOIN usuarios u ON m.usuario_id = u.id 
                WHERE m.chamado_id = :chamado_id 
                ORDER BY m.criado_em ASC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':chamado_id' => $ticketId]);
        return $stmt->fetchAll();
    }

    /**
     * Adiciona resposta a um chamado de suporte
     */
    public function addMessage(int $ticketId, int $userId, string $mensagem): bool {
        try {
            $this->db->beginTransaction();

            $stmt = $this->db->prepare("INSERT INTO mensagens_suporte (chamado_id, usuario_id, mensagem) VALUES (:chamado_id, :usuario_id, :mensagem)");
            $stmt->execute([
                ':chamado_id' => $ticketId,
                ':usuario_id' => $userId,
                ':mensagem'   => $mensagem
            ]);

            // Atualiza o timestamp e status do chamado
            $stmtUpdate = $this->db->prepare("UPDATE chamados_suporte SET atualizado_em = NOW() WHERE id = :id");
            $stmtUpdate->execute([':id' => $ticketId]);

            $this->db->commit();
            return true;
        } catch (Exception $e) {
            $this->db->rollBack();
            return false;
        }
    }
}