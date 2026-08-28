<?php
require_once __DIR__ . '/../../config/database.php';

class AdminModel {
    private $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function obterTotaisCards() {
        $totalUsuarios = $this->db->query("SELECT COUNT(*) FROM usuarios")->fetchColumn();
        $usuariosAtivos = $this->db->query("SELECT COUNT(*) FROM usuarios WHERE status = 'ativo'")->fetchColumn();
        $usuariosInativos = $this->db->query("SELECT COUNT(*) FROM usuarios WHERE status = 'inativo'")->fetchColumn();
        $totalAtaques = $this->db->query("SELECT COUNT(*) FROM logs_sistema WHERE acao LIKE 'tentativa de invasao%'")->fetchColumn();

        return [
            'total' => $totalUsuarios,
            'ativos' => $usuariosAtivos,
            'inativos' => $usuariosInativos,
            'ataques' => $totalAtaques
        ];
    }

    public function obterFluxoCadastrosMensal() {
$sql = "SELECT 
                DATE_FORMAT(created_at, '%b/%Y') AS mes_ano, 
                COUNT(*) AS total 
            FROM usuarios 
            GROUP BY 
                YEAR(created_at), 
                MONTH(created_at), 
                DATE_FORMAT(created_at, '%b/%Y')
            ORDER BY 
                MIN(created_at) ASC 
            LIMIT 6";

    return $this->db->query($sql)->fetchAll(PDO::FETCH_ASSOC);
    }

    public function obterUltimosLogs($limite = 3) {
        $stmt = $this->db->prepare("SELECT * FROM logs_sistema ORDER BY data DESC LIMIT :limite");
        $stmt->bindValue(':limite', (int)$limite, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }
}