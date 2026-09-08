<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Painel do Administrador - SIGEIGREJA</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/styleAdmin.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styleTesouraria.css">
        <link rel="stylesheet" href="<c:url value='/assets/css/stylePastoral.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="app-container" style="display: flex;">

        <jsp:include page="/includes/sidebar.jsp" />

        <main class="main-content" style="flex: 1; padding: 24px; background-color: #f7fafc;">
            <h2><i class="fa-solid fa-user-shield"></i> Painel de Controle Global (Administrador)</h2>
            <p style="color: #718096; margin-bottom: 20px;">Visão completa dos módulos do sistema e atividades de auditoria.</p>

            <!-- Cards de Acesso Geral aos Departamentos -->
            <section class="cards-grid">
                <div class="stat-card" style="border-left: 4px solid #3182ce;">
                    <div class="card-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="card-info">
                        <span class="card-title">Secretaria</span>
                        <span class="card-value">${totalMembros != null ? totalMembros : 0} Membros</span>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 4px solid #38a169;">
                    <div class="card-icon success"><i class="fa-solid fa-vault"></i></div>
                    <div class="card-info">
                        <span class="card-title">Tesouraria</span>
                        <span class="card-value">Módulo Ativo</span>
                    </div>
                </div>

                <div class="stat-card" style="border-left: 4px solid #805ad5;">
                    <div class="card-icon info"><i class="fa-solid fa-cross"></i></div>
                    <div class="card-info">
                        <span class="card-title">Pastoral</span>
                        <span class="card-value">${totalBatizados != null ? totalBatizados : 0} Batizados</span>
                    </div>
                </div>

                <div class="stat-card alert" style="border-left: 4px solid #dd6b20;">
                    <div class="card-icon danger"><i class="fa-solid fa-scroll"></i></div>
                    <div class="card-info">
                        <span class="card-title">Auditoria</span>
                        <span class="card-value"><a href="${pageContext.request.contextPath}/admin/logs" style="color: #dd6b20; text-decoration: none;">Ver Logs</a></span>
                    </div>
                </div>
            </section>

            <!-- Atalhos de Gestão Global -->
            <article class="chart-card" style="margin-top: 24px; background: #fff; padding: 20px; border-radius: 8px;">
                <h3><i class="fa-solid fa-cubes"></i> Acesso Rápido a Todos os Módulos</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
                    <a href="${pageContext.request.contextPath}/secretaria/membros" class="btn-pastoral" style="text-align: center; text-decoration: none; padding: 12px; background: #2b6cb0;">
                        <i class="fa-solid fa-user-plus"></i> Gerenciar Crentes
                    </a>
                    <a href="${pageContext.request.contextPath}/pastoral/confirmar-batismo" class="btn-pastoral" style="text-align: center; text-decoration: none; padding: 12px; background: #2f855a;">
                        <i class="fa-solid fa-water"></i> Gestão de Batismos
                    </a>
                    <a href="${pageContext.request.contextPath}/tesouraria/movimentacoes" class="btn-pastoral" style="text-align: center; text-decoration: none; padding: 12px; background: #d69e2e;">
                        <i class="fa-solid fa-receipt"></i> Lançamentos Financeiros
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/logs" class="btn-pastoral" style="text-align: center; text-decoration: none; padding: 12px; background: #c53030;">
                        <i class="fa-solid fa-shield-halved"></i> Registros de Auditoria
                    </a>
                </div>
            </article>

        </main>
    </div>
</body>
</html>