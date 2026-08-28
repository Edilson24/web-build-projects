<?php
require_once __DIR__ . '/../../config/database.php';

class LogModel {
    private $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    /**
     * Regista uma ação ou tentativa de invasão na tabela de logs
     */
    public function registrar($nomeUsuario, $acao, $avaliacao) {
        $stmt = $this->db->prepare("
            INSERT INTO logs_sistema (nome_usuario, acao, avaliacao) 
            VALUES (:nome_usuario, :acao, :avaliacao)
        ");
        return $stmt->execute([
            ':nome_usuario' => $nomeUsuario ?: 'Visitante/Anónimo',
            ':acao'         => $acao,
            ':avaliacao'    => $avaliacao
        ]);
    }

    /**
     * Retorna todos os logs para exibição no painel admin
     */
    public function obterTodos() {
        $stmt = $this->db->query("SELECT * FROM logs_sistema ORDER BY data DESC");
        return $stmt->fetchAll();
    }

    /**
     * Retorna apenas os alertas de segurança mais recentes para o pop-up
     */
    public function obterAlertasSegurancaRecentes() {
        $stmt = $this->db->query("
            SELECT * FROM logs_sistema 
            WHERE acao LIKE 'tentativa de invasao%' 
            ORDER BY data DESC LIMIT 5
        ");
        return $stmt->fetchAll();
    }

    // Busca os últimos N logs para a mini tabela do Dashboard
    public function obterUltimosLogs($limite = 3) {
        $stmt = $this->db->prepare("
            SELECT id, nome_usuario, acao, avaliacao, data 
            FROM logs_sistema 
            ORDER BY id DESC 
            LIMIT :limite
        ");
        $stmt->bindValue(':limite', (int)$limite, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}