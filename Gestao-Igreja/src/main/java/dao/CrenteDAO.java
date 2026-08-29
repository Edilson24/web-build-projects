package dao;

import model.Crente;
import util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CrenteDAO {

    public List<Crente> listarTodos() throws SQLException {
        List<Crente> lista = new ArrayList<>();
        String sql = "SELECT c.*, g.nome as nome_grupo FROM crentes c " +
                "LEFT JOIN grupos g ON c.idgrupo = g.idgrupo ORDER BY c.nome ASC";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Crente c = new Crente();
                c.setIdcrente(rs.getInt("idcrente"));
                c.setNome(rs.getString("nome"));
                c.setDataNascimento(rs.getDate("data_nascimento"));
                c.setTelefone(rs.getString("telefone"));
                c.setEndereco(rs.getString("endereco"));
                c.setEstadoCivil(rs.getString("estado_civil"));
                c.setStatusBatismo(rs.getString("status_batismo"));
                c.setDataEntrada(rs.getDate("data_entrada"));
                c.setIdgrupo(rs.getObject("idgrupo") != null ? rs.getInt("idgrupo") : null);
                lista.add(c);
            }
        }
        return lista;
    }

    public boolean cadastrar(Crente crente) throws SQLException {
        String sql = "INSERT INTO crentes (nome, data_nascimento, telefone, endereco, estado_civil, status_batismo, data_entrada, idgrupo) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, crente.getNome());
            stmt.setDate(2, crente.getDataNascimento());
            stmt.setString(3, crente.getTelefone());
            stmt.setString(4, crente.getEndereco());
            stmt.setString(5, crente.getEstadoCivil());

            // Regra de Negócio: Novos cadastros iniciam como NAO_BATIZADO por padrão via Servlet
            stmt.setString(6, crente.getStatusBatismo());
            stmt.setDate(7, crente.getDataEntrada());

            if (crente.getIdgrupo() != null) {
                stmt.setInt(8, crente.getIdgrupo());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean verificarBatismoConcluido(int idcrente) throws SQLException {
        String sql = "SELECT COUNT(*) FROM batismos WHERE idcrente = ? AND status = 'CONCLUIDO'";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idcrente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean adicionarParentesco(int idCrente1, int idCrente2, String tipoParentesco) throws SQLException {
        String sql = "INSERT INTO membro_parentescos (idcrente_1, idcrente_2, tipo_parentesco) VALUES (?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCrente1);
            stmt.setInt(2, idCrente2);
            stmt.setString(3, tipoParentesco);
            return stmt.executeUpdate() > 0;
        }
    }

    // Retorna o total geral de membros/crentes cadastrados
    public int contarTotalMembros() throws SQLException {
        String sql = "SELECT COUNT(*) FROM crentes";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Retorna o total por status de batismo ('BATIZADO' ou 'NAO_BATIZADO')
    public int contarPorStatusBatismo(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM crentes WHERE status_batismo = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // Retorna os últimos N crentes cadastrados para a mini-tabela
    public List<Crente> listarUltimosCadastrados(int limite) throws SQLException {
        List<Crente> lista = new ArrayList<>();
        String sql = "SELECT * FROM crentes ORDER BY idcrente DESC LIMIT ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limite);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Crente c = new Crente();
                    c.setIdcrente(rs.getInt("idcrente"));
                    c.setNome(rs.getString("nome"));
                    c.setTelefone(rs.getString("telefone"));
                    c.setStatusBatismo(rs.getString("status_batismo"));
                    lista.add(c);
                }
            }
        }
        return lista;
    }
}