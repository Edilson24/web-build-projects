package controller.secretaria;

import dao.BatismoDAO;
import model.DetalheBatismo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/secretaria/batismos/candidatos")
public class CandidatosBatismoServlet extends HttpServlet {

    private BatismoDAO batismoDAO = new BatismoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            out.print("[]");
            return;
        }

        try {
            int idBatismo = Integer.parseInt(idStr);
            List<DetalheBatismo> candidatos = batismoDAO.listarCandidatosPorBatismo(idBatismo);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < candidatos.size(); i++) {
                DetalheBatismo d = candidatos.get(i);
                json.append(String.format("{\"nome\":\"%s\",\"padrinho\":\"%s\",\"madrinha\":\"%s\",\"confirmado\":%b}",
                        d.getNomeCrente().replace("\"", "\\\""),
                        d.getPadrinho() != null ? d.getPadrinho().replace("\"", "\\\"") : "",
                        d.getMadrinha() != null ? d.getMadrinha().replace("\"", "\\\"") : "",
                        d.isConfirmado()));
                if (i < candidatos.size() - 1) json.append(",");
            }
            json.append("]");

            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}