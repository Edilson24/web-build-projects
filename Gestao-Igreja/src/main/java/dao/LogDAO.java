package dao;

import model.Log;
import util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
}