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
        boolean isLoginRoute = uri.endsWith("/login") || uri.endsWith("/login.jsp") || uri.contains("LoginServlet");
        boolean isStaticResource = uri.contains("/assets/") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png");

        boolean isLogged = (session != null && session.getAttribute("usuarioLogado") != null);

        if (isLogged) {
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
            String funcao = usuario.getFuncao();

            // 1. Validação de Acesso Exclusivo aos Logs (Apenas ADMINISTRADOR)
            if (uri.contains("/admin/") && !"ADMINISTRADOR".equalsIgnoreCase(funcao)) {
                resp.sendRedirect(contextPath + "/dashboard?erro=acesso_negado");
                return;
            }

            // 2. Restrição do Módulo da Secretaria (ADMINISTRADOR e SECRETARIO)
            if (uri.contains("/secretaria/") && !"ADMINISTRADOR".equalsIgnoreCase(funcao) && !"SECRETARIO".equalsIgnoreCase(funcao)) {
                resp.sendRedirect(contextPath + "/dashboard?erro=acesso_negado");
                return;
            }

            // 3. Restrição do Módulo de Tesouraria (ADMINISTRADOR e TESOUREIRO)
            if (uri.contains("/movimentacoes") && !"ADMINISTRADOR".equalsIgnoreCase(funcao) && !"TESOUREIRO".equalsIgnoreCase(funcao)) {
                resp.sendRedirect(contextPath + "/dashboard?erro=acesso_negado");
                return;
            }

            // 4. Restrição do Módulo Pastoral (ADMINISTRADOR e PASTOR)
            if (uri.contains("/pastoral/") && !"ADMINISTRADOR".equalsIgnoreCase(funcao) && !"PASTOR".equalsIgnoreCase(funcao)) {
                resp.sendRedirect(contextPath + "/dashboard?erro=acesso_negado");
                return;
            }

            chain.doFilter(request, response);

        } else if (isLoginRoute || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(contextPath + "/login");
        }
    }
}