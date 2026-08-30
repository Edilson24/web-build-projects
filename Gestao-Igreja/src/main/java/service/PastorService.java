package service;

import dao.CrenteDAO;
import dao.UsuarioDAO;
import model.Crente;
import model.Usuario;

import java.sql.SQLException;

public class PastorService {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private CrenteDAO crenteDAO = new CrenteDAO();

    // Check if system already reached the 3-pastor limit
    public boolean podeCadastrarPastor() throws SQLException {
        int totalPastores = usuarioDAO.contarUsuariosPorFuncao("PASTOR");
        return totalPastores < 3;
    }

    public void cadastrarPastor(Crente crente, String email, String senha, int idUsuarioLogado) throws Exception {
        if (!podeCadastrarPastor()) {
            throw new IllegalStateException("Limite máximo de 3 pastores atingido!");
        }

        // 1. Insert pastor as a member in 'crentes'
        int idCrenteGerado = crenteDAO.cadastrar(crente);

        if (idCrenteGerado <= 0) {
            throw new SQLException("Erro ao registrar os dados pessoais do pastor.");
        }

        // 2. Create access account in 'usuarios'
        Usuario usuario = new Usuario();
        usuario.setIdcrente(idCrenteGerado);
        usuario.setNome(crente.getNome());
        usuario.setEmail(email);
        usuario.setSenha(senha); // Apply BCrypt / hash if implemented in your project
        usuario.setFuncao("PASTOR");
        usuario.setFotoUrl(crente.getFotoUrl());

        usuarioDAO.cadastrar(usuario);

        // 3. Register Audit Log
        LogService.registrar(idUsuarioLogado, "SECRETARIA", "Cadastrou o pastor: " + crente.getNome());
    }
}