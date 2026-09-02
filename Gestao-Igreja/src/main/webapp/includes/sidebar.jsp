<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Usuario" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    String funcao = (usuarioLogado != null) ? usuarioLogado.getFuncao() : "";
%>

<aside class="sidebar-menu">
    <div class="user-profile">
        <img src="<%= usuarioLogado.getFotoUrl() %>" alt="Foto Perfil" class="avatar-img" />
        <div class="user-info">
            <span class="user-name"><%= usuarioLogado.getNome() %></span>
            <span class="user-role"><%= usuarioLogado.getFuncao() %></span>
        </div>
    </div>

    <nav class="nav-links">
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>

        <%-- Acesso Secretaria / Admin --%>
        <% if ("SECRETARIO".equals(funcao) || "ADMINISTRADOR".equals(funcao)) { %>
            <a href="<%= request.getContextPath() %>/secretaria/membros">Membros (Crentes)</a>
            <a href="<%= request.getContextPath() %>/secretaria/batismos">Agendamento Batismos</a>
        <% } %>

        <%-- Acesso Tesouraria / Admin --%>
        <% if ("TESOUREIRO".equals(funcao) || "ADMINISTRADOR".equals(funcao)) { %>
            <a href="<%= request.getContextPath() %>/movimentacoes">Movimentações Financeiras</a>
        <% } %>

        <%-- Acesso Pastoral --%>
        <% if ("PASTOR".equals(funcao) || "ADMINISTRADOR".equals(funcao)) { %>
            <a href="<%= request.getContextPath() %>/pastoral/confirmar-batismo">Confirmação de Batismo</a>
        <% } %>

        <%-- Acesso Exclusivo do Administrador aos Logs--%>
        <% if ("ADMINISTRADOR".equals(funcao)) { %>
            <a href="<%= request.getContextPath() %>/admin/logs" class="menu-admin">Logs de Auditoria</a>
        <% } %>

        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Sair</a>
    </nav>
</aside>