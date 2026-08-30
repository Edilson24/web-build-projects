package dao;

import model.Crente;
import model.ParenteDTO;
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

    public int cadastrar(Crente crente) throws SQLException {
        String sql = "INSERT INTO crentes (nome, data_nascimento, telefone, endereco, estado_civil, status_batismo, data_entrada, idgrupo) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, crente.getNome());
            stmt.setDate(2, crente.getDataNascimento());
            stmt.setString(3, crente.getTelefone());
            stmt.setString(4, crente.getEndereco());
            stmt.setString(5, crente.getEstadoCivil());
            stmt.setString(6, crente.getStatusBatismo());
            stmt.setDate(7, crente.getDataEntrada());

            if (crente.getIdgrupo() != null) {
                stmt.setInt(8, crente.getIdgrupo());
            } else {
                stmt.setNull(8, java.sql.Types.INTEGER);
            }

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Returns generated idcrente
                    }
                }
            }
        }
        return -1;
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
        String sql = "INSERT INTO parentescos (idcrente_1, idcrente_2, tipo_vinculo) VALUES (?, ?, ?)";
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

    public List<ParenteDTO> buscarParentesPorCrenteId(int idCrente) throws SQLException {
        List<ParenteDTO> parentes = new ArrayList<>();

        String sql = "SELECT c.nome, p.tipo_vinculo AS grau " +
                "FROM parentescos p " +
                "JOIN crentes c ON p.idcrente_2 = c.idcrente " +
                "WHERE p.idcrente_1 = ? " +
                "UNION " +
                "SELECT c.nome, p.tipo_vinculo AS grau " +
                "FROM parentescos p " +
                "JOIN crentes c ON p.idcrente_1 = c.idcrente " +
                "WHERE p.idcrente_2 = ?";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCrente);
            stmt.setInt(2, idCrente);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    parentes.add(new ParenteDTO(
                            rs.getString("nome"),
                            rs.getString("grau")
                    ));
                }
            }
        }
        return parentes;
    }

    public boolean atualizar(Crente crente) throws SQLException {
        String sql = "UPDATE crentes SET nome = ?, data_nascimento = ?, telefone = ?, endereco = ?, " +
                "estado_civil = ?, status_batismo = ?, idgrupo = ? WHERE idcrente = ?";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, crente.getNome());
            stmt.setDate(2, crente.getDataNascimento());
            stmt.setString(3, crente.getTelefone());
            stmt.setString(4, crente.getEndereco());
            stmt.setString(5, crente.getEstadoCivil());
            stmt.setString(6, crente.getStatusBatismo());

            if (crente.getIdgrupo() != null && crente.getIdgrupo() > 0) {
                stmt.setInt(7, crente.getIdgrupo());
            } else {
                stmt.setNull(7, java.sql.Types.INTEGER);
            }

            stmt.setInt(8, crente.getIdcrente());

            return stmt.executeUpdate() > 0;
        }
    }


}