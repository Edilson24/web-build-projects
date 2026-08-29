package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

import java.io.IOException;

@WebFilter("/*")
public class AutenticacaoFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Recursos públicos que não exigem autenticação
        boolean isLoginRoute = uri.endsWith("/login") || uri.endsWith("/login.jsp") || uri.endsWith("LoginServlet");
        boolean isStaticResource = uri.contains("/assets/") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png");

        boolean isLogged = (session != null && session.getAttribute("usuarioLogado") != null);

        if (isLogged || isLoginRoute || isStaticResource) {
            if (isLogged) {
                Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
                String funcao = usuario.getFuncao();

                // Validação de acesso exclusivo do ADMINISTRADOR aos logs[cite: 5, 6]
                if (uri.contains("/admin/logs") && !"ADMINISTRADOR".equalsIgnoreCase(funcao)) {
                    resp.sendRedirect(contextPath + "/views/dashboard/dashboard.jsp?erro=acesso_negado");
                    return;
                }
            }
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(contextPath + "/views/login/login.jsp");
        }
    }
}