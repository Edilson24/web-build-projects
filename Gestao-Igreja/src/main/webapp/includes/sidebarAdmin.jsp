<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="model.Usuario" %>

<aside class="sidebar-menu">
    <!-- Perfil do Usuário com Fallback de Avatar -->
    <div class="user-profile">
        <img src="${not empty sessionScope.usuarioLogado.fotoUrl ? sessionScope.usuarioLogado.fotoUrl : 'https://ui-avatars.com/api/?name='.concat(sessionScope.usuarioLogado.nome)}"
             alt="Foto Perfil" class="avatar-img" />
        <div class="user-info">
            <span class="user-name">${sessionScope.usuarioLogado.nome}</span>
            <span class="user-role">${sessionScope.usuarioLogado.funcao}</span>
        </div>
    </div>

    <!-- Navegação Árvore (Tree View estilo IDE) -->
    <nav class="nav-links">

        <!-- PASTA 1: ADMINISTRADOR -->
        <c:if test="${sessionScope.usuarioLogado.funcao == 'ADMINISTRADOR'}">
            <div class="tree-node open" data-nivel="ADMINISTRADOR">
                <div class="tree-header" onclick="toggleTreeNode(this)">
                    <span class="node-title"><i class="fa-solid fa-user-shield"></i> Administração</span>
                    <i class="fa-solid fa-chevron-right chevron-icon"></i>
                </div>
                <div class="tree-content">
                    <a href="${pageContext.request.contextPath}/dashboard" class="${pageContext.request.requestURI.endsWith('dashboard_admin.jsp') ? 'active' : ''}">
                        <i class="fa-solid fa-chart-line"></i> Painel Geral
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/logs" class="${pageContext.request.requestURI.endsWith('logs.jsp') ? 'active' : ''}">
                        <i class="fa-solid fa-scroll"></i> Logs de Auditoria
                    </a>
                </div>
            </div>
        </c:if>

        <!-- PASTA 2: PASTORAL -->
        <c:if test="${sessionScope.usuarioLogado.funcao == 'ADMINISTRADOR' || sessionScope.usuarioLogado.funcao == 'PASTOR'}">
            <div class="tree-node ${sessionScope.usuarioLogado.funcao == 'PASTOR' ? 'open' : ''}">
                <div class="tree-header" onclick="toggleTreeNode(this)">
                    <span class="node-title"><i class="fa-solid fa-cross"></i> Módulo Pastoral</span>
                    <i class="fa-solid fa-chevron-right chevron-icon"></i>
                </div>
                <div class="tree-content">
                    <a href="${pageContext.request.contextPath}/dashboard">
                        <i class="fa-solid fa-gauge"></i> Dashboard Pastor
                    </a>
                    <a href="${pageContext.request.contextPath}/pastoral/confirmar-batismo">
                        <i class="fa-solid fa-water"></i> Confirmar Batismo
                    </a>
                </div>
            </div>
        </c:if>

        <!-- PASTA 3: SECRETARIA -->
        <c:if test="${sessionScope.usuarioLogado.funcao == 'ADMINISTRADOR' || sessionScope.usuarioLogado.funcao == 'SECRETARIO'}">
            <div class="tree-node ${sessionScope.usuarioLogado.funcao == 'SECRETARIO' ? 'open' : ''}">
                <div class="tree-header" onclick="toggleTreeNode(this)">
                    <span class="node-title"><i class="fa-solid fa-folder-open"></i> Módulo Secretaria</span>
                    <i class="fa-solid fa-chevron-right chevron-icon"></i>
                </div>
                <div class="tree-content">
                    <a href="${pageContext.request.contextPath}/secretaria/membros">
                        <i class="fa-solid fa-users"></i> Gestão de Membros
                    </a>
                    <a href="${pageContext.request.contextPath}/secretaria/batismos">
                        <i class="fa-solid fa-calendar-check"></i> Agendar Batismos
                    </a>
                </div>
            </div>
        </c:if>

        <!-- PASTA 4: TESOURARIA -->
        <c:if test="${sessionScope.usuarioLogado.funcao == 'ADMINISTRADOR' || sessionScope.usuarioLogado.funcao == 'TESOUREIRO'}">
            <div class="tree-node ${sessionScope.usuarioLogado.funcao == 'TESOUREIRO' ? 'open' : ''}">
                <div class="tree-header" onclick="toggleTreeNode(this)">
                    <span class="node-title"><i class="fa-solid fa-wallet"></i> Módulo Tesouraria</span>
                    <i class="fa-solid fa-chevron-right chevron-icon"></i>
                </div>
                <div class="tree-content">
                    <a href="${pageContext.request.contextPath}/movimentacoes">
                        <i class="fa-solid fa-money-bill-transfer"></i> Movimentações Financeiras
                    </a>
                </div>
            </div>
        </c:if>

        <!-- BOTÃO DE LOGOUT -->
        <div class="btn-logout-tree">
            <a href="${pageContext.request.contextPath}/logout" style="color: #fc8181; display: flex; align-items: center; gap: 10px; padding: 10px 14px; text-decoration: none; font-size: 13px; font-weight: 600;">
                <i class="fa-solid fa-right-from-bracket"></i> Sair do Sistema
            </a>
        </div>

    </nav>
</aside>

<!-- Script para controle de colapso/expansão das pastas -->
<script>
    function toggleTreeNode(headerElement) {
        const node = headerElement.parentElement;
        node.classList.toggle('open');
    }
</script>