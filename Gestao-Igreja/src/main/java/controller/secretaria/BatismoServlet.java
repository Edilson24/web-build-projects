package controller.secretaria;

import dao.BatismoDAO;
import dao.CrenteDAO;
import model.Batismo;
import model.Crente;
import model.Usuario;
import service.LogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/secretaria/batismos")
public class BatismoServlet extends HttpServlet {

    private BatismoDAO batismoDAO = new BatismoDAO();
    private CrenteDAO crenteDAO = new CrenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Batismo> batismos = batismoDAO.listarTodos();
            List<Usuario> pastores = batismoDAO.listarPastores();

            // Filtra crentes para trazer apenas os elegíveis (NÃO_BATIZADO)
            List<Crente> crentesNaoBatizados = crenteDAO.listarTodos().stream()
                    .filter(c -> "NÃO_BATIZADO".equals(c.getStatusBatismo()))
                    .collect(Collectors.toList());

            request.setAttribute("batismos", batismos);
            request.setAttribute("pastores", pastores);
            request.setAttribute("crentesElegiveis", crentesNaoBatizados);

            request.getRequestDispatcher("/views/secretaria/batismos.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar dados de batismos.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");

        try {
            if ("cadastrarBatismo".equals(acao)) {
                Batismo b = new Batismo();
                b.setData(Date.valueOf(request.getParameter("data")));
                b.setLocal(request.getParameter("local"));
                b.setIdpastor(Integer.parseInt(request.getParameter("idpastor")));

                batismoDAO.cadastrarBatismo(b);

                if (usuarioLogado != null) {
                    LogService.registrar(usuarioLogado.getIdusuario(), "SECRETARIA", "Agendou nova cerimônia de batismo para " + b.getData());
                }

                response.sendRedirect(request.getContextPath() + "/secretaria/batismos?sucesso=cerimonia_criada");

            } else if ("vincularCandidato".equals(acao)) {
                int idBatismo = Integer.parseInt(request.getParameter("idbatismo"));
                int idCrente = Integer.parseInt(request.getParameter("idcrente"));
                String padrinho = request.getParameter("padrinho");
                String madrinha = request.getParameter("madrinha");

                batismoDAO.adicionarCandidato(idBatismo, idCrente, padrinho, madrinha);

                if (usuarioLogado != null) {
                    LogService.registrar(usuarioLogado.getIdusuario(), "SECRETARIA", "Vinculou membro ID " + idCrente + " ao batismo ID " + idBatismo);
                }

                response.sendRedirect(request.getContextPath() + "/secretaria/batismos?sucesso=candidato_vinculado");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/secretaria/batismos?erro=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}