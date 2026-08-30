package controller.secretaria;

import model.Crente;
import model.Usuario;
import service.PastorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/secretaria/pastores/cadastrar")
public class PastorServlet extends HttpServlet {

    private PastorService pastorService = new PastorService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Validate limit before parsing full request
            if (!pastorService.podeCadastrarPastor()) {
                session.setAttribute("mensagemErro", "Não foi possível cadastrar. O limite de 3 pastores já foi atingido.");
                response.sendRedirect(request.getContextPath() + "/secretaria/membros");
                return;
            }

            // Extract form parameters
            String nome = request.getParameter("nome");
            String dataNascimentoStr = request.getParameter("dataNascimento");
            String telefone = request.getParameter("telefone");
            String estadoCivil = request.getParameter("estadoCivil");
            String dataEntradaStr = request.getParameter("dataEntrada");
            int idGrupo = Integer.parseInt(request.getParameter("idGrupo"));

            // User credentials
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");

            // Build Crente bean
            Crente pastorMembro = new Crente();
            pastorMembro.setNome(nome);
            pastorMembro.setDataNascimento(Date.valueOf(dataNascimentoStr));
            pastorMembro.setTelefone(telefone);
            pastorMembro.setEstadoCivil(estadoCivil);
            pastorMembro.setStatusBatismo("BATIZADO"); // Pastors are batizados by default
            pastorMembro.setDataEntrada(Date.valueOf(dataEntradaStr));
            pastorMembro.setIdgrupo(idGrupo);

            // Save pastor
            pastorService.cadastrarPastor(pastorMembro, email, senha, usuarioLogado.getIdusuario());

            session.setAttribute("mensagemSucesso", "Pastor cadastrado com sucesso!");
        } catch (IllegalStateException e) {
            session.setAttribute("mensagemErro", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensagemErro", "Erro interno ao cadastrar pastor: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/secretaria/membros");
    }
}