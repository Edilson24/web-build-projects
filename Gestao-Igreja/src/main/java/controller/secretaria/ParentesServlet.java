package controller.secretaria;

import dao.CrenteDAO;
import model.ParenteDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/secretaria/membros/parentes")
public class ParentesServlet extends HttpServlet {

    private CrenteDAO crenteDAO = new CrenteDAO();

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
            int idCrente = Integer.parseInt(idStr);
            List<ParenteDTO> parentes = crenteDAO.buscarParentesPorCrenteId(idCrente);

            // Montagem manual simples de JSON (ou use Gson/Jackson se tiver no projeto)
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < parentes.size(); i++) {
                ParenteDTO p = parentes.get(i);
                json.append(String.format("{\"nome\":\"%s\",\"grau\":\"%s\"}",
                        p.getNome().replace("\"", "\\\""),
                        p.getGrau()));
                if (i < parentes.size() - 1) json.append(",");
            }
            json.append("]");

            out.print(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}