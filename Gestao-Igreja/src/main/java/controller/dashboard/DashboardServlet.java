package controller.dashboard;

import dao.CrenteDAO;
import dao.CultoDAO;
import dao.MovimentacaoFinanceiraDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Crente;
import model.Culto;
import model.Usuario;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    CrenteDAO crenteDAO = new CrenteDAO();

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
                try {
                    req.setAttribute("totalMembros", crenteDAO.contarTotalMembros());
                    req.setAttribute("totalBatizados", crenteDAO.contarBatizados());
                    req.getRequestDispatcher("/views/dashboard/dashboard_admin.jsp").forward(req, resp);
                    req.getRequestDispatcher("/views/dashboard/dashboard_admin.jsp").forward(req, resp);

                if ("PASTOR".equalsIgnoreCase(usuario.getFuncao())) {
                    req.getRequestDispatcher("/views/dashboard/dashboard_pastor.jsp").forward(req, resp);

                } else if ("SECRETARIO".equalsIgnoreCase(usuario.getFuncao())) {
                    req.getRequestDispatcher("/views/dashboard/dashboard_secretaria.jsp").forward(req, resp);

                } else if ("TESOUREIRO".equalsIgnoreCase(usuario.getFuncao())) {
                    resp.sendRedirect(req.getContextPath() + "/movimentacoes");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/login");
                }

                }catch (SQLException e){
                    e.printStackTrace();
                }

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
                try{
                    // Instâncias das DAOs

                    CultoDAO cultoDAO = new CultoDAO();

                    // Buscando os totais do banco de dados
                    int totalMembros = crenteDAO.contarTotalMembros();
                    int totalBatizados = crenteDAO.contarBatizados();
                    int totalAguardando = crenteDAO.contarAguardandoBatismo();
                    int entradasMes = crenteDAO.contarEntradasMesAtual();
                    List<Crente> ultimosMembros = crenteDAO.listarUltimosCadastrados(5);
                    List<Culto> listaCultos = cultoDAO.listarTodos();

                    // Injetando no Request Scope
                    req.setAttribute("totalMembros", totalMembros);
                    req.setAttribute("totalBatizados", totalBatizados);
                    req.setAttribute("totalAguardando", totalAguardando);
                    req.setAttribute("entradasMes", entradasMes);
                    req.setAttribute("ultimosMembros", ultimosMembros);
                    req.setAttribute("listaCultos", listaCultos);

                    // Encaminhamento para a JSP
                    req.getRequestDispatcher("/views/dashboard/dashboard_pastor.jsp").forward(req, resp);

                } catch (SQLException e) {
                    e.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/login?erro=erro_bd");
                }
        break;

            default:
                resp.sendRedirect(req.getContextPath() + "/logout");
            break;
        }
    }
}