package dao;

import model.Culto;
import util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CultoDAO {

    /**
     * Valida se existe choque de horário no mesmo dia da semana.
     * Fórmula SQL para sobreposição: (NovoInicio < FimExistente) AND (NovoFim > InicioExistente)
     */
    public boolean verificarConflitoHorario(String diaSemana, Time inicio, Time fim, int idCultoIgnorar) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cultos WHERE dia_semana = ? " +
                "AND (? < horario_fim AND ? > horario_inicio) AND idculto != ?";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, diaSemana);
            stmt.setTime(2, inicio);
            stmt.setTime(3, fim);
            stmt.setInt(4, idCultoIgnorar);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean cadastrar(Culto culto) throws SQLException {
        if (verificarConflitoHorario(culto.getDiaSemana(), culto.getHorarioInicio(), culto.getHorarioFim(), 0)) {
            return false; // Existe choque de horário
        }

        String sql = "INSERT INTO cultos (dia_semana, horario_inicio, horario_fim, descricao) VALUES (?, ?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, culto.getDiaSemana());
            stmt.setTime(2, culto.getHorarioInicio());
            stmt.setTime(3, culto.getHorarioFim());
            stmt.setString(4, culto.getDescricao());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean atualizar(Culto culto) throws SQLException {
        if (verificarConflitoHorario(culto.getDiaSemana(), culto.getHorarioInicio(), culto.getHorarioFim(), culto.getIdculto())) {
            return false; // Existe choque de horário
        }

        String sql = "UPDATE cultos SET dia_semana = ?, horario_inicio = ?, horario_fim = ?, descricao = ? WHERE idculto = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, culto.getDiaSemana());
            stmt.setTime(2, culto.getHorarioInicio());
            stmt.setTime(3, culto.getHorarioFim());
            stmt.setString(4, culto.getDescricao());
            stmt.setInt(5, culto.getIdculto());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean excluir(int idCulto) throws SQLException {
        String sql = "DELETE FROM cultos WHERE idculto = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idCulto);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Culto> listarTodos() throws SQLException {
        List<Culto> lista = new ArrayList<>();
        // Ordena por dia da semana e horário de início
        String sql = "SELECT * FROM cultos ORDER BY FIELD(dia_semana, 'Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado'), horario_inicio ASC";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Culto c = new Culto();
                c.setIdculto(rs.getInt("idculto"));
                c.setDiaSemana(rs.getString("dia_semana"));
                c.setHorarioInicio(rs.getTime("horario_inicio"));
                c.setHorarioFim(rs.getTime("horario_fim"));
                c.setDescricao(rs.getString("descricao"));
                lista.add(c);
            }
        }
        return lista;
    }
}