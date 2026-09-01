package controller.pastoral;

import dao.CultoDAO;
import model.Culto;
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
import java.sql.Time;

@WebServlet("/pastoral/culto")
public class CultoServlet extends HttpServlet {

    private final CultoDAO cultoDAO = new CultoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;
        String acao = request.getParameter("acao");

        try {
            if ("cadastrar".equals(acao) || "editar".equals(acao)) {
                String diaSemana = request.getParameter("diaSemana");
                String inicioStr = request.getParameter("horarioInicio");
                String fimStr = request.getParameter("horarioFim");
                String descricao = request.getParameter("descricao");

                // Garante o formato HH:mm:ss antes de converter para java.sql.Time
                if (inicioStr != null && inicioStr.length() == 5) {
                    inicioStr += ":00";
                }
                if (fimStr != null && fimStr.length() == 5) {
                    fimStr += ":00";
                }

                Culto culto = new Culto();
                culto.setDiaSemana(diaSemana);
                culto.setHorarioInicio(Time.valueOf(inicioStr));
                culto.setHorarioFim(Time.valueOf(fimStr));
                culto.setDescricao(descricao);

                if ("cadastrar".equals(acao)) {
                    boolean ok = cultoDAO.cadastrar(culto);
                    if (ok) {
                        LogService.registrar(usuarioLogado.getIdusuario(), "PASTORAL", "Cadastrou horário de culto: " + descricao);
                        response.sendRedirect(request.getContextPath() + "/dashboard?sucesso=culto_criado");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard?erro=conflito_horario");
                    }
                } else {
                    int idCulto = Integer.parseInt(request.getParameter("idculto"));
                    culto.setIdculto(idCulto);
                    boolean ok = cultoDAO.atualizar(culto);
                    if (ok) {
                        LogService.registrar(usuarioLogado.getIdusuario(), "PASTORAL", "Atualizou horário de culto ID: " + idCulto);
                        response.sendRedirect(request.getContextPath() + "/dashboard?sucesso=culto_atualizado");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard?erro=conflito_horario");
                    }
                }

            } else if ("excluir".equals(acao)) {
                int idCulto = Integer.parseInt(request.getParameter("idculto"));
                cultoDAO.excluir(idCulto);
                LogService.registrar(usuarioLogado.getIdusuario(), "PASTORAL", "Removeu horário de culto ID: " + idCulto);
                response.sendRedirect(request.getContextPath() + "/dashboard?sucesso=culto_excluido");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?erro=erro_bd");
        }
    }
}