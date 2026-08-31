<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- Retrieve current logged-in user from session --%>
<c:set var="user" value="${sessionScope.usuarioLogado}" />

<header class="top-header" style="background-color: #1a365d; color: #ffffff; padding: 12px 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">

    <!-- System Logo / Title -->
    <div class="header-brand" style="display: flex; align-items: center; gap: 12px;">
        <i class="fa-solid fa-church" style="font-size: 24px; color: #ffffff;"></i>
        <span style="font-size: 20px; font-weight: bold; letter-spacing: 0.5px;">SIGEIGREJA</span>
    </div>

    <!-- User Info & Logout Options -->
    <div class="header-user-info" style="display: flex; align-items: center; gap: 15px;">

        <c:if var="hasUser" test="${not empty user}">
            <!-- User Role Badge -->
            <span class="user-role-badge" style="background-color: rgba(255, 255, 255, 0.2); padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase;">
                ${user.funcao}
            </span>

            <!-- User Avatar & Details -->
            <div style="display: flex; align-items: center; gap: 10px;">
                <c:choose>
                    <c:when test="${not empty user.fotoUrl}">
                        <img src="${user.fotoUrl}" alt="${user.nome}" style="width: 38px; height: 38px; border-radius: 50%; object-fit: cover; border: 2px solid #ffffff;">
                    </c:when>
                    <c:otherwise>
                        <%-- ui-avatars.com Fallback for user without custom avatar --%>
                        <img src="https://ui-avatars.com/api/?name=${user.nome}&background=0D8ABC&color=fff&bold=true&size=128"
                             alt="${user.nome}"
                             style="width: 38px; height: 38px; border-radius: 50%; object-fit: cover; border: 2px solid #ffffff;">
                    </c:otherwise>
                </c:choose>

                <div style="display: flex; flex-direction: column;">
                    <span style="font-size: 14px; font-weight: bold;">${user.nome}</span>
                    <span style="font-size: 11px; opacity: 0.8;">${user.email}</span>
                </div>
            </div>

            <!-- Logout Link -->
            <a href="<%= request.getContextPath() %>/logout"
               title="Sair do Sistema"
               style="color: #ffffff; text-decoration: none; margin-left: 10px; font-size: 18px; padding: 6px; border-radius: 4px; transition: background 0.2s;">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </c:if>

        <c:if test="${not hasUser}">
            <a href="<%= request.getContextPath() %>/login" style="color: #ffffff; text-decoration: none; font-weight: bold;">
                <i class="fa-solid fa-lock"></i> Entrar
            </a>
        </c:if>

    </div>
</header>