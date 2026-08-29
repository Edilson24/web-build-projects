package controller.dashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");

        switch (usuario.getFuncao()) {
            case "ADMINISTRADOR":
                req.getRequestDispatcher("/views/dashboard/dashboard_admin.jsp").forward(req, resp);
                break;
            case "SECRETARIO":
                req.getRequestDispatcher("/views/dashboard/dashboard_secretaria.jsp").forward(req, resp);
                break;
            case "TESOUREIRO":
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