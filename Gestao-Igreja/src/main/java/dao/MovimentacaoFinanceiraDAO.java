package dao;

import model.MovimentacaoFinanceira;
import util.Conexao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class MovimentacaoFinanceiraDAO {

    public boolean cadastrar(MovimentacaoFinanceira mov) throws SQLException {
        String sql = "INSERT INTO movimentacoes_financeiras " +
                "(tipo_movimentacao, categoria, valor, data, idcrente, tipo_contribuidor, nome_contribuidor_externo, observacao_nota, idusuario_registro) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, mov.getTipoMovimentacao());
            stmt.setString(2, mov.getCategoria());
            stmt.setBigDecimal(3, mov.getValor());
            stmt.setDate(4, mov.getData());

            if (mov.getIdcrente() != null) {
                stmt.setInt(5, mov.getIdcrente());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            stmt.setString(6, mov.getTipoContribuidor());
            stmt.setString(7, mov.getNomeContribuidorExterno());
            stmt.setString(8, mov.getObservacaoNota());
            stmt.setInt(9, mov.getIdusuarioRegistro());

            return stmt.executeUpdate() > 0;
        }
    }

    public List<MovimentacaoFinanceira> listarTodas() throws SQLException {
        List<MovimentacaoFinanceira> lista = new ArrayList<>();
        String sql = "SELECT m.*, c.nome AS nome_membro " +
                "FROM movimentacoes_financeiras m " +
                "LEFT JOIN crentes c ON m.idcrente = c.idcrente " +
                "ORDER BY m.data DESC, m.idmovimentacao DESC";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                MovimentacaoFinanceira m = new MovimentacaoFinanceira();
                m.setIdmovimentacao(rs.getInt("idmovimentacao"));
                m.setTipoMovimentacao(rs.getString("tipo_movimentacao"));
                m.setCategoria(rs.getString("categoria"));
                m.setValor(rs.getBigDecimal("valor"));
                m.setData(rs.getDate("data"));

                int idCrente = rs.getInt("idcrente");
                if (!rs.wasNull()) {
                    m.setIdcrente(idCrente);
                }

                m.setTipoContribuidor(rs.getString("tipo_contribuidor"));
                m.setNomeContribuidorExterno(rs.getString("nome_contribuidor_externo"));
                m.setObservacaoNota(rs.getString("observacao_nota"));
                m.setIdusuarioRegistro(rs.getInt("idusuario_registro"));

                // Resolve readable name for contributor
                if ("ANONIMO".equals(m.getTipoContribuidor())) {
                    m.setNomeContribuidor("Anônimo");
                } else if (m.getNomeContribuidorExterno() != null && !m.getNomeContribuidorExterno().isEmpty()) {
                    m.setNomeContribuidor(m.getNomeContribuidorExterno());
                } else if (rs.getString("nome_membro") != null) {
                    m.setNomeContribuidor(rs.getString("nome_membro"));
                } else {
                    m.setNomeContribuidor("Ofertório Coletivo / Geral");
                }

                lista.add(m);
            }
        }
        return lista;
    }

    public BigDecimal obterTotalPorCategoria(String categoria) throws SQLException {
        String sql = "SELECT SUM(valor) FROM movimentacoes_financeiras WHERE categoria = ? AND tipo_movimentacao = 'ENTRADA'";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, categoria);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getBigDecimal(1) != null) {
                    return rs.getBigDecimal(1);
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal obterTotalOfertorioColetivo() throws SQLException {
        return obterTotalPorCategoria("OFERTORIO_COLETIVO");
    }

    public Map<String, List<BigDecimal>> obterTotaisMensaisAnoAtual() throws SQLException {
        List<BigDecimal> entradas = new ArrayList<>(Collections.nCopies(12, BigDecimal.ZERO));
        List<BigDecimal> saidas = new ArrayList<>(Collections.nCopies(12, BigDecimal.ZERO));

        String sql = "SELECT tipo_movimentacao, MONTH(data) AS mes, SUM(valor) AS total " +
                "FROM movimentacoes_financeiras " +
                "WHERE YEAR(data) = YEAR(CURRENT_DATE) " +
                "GROUP BY tipo_movimentacao, MONTH(data)";

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String tipo = rs.getString("tipo_movimentacao");
                int mes = rs.getInt("mes") - 1; // Ajusta índice de 0 a 11
                BigDecimal total = rs.getBigDecimal("total");

                if ("ENTRADA".equals(tipo)) {
                    entradas.set(mes, total);
                } else if ("SAIDA".equals(tipo)) {
                    saidas.set(mes, total);
                }
            }
        }

        Map<String, List<BigDecimal>> resultado = new HashMap<>();
        resultado.put("entradas", entradas);
        resultado.put("saidas", saidas);
        return resultado;
    }
}