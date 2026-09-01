<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel Pastoral - SIGEIGREJA</title>

    <!-- CSS Exclusivo Pastoral -->
    <link rel="stylesheet" href="<c:url value='/assets/css/stylePastoral.css'/>">
    <!-- FontAwesome para Ícones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js para Gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="app-layout">

    <jsp:include page="/includes/sidebar.jsp" />

    <div class="main-content">

        <jsp:include page="/includes/header.jsp" />

        <div class="dashboard-container">
            <!-- Cabeçalho de Boas-Vindas -->
            <header class="welcome-header">
                <h2><i class="fa-solid fa-church"></i> Painel Pastoral</h2>
                <p>Visão geral sobre o crescimento da igreja e administração das cerimônias espirituais.</p>
            </header>

            <!-- Grid de Cards de Resumo -->
            <section class="cards-grid">
                <div class="stat-card">
                    <div class="card-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="card-info">
                        <span class="card-title">Total de Membros</span>
                        <span class="card-value">${totalMembros != null ? totalMembros : 0}</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon success"><i class="fa-solid fa-water"></i></div>
                    <div class="card-info">
                        <span class="card-title">Batizados</span>
                        <span class="card-value">${totalBatizados != null ? totalBatizados : 0}</span>
                    </div>
                </div>

                <div class="stat-card alert">
                    <div class="card-icon danger"><i class="fa-solid fa-clock"></i></div>
                    <div class="card-info">
                        <span class="card-title">Aguardando Batismo</span>
                        <span class="card-value">${totalAguardando != null ? totalAguardando : 0}</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon info"><i class="fa-solid fa-user-plus"></i></div>
                    <div class="card-info">
                        <span class="card-title">Entradas / Mês Atual</span>
                        <span class="card-value">+${entradasMes != null ? entradasMes : 0}</span>
                    </div>
                </div>
            </section>

            <!-- Seção Principal: Gráfico e Ações Rápidas -->
            <div class="dashboard-main-grid">
                <!-- Gráfico de Crescimento -->
                <article class="chart-card">
                    <div class="card-header-title">
                        <h3><i class="fa-solid fa-chart-line"></i> Crescimento de Membros (Histórico)</h3>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="growthChart"></canvas>
                    </div>
                </article>

                <!-- Painel Lateral Pastoral -->
                <aside class="action-card">
                    <div class="card-header-title">
                        <h3><i class="fa-solid fa-list-check"></i> Ação Pastoral Rápida</h3>
                    </div>
                    <p class="action-desc">
                        Gerencie as chamadas das cerimônias e confirme os candidatos batizados.
                    </p>
                    <a href="<c:url value='/pastoral/confirmar-batismo'/>" class="btn-pastoral">
                        <i class="fa-solid fa-check-double"></i> Confirmar Batismos Pendentes
                    </a>

                    <div class="recent-section">
                        <h4><i class="fa-solid fa-user-clock"></i> Últimos Cadastrados</h4>
                        <ul class="recent-list">
                            <c:forEach var="membro" items="${ultimosMembros}">
                                <li>
                                    <span class="member-name">${membro.nome}</span>
                                    <span class="badge ${membro.statusBatismo == 'BATIZADO' ? 'badge-info' : 'badge-warning'}">
                                        ${membro.statusBatismo}
                                    </span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty ultimosMembros}">
                                <li class="empty-msg">Nenhum registro recente encontrado.</li>
                            </c:if>
                        </ul>
                    </div>
                </aside>
            </div>
        </div>
    </div>

    <!-- Script de Inicialização do Chart.js -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const ctx = document.getElementById('growthChart').getContext('2d');

            const labelsMeses = ${labelsMesesJson != null ? labelsMesesJson : "['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago']"};
            const dadosMembros = ${dadosCrescimentoJson != null ? dadosCrescimentoJson : "[12, 19, 25, 32, 40, 48, 55, 60]"};

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labelsMeses,
                    datasets: [{
                        label: 'Número Total de Membros',
                        data: dadosMembros,
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.08)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.3,
                        pointBackgroundColor: '#0d6efd',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: '#e9ecef' }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>