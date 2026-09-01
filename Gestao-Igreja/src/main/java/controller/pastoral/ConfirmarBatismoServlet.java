package controller.pastoral;

import dao.BatismoDAO;
import model.Batismo;
import model.Crente;
import model.Usuario;
import service.LogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/pastoral/confirmar-batismo")
public class ConfirmarBatismoServlet extends HttpServlet {

    private final BatismoDAO batismoDAO = new BatismoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idBatismoParam = request.getParameter("idBatismo");

        try {
            if (idBatismoParam != null && !idBatismoParam.isEmpty()) {
                // Carrega a lista de candidatos de um batismo específico
                int idBatismo = Integer.parseInt(idBatismoParam);
                List<Crente> candidatos = batismoDAO.pastorlistarCandidatosPorBatismo(idBatismo);
                request.setAttribute("candidatos", candidatos);
                request.setAttribute("idBatismoSelecionado", idBatismo);
            }

            // Sempre carrega todas as cerimônias para montar a seleção/dropdown
            List<Batismo> batismos = batismoDAO.listarTodos();
            request.setAttribute("batismos", batismos);

            request.getRequestDispatcher("/views/pastoral/confirmacao_batismo.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?erro=erro_bd");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        String idBatismoParam = request.getParameter("idBatismo");
        String[] idsCrentesConfirmados = request.getParameterValues("membrosConfirmados");

        if (idBatismoParam == null || idsCrentesConfirmados == null || idsCrentesConfirmados.length == 0) {
            response.sendRedirect(request.getContextPath() +
                    "/pastoral/confirmar-batismo?idBatismo=" + idBatismoParam + "&erro=nenhum_selecionado");
            return;
        }

        try {
            int idBatismo = Integer.parseInt(idBatismoParam);
            boolean sucesso = batismoDAO.confirmarBatismoMembros(idBatismo, idsCrentesConfirmados);

            if (sucesso && usuarioLogado != null) {
                // Grava o Log de Auditoria no módulo PASTORAL
                LogService.registrar(
                        usuarioLogado.getIdusuario(),
                        "PASTORAL",
                        "Confirmou o batismo de " + idsCrentesConfirmados.length + " membro(s) na cerimônia ID: " + idBatismo
                );

                response.sendRedirect(request.getContextPath() +
                        "/pastoral/confirmar-batismo?sucesso=true");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/pastoral/confirmar-batismo?idBatismo=" + idBatismoParam + "&erro=falha_atualizacao");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                    "/pastoral/confirmar-batismo?erro=erro_bd");
        }
    }
}