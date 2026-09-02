package controller.secretaria;

import dao.CrenteDAO;
import model.Crente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Usuario;
import service.LogService;
import service.PastorService;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/secretaria/membros")
public class CrenteServlet extends HttpServlet {

    private CrenteDAO crenteDAO = new CrenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Crente> membros = crenteDAO.listarTodos();
            request.setAttribute("membros", membros);
            request.getRequestDispatcher("/views/secretaria/membros.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar lista de membros.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null || (!"SECRETARIO".equalsIgnoreCase(usuarioLogado.getFuncao()) && !"ADMINISTRADOR".equalsIgnoreCase(usuarioLogado.getFuncao()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String acao = request.getParameter("acao");

        try {
            if ("cadastrar".equals(acao)) {
                String tipoCadastro = request.getParameter("tipoCadastro");

                Crente novo = new Crente();
                novo.setNome(request.getParameter("nome"));
                novo.setDataNascimento(Date.valueOf(request.getParameter("dataNascimento")));
                novo.setTelefone(request.getParameter("telefone"));
                novo.setEndereco(request.getParameter("endereco"));
                novo.setEstadoCivil(request.getParameter("estadoCivil"));

                // Get dataEntrada or default to today's date
                String dataEntradaStr = request.getParameter("dataEntrada");
                if (dataEntradaStr != null && !dataEntradaStr.isEmpty()) {
                    novo.setDataEntrada(Date.valueOf(dataEntradaStr));
                } else {
                    novo.setDataEntrada(new Date(System.currentTimeMillis()));
                }

                // Group selection (defaulting to 1 if empty)
                String idGrupoStr = request.getParameter("idGrupo");
                if (idGrupoStr == null || idGrupoStr.isEmpty()) {
                    idGrupoStr = request.getParameter("idgrupo");
                }

                if (idGrupoStr != null && !idGrupoStr.isEmpty()) {
                    novo.setIdgrupo(Integer.parseInt(idGrupoStr));
                } else {
                    novo.setIdgrupo(1);
                }

                // Check if registering a PASTOR vs regular MEMBRO
                if ("PASTOR".equals(tipoCadastro)) {
                    PastorService pastorService = new PastorService();

                    // Business Rule: Validate limit (< 3 pastores)
                    if (!pastorService.podeCadastrarPastor()) {
                        response.sendRedirect(request.getContextPath() + "/secretaria/membros?erro=limitePastores");
                        return;
                    }

                    String email = request.getParameter("email");
                    String senha = request.getParameter("senha");

                    // Pastors start as BATIZADO
                    novo.setStatusBatismo("BATIZADO");

                    // Create record in 'crentes' and account in 'usuarios'
                    pastorService.cadastrarPastor(novo, email, senha, usuarioLogado.getIdusuario());
                    response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=pastorCadastrado");

                } else {
                    // Business Rule: Regular members start as NAO_BATIZADO
                    novo.setStatusBatismo("NAO_BATIZADO");

                    crenteDAO.cadastrar(novo);
                    LogService.registrar(usuarioLogado.getIdusuario(), "SECRETARIA", "Cadastrou novo membro: " + novo.getNome());
                    response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=cadastrado");
                }

            } else if ("vincularParentesco".equals(acao)) {
                int idCrente1 = Integer.parseInt(request.getParameter("idcrente1"));
                int idCrente2 = Integer.parseInt(request.getParameter("idcrente2"));
                String tipo = request.getParameter("tipoParentesco");

                crenteDAO.adicionarParentesco(idCrente1, idCrente2, tipo);
                LogService.registrar(usuarioLogado.getIdusuario(), "SECRETARIA", "Vinculou parentesco entre IDs: " + idCrente1 + " e " + idCrente2);
                response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=parentesco");

            } else if ("atualizar".equals(acao)) {
                Crente c = new Crente();
                c.setIdcrente(Integer.parseInt(request.getParameter("idcrente")));
                c.setNome(request.getParameter("nome"));
                c.setDataNascimento(Date.valueOf(request.getParameter("dataNascimento")));
                c.setTelefone(request.getParameter("telefone"));
                c.setEndereco(request.getParameter("endereco"));
                c.setEstadoCivil(request.getParameter("estadoCivil"));
                c.setStatusBatismo(request.getParameter("statusBatismo"));

                String idGrupoStr = request.getParameter("idGrupo");
                if (idGrupoStr == null || idGrupoStr.isEmpty()) {
                    idGrupoStr = request.getParameter("idgrupo");
                }

                if (idGrupoStr != null && !idGrupoStr.isEmpty()) {
                    c.setIdgrupo(Integer.parseInt(idGrupoStr));
                }

                crenteDAO.atualizar(c);
                LogService.registrar(usuarioLogado.getIdusuario(), "SECRETARIA", "Atualizou dados do membro: " + c.getNome());
                response.sendRedirect(request.getContextPath() + "/secretaria/membros?sucesso=atualizado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/secretaria/membros?erro=operacao");
        }
    }
}