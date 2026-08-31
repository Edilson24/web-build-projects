package controller.dashboard;

import dao.MovimentacaoFinanceiraDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("usuarioLogado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        switch (usuario.getFuncao()) {
            case "ADMINISTRADOR":
                req.getRequestDispatcher("/views/dashboard/dashboard_admin.jsp").forward(req, resp);
                break;

            case "SECRETARIO":
                req.getRequestDispatcher("/views/dashboard/dashboard_secretaria.jsp").forward(req, resp);
                break;

            case "TESOUREIRO":
                try {
                    MovimentacaoFinanceiraDAO dao = new MovimentacaoFinanceiraDAO();

                    req.setAttribute("totalDizimos", dao.obterTotalPorCategoria("DIZIMO"));
                    req.setAttribute("totalAcaoGraca", dao.obterTotalPorCategoria("ACAO_DE_GRACA"));
                    req.setAttribute("totalOfertorios", dao.obterTotalOfertorioColetivo());

                    // Dados reais para o Chart.js
                    Map<String, List<BigDecimal>> dadosGrafico = dao.obterTotaisMensaisAnoAtual();
                    req.setAttribute("graficoEntradas", dadosGrafico.get("entradas"));
                    req.setAttribute("graficoSaidas", dadosGrafico.get("saidas"));

                } catch (SQLException e) {
                    e.printStackTrace();
                    req.setAttribute("totalDizimos", BigDecimal.ZERO);
                    req.setAttribute("totalAcaoGraca", BigDecimal.ZERO);
                    req.setAttribute("totalOfertorios", BigDecimal.ZERO);
                    req.setAttribute("graficoEntradas", Collections.nCopies(12, 0));
                    req.setAttribute("graficoSaidas", Collections.nCopies(12, 0));
                }

                req.getRequestDispatcher("/views/dashboard/dashboard_tesouraria.jsp").forward(req, resp);
            break;

            case "PASTOR":
                req.getRequestDispatcher("/views/dashboard/dashboard_pastor.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/logout");
                break;
        }
    }
}