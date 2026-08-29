package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Driver JDBC do MySQL não encontrado: " + e.getMessage());
        }
    }
    public static Connection getConexao() throws SQLException {

        // -------------------------------------------------------------
        // CONFIGURAÇÃO 1: MySQL Workbench / Servidor Dedicado (Desenvolvedor)
        // -------------------------------------------------------------
        String urlWorkbench = "jdbc:mysql://localhost:3306/sigeigreja?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String userWorkbench = "root";
        String passWorkbench = "root";

        try {
            Connection con = DriverManager.getConnection(urlWorkbench, userWorkbench, passWorkbench);
            // System.out.println("[DB LOG] Conexão estabelecida via MySQL Workbench / Standalone.");
            return con;
        } catch (SQLException e1) {
            System.out.println("[DB LOG] Falha ao conectar via MySQL Workbench. Tentando fallback para XAMPP...");

            // -------------------------------------------------------------
            // CONFIGURAÇÃO 2: XAMPP (Cliente / Colega)
            // -------------------------------------------------------------
            // Observação: Se o XAMPP do cliente usar a porta 3307, altere abaixo para 3307.
            String urlXampp = "jdbc:mysql://localhost:3306/sigeigreja?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String userXampp = "root";
            String passXampp = "";

            try {
                Connection conXampp = DriverManager.getConnection(urlXampp, userXampp, passXampp);
                System.out.println("[DB LOG] Conexão estabelecida com sucesso via XAMPP!");
                return conXampp;
            } catch (SQLException e2) {
                System.err.println("[DB LOG] ERRO CRÍTICO: Não foi possível conectar ao banco de dados em nenhum dos ambientes!");
                System.err.println("Erro Workbench: " + e1.getMessage());
                System.err.println("Erro XAMPP: " + e2.getMessage());
                throw e2;
            }
        }
    }

    /**
     * Método utilitário para fechar conexões com segurança
     */
    public static void fecharConexao(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                System.err.println("Erro ao fechar a conexão: " + e.getMessage());
            }
        }
    }
}