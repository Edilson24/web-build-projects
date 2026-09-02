package controller.admin;

import dao.LogDAO;
import model.Log;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/logs")
public class LogServlet extends HttpServlet {

    private final LogDAO logDAO = new LogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String departamento = request.getParameter("departamento");
        String dataInicio = request.getParameter("dataInicio");
        String dataFim = request.getParameter("dataFim");

        try {
            List<Log> listaLogs;

            // Aplica filtros se informados na tela
            if ((departamento != null && !departamento.isEmpty()) ||
                    (dataInicio != null && !dataInicio.isEmpty()) ||
                    (dataFim != null && !dataFim.isEmpty())) {
                listaLogs = logDAO.listarComFiltros(departamento, dataInicio, dataFim);
            } else {
                listaLogs = logDAO.listarTodos();
            }

            request.setAttribute("listaLogs", listaLogs);
            request.setAttribute("paramDepto", departamento);
            request.setAttribute("paramDataInicio", dataInicio);
            request.setAttribute("paramDataFim", dataFim);

            request.getRequestDispatcher("/views/admin/logs.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?erro=erro_bd");
        }
    }
}