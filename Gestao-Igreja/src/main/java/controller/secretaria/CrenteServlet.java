package controller.secretaria;

import dao.CrenteDAO;
import model.Crente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/secretaria/membros")
public class CrenteServlet extends HttpServlet {

    private CrenteDAO crenteDAO = new CrenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Crente> membros = crenteDAO.listarTodos();
            request.setAttribute("membros", membros);
            request.getRequestDispatcher("/views/secretaria/membros.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar lista de membros.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");

        try {
            if ("cadastrar".equals(acao)) {
                Crente novo = new Crente();
                novo.setNome(request.getParameter("nome"));
                novo.setDataNascimento(Date.valueOf(request.getParameter("dataNascimento")));
                novo.setTelefone(request.getParameter("telefone"));
                novo.setEndereco(request.getParameter("endereco"));
                novo.setEstadoCivil(request.getParameter("estadoCivil"));

                // Trava da Regra de Negócio: Todo novo crente inicia como NÃO BATIZADO
                novo.setStatusBatismo("NAO_BATIZADO");
                novo.setDataEntrada(new Date(System.currentTimeMillis()));

                String idGrupoStr = request.getParameter("idgrupo");
                if (idGrupoStr != null && !idGrupoStr.isEmpty()) {
                    novo.setIdgrupo(Integer.parseInt(idGrupoStr));
                }else {
                    // ID do grupo padrão no seu banco (exemplo: 1 - Grupo Geral)
                    novo.setIdgrupo(1);
                }

                crenteDAO.cadastrar(novo);
                response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=cadastrado");

            } else if ("vincularParentesco".equals(acao)) {
                int idCrente1 = Integer.parseInt(request.getParameter("idcrente1"));
                int idCrente2 = Integer.parseInt(request.getParameter("idcrente2"));
                String tipo = request.getParameter("tipoParentesco");

                crenteDAO.adicionarParentesco(idCrente1, idCrente2, tipo);
                response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=parentesco");
            } else if ("atualizar".equals(acao)) {
                Crente c = new Crente();
                c.setIdcrente(Integer.parseInt(request.getParameter("idcrente")));
                c.setNome(request.getParameter("nome"));
                c.setDataNascimento(Date.valueOf(request.getParameter("dataNascimento")));
                c.setTelefone(request.getParameter("telefone"));
                c.setEndereco(request.getParameter("endereco"));
                c.setEstadoCivil(request.getParameter("estadoCivil"));
                c.setStatusBatismo(request.getParameter("statusBatismo"));

                String idGrupoStr = request.getParameter("idgrupo");
                if (idGrupoStr != null && !idGrupoStr.isEmpty()) {
                    c.setIdgrupo(Integer.parseInt(idGrupoStr));
                }

                crenteDAO.atualizar(c);
                response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=atualizado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/secretaria/membros?erro=operacao");
        }
    }
}