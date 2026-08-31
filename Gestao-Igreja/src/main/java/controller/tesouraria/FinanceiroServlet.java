package controller.tesouraria;

import dao.CrenteDAO;
import dao.MovimentacaoFinanceiraDAO;
import model.MovimentacaoFinanceira;
import model.Usuario;
import service.LogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

@WebServlet(name = "FinanceiroServlet", urlPatterns = {"/movimentacoes", "/tesouraria/movimentacoes"})
public class FinanceiroServlet extends HttpServlet {

    private final MovimentacaoFinanceiraDAO financeiroDAO = new MovimentacaoFinanceiraDAO();
    private final CrenteDAO crenteDAO = new CrenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("listaMovimentacoes", financeiroDAO.listarTodas());
            request.setAttribute("listaMembros", crenteDAO.listarTodos());

            // Summaries for Dashboard & Cards
            request.setAttribute("totalDizimos", financeiroDAO.obterTotalPorCategoria("DIZIMO"));
            request.setAttribute("totalAcaoGraca", financeiroDAO.obterTotalPorCategoria("ACAO_DE_GRACA"));
            request.setAttribute("totalOfertorios", financeiroDAO.obterTotalOfertorioColetivo());

            request.getRequestDispatcher("/views/tesouraria/movimentacoes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?erro=carregamento");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String acao = request.getParameter("acao");

        try {
            if ("cadastrarEntrada".equals(acao)) {
                String categoria = request.getParameter("categoria"); // DIZIMO, ACAO_DE_GRACA, OFERTORIO_COLETIVO
                BigDecimal valor = new BigDecimal(request.getParameter("valor"));
                Date data = Date.valueOf(request.getParameter("data"));
                String tipoContribuidor = request.getParameter("tipoContribuidor"); // MEMBRO, VISITANTE_INDIVIDUAL, VISITANTE_GRUPO, ANONIMO

                MovimentacaoFinanceira mov = new MovimentacaoFinanceira();
                mov.setTipoMovimentacao("ENTRADA");
                mov.setCategoria(categoria);
                mov.setValor(valor);
                mov.setData(data);
                mov.setTipoContribuidor(tipoContribuidor);
                mov.setIdusuarioRegistro(usuarioLogado.getIdusuario());

                if ("MEMBRO".equals(tipoContribuidor)) {
                    String idCrenteStr = request.getParameter("idcrente");
                    if (idCrenteStr != null && !idCrenteStr.isEmpty()) {
                        mov.setIdcrente(Integer.parseInt(idCrenteStr));
                    }
                } else if ("VISITANTE_INDIVIDUAL".equals(tipoContribuidor) || "VISITANTE_GRUPO".equals(tipoContribuidor)) {
                    mov.setNomeContribuidorExterno(request.getParameter("nomeContribuidorExterno"));
                }

                if ("ACAO_DE_GRACA".equals(categoria)) {
                    mov.setObservacaoNota(request.getParameter("observacaoNota"));
                }

                financeiroDAO.cadastrar(mov);
                LogService.registrar(usuarioLogado.getIdusuario(), "TESOURARIA", "Registrou entrada financeira (" + categoria + "): " + valor + " MT");
                response.sendRedirect(request.getContextPath() + "/tesouraria/movimentacoes?sucesso=entrada");

            } else if ("cadastrarSaida".equals(acao)) {
                BigDecimal valor = new BigDecimal(request.getParameter("valor"));
                Date data = Date.valueOf(request.getParameter("data"));
                String observacaoNota = request.getParameter("observacaoNota");

                // Business Rule: Explanation note is strictly mandatory for expenses
                if (observacaoNota == null || observacaoNota.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/tesouraria/movimentacoes?erro=notaObrigatoria");
                    return;
                }

                MovimentacaoFinanceira mov = new MovimentacaoFinanceira();
                mov.setTipoMovimentacao("SAIDA");
                mov.setCategoria("DESPESA");
                mov.setValor(valor);
                mov.setData(data);
                mov.setObservacaoNota(observacaoNota);
                mov.setTipoContribuidor(null);
                mov.setIdusuarioRegistro(usuarioLogado.getIdusuario());

                financeiroDAO.cadastrar(mov);
                LogService.registrar(usuarioLogado.getIdusuario(), "TESOURARIA", "Registrou saída/despesa: " + valor + " MT - Nota: " + observacaoNota);
                response.sendRedirect(request.getContextPath() + "/tesouraria/movimentacoes?sucesso=saida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/tesouraria/movimentacoes?erro=operacao");
        }
    }
}