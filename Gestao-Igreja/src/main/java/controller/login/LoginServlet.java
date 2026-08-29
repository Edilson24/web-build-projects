package controller.login;

import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;
import service.LogService;
import util.AvatarUtil;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/login/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        Usuario usuario = usuarioDAO.autenticar(email, senha);

        if (usuario != null) {
            HttpSession session = req.getSession();

            // Trata avatar via ui-avatars.com se a foto for nula
            usuario.setFotoUrl(AvatarUtil.obterFoto(usuario.getFotoUrl(), usuario.getNome()));

            session.setAttribute("usuarioLogado", usuario);

            // Registro de auditoria no login[cite: 5, 6]
            LogService.registrar(usuario.getIdusuario(), "SISTEMA", "Usuário realizou login com sucesso.");

            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("erro", "Credenciais inválidas. Verifique seu e-mail e senha.");
            req.getRequestDispatcher("/views/login/login.jsp").forward(req, resp);
        }
    }
}