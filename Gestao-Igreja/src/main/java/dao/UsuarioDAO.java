package dao;

import model.Usuario;
import util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public Usuario autenticar(String email, String senha) {
        String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, senha);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setIdusuario(rs.getInt("idusuario"));
                    usuario.setIdcrente(rs.getObject("idcrente") != null ? rs.getInt("idcrente") : null);
                    usuario.setNome(rs.getString("nome"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setSenha(rs.getString("senha"));
                    usuario.setFuncao(rs.getString("funcao"));
                    usuario.setFotoUrl(rs.getString("foto_url"));
                    return usuario;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao autenticar usuário: " + e.getMessage());
        }
        return null;
    }

    /**
     * Valida o limite estrito de no máximo 3 pastores cadastrados no sistema.
     */
    public int contarPastores() {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE funcao = 'PASTOR'";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Erro ao contar pastores: " + e.getMessage());
        }
        return 0;
    }

    // Count users by role (e.g., 'PASTOR')
    public int contarUsuariosPorFuncao(String funcao) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE funcao = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, funcao);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Insert new user account
    public boolean cadastrar(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO usuarios (idcrente, nome, email, senha, funcao, foto_url) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (usuario.getIdcrente() != null) {
                stmt.setInt(1, usuario.getIdcrente());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, usuario.getNome());
            stmt.setString(3, usuario.getEmail());
            stmt.setString(4, usuario.getSenha());
            stmt.setString(5, usuario.getFuncao());
            stmt.setString(6, usuario.getFotoUrl());

            return stmt.executeUpdate() > 0;
        }
    }
}