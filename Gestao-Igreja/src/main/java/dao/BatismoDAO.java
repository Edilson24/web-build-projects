package dao;

import model.Batismo;
import model.DetalheBatismo;
import model.Usuario;
import util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BatismoDAO {

    // Criar nova cerimônia de batismo
    public boolean cadastrarBatismo(Batismo batismo) throws SQLException {
        String sql = "INSERT INTO batismos (data, local, idpastor) VALUES (?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, batismo.getData());
            stmt.setString(2, batismo.getLocal());
            stmt.setInt(3, batismo.getIdpastor());
            return stmt.executeUpdate() > 0;
        }
    }

    // Listar todas as cerimônias com o nome do pastor e total de inscritos
    public List<Batismo> listarTodos() throws SQLException {
        List<Batismo> lista = new ArrayList<>();
        String sql = "SELECT b.*, u.nome AS nome_pastor, " +
                "(SELECT COUNT(*) FROM detalhe_batismo db WHERE db.idbatismo = b.idbatismo) AS total_candidatos " +
                "FROM batismos b " +
                "JOIN usuarios u ON b.idpastor = u.idusuario " +
                "ORDER BY b.data DESC";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Batismo b = new Batismo();
                b.setIdbatismo(rs.getInt("idbatismo"));
                b.setData(rs.getDate("data"));
                b.setLocal(rs.getString("local"));
                b.setIdpastor(rs.getInt("idpastor"));
                b.setNomePastor(rs.getString("nome_pastor"));
                b.setTotalCandidatos(rs.getInt("total_candidatos"));
                lista.add(b);
            }
        }
        return lista;
    }

    // Buscar lista de pastores ativos para o combo de cadastro
    public List<Usuario> listarPastores() throws SQLException {
        List<Usuario> pastores = new ArrayList<>();
        String sql = "SELECT idusuario, nome FROM usuarios WHERE funcao = 'PASTOR'";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdusuario(rs.getInt("idusuario"));
                u.setNome(rs.getString("nome"));
                pastores.add(u);
            }
        }
        return pastores;
    }

    // Contar inscritos em uma cerimônia específica
    public int contarCandidatosPorBatismo(int idBatismo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM detalhe_batismo WHERE idbatismo = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idBatismo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // Adicionar Candidato (Com validação do limite de 10 e alteração de status)
    public boolean adicionarCandidato(int idBatismo, int idCrente, String padrinho, String madrinha) throws SQLException {
        // Trava de Segurança: Não permite ultrapassar 10 candidatos
        if (contarCandidatosPorBatismo(idBatismo) >= 10) {
            throw new SQLException("Limite máximo de 10 candidatos por cerimônia atingido!");
        }

        Connection conn = null;
        try {
            conn = Conexao.getConexao();
            conn.setAutoCommit(false); // Transação iniciada

            // 1. Inserir no detalhe_batismo
            String sqlInsert = "INSERT INTO detalhe_batismo (idbatismo, idcrente, padrinho, madrinha, confirmado) VALUES (?, ?, ?, ?, 0)";
            try (PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert)) {
                stmtInsert.setInt(1, idBatismo);
                stmtInsert.setInt(2, idCrente);
                stmtInsert.setString(3, padrinho);
                stmtInsert.setString(4, madrinha);
                stmtInsert.executeUpdate();
            }

            // 2. Atualizar status do crente para AGUARDANDO_BATISMO
            String sqlUpdateStatus = "UPDATE crentes SET status_batismo = 'AGUARDANDO_BATISMO' WHERE idcrente = ?";
            try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdateStatus)) {
                stmtUpdate.setInt(1, idCrente);
                stmtUpdate.executeUpdate();
            }

            conn.commit(); // Efetiva ambas as alterações
            return true;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.setAutoCommit(true);
        }
    }

    // Listar candidatos de uma cerimônia
    public List<DetalheBatismo> listarCandidatosPorBatismo(int idBatismo) throws SQLException {
        List<DetalheBatismo> lista = new ArrayList<>();
        String sql = "SELECT db.*, c.nome AS nome_crente " +
                "FROM detalhe_batismo db " +
                "JOIN crentes c ON db.idcrente = c.idcrente " +
                "WHERE db.idbatismo = ? ORDER BY c.nome";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idBatismo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    DetalheBatismo d = new DetalheBatismo();
                    d.setIddetalhe(rs.getInt("iddetalhe"));
                    d.setIdbatismo(rs.getInt("idbatismo"));
                    d.setIdcrente(rs.getInt("idcrente"));
                    d.setNomeCrente(rs.getString("nome_crente"));
                    d.setPadrinho(rs.getString("padrinho"));
                    d.setMadrinha(rs.getString("madrinha"));
                    d.setConfirmado(rs.getBoolean("confirmado"));
                    lista.add(d);
                }
            }
        }
        return lista;
    }
}