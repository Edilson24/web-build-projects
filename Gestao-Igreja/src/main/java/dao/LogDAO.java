package dao;

import model.Log;
import util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LogDAO {

    public void salvar(Log log) {
        String sql = "INSERT INTO logs (idusuario, departamento, acao) VALUES (?, ?, ?)";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, log.getIdusuario());
            stmt.setString(2, log.getDepartamento());
            stmt.setString(3, log.getAcao());
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Erro ao gravar log de auditoria: " + e.getMessage());
        }
    }

    public List<Log> listarTodos() throws SQLException {
        List<Log> lista = new ArrayList<>();
        String sql = "SELECT l.*, u.nome AS nome_usuario FROM logs l " +
                "JOIN usuarios u ON l.idusuario = u.idusuario " +
                "ORDER BY l.data_hora DESC LIMIT 100";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Log log = new Log();
                log.setIdlog(rs.getInt("idlog"));
                log.setIdusuario(rs.getInt("idusuario"));
                log.setNomeUsuario(rs.getString("nome_usuario"));
                log.setDepartamento(rs.getString("departamento"));
                log.setAcao(rs.getString("acao"));
                log.setDataHora(rs.getTimestamp("data_hora"));
                lista.add(log);
            }
        }
        return lista;
    }

    public List<Log> listarComFiltros(String depto, String inicio, String fim) throws SQLException {
        List<Log> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT l.*, u.nome AS nome_usuario FROM logs l " +
                        "JOIN usuarios u ON l.idusuario = u.idusuario WHERE 1=1 "
        );

        if (depto != null && !depto.isEmpty()) {
            sql.append(" AND l.departamento = ?");
        }
        if (inicio != null && !inicio.isEmpty()) {
            sql.append(" AND DATE(l.data_hora) >= ?");
        }
        if (fim != null && !fim.isEmpty()) {
            sql.append(" AND DATE(l.data_hora) <= ?");
        }
        sql.append(" ORDER BY l.data_hora DESC");

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (depto != null && !depto.isEmpty()) {
                stmt.setString(paramIndex++, depto);
            }
            if (inicio != null && !inicio.isEmpty()) {
                stmt.setString(paramIndex++, inicio);
            }
            if (fim != null && !fim.isEmpty()) {
                stmt.setString(paramIndex++, fim);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Log log = new Log();
                    log.setIdlog(rs.getInt("idlog"));
                    log.setIdusuario(rs.getInt("idusuario"));
                    log.setNomeUsuario(rs.getString("nome_usuario"));
                    log.setDepartamento(rs.getString("departamento"));
                    log.setAcao(rs.getString("acao"));
                    log.setDataHora(rs.getTimestamp("data_hora"));
                    lista.add(log);
                }
            }
        }
        return lista;
    }
}