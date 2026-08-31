<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel da Tesouraria - SIGEIGREJA</title>

    <!-- CSS Principal -->
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/styleTesouraria.css'/>">
    <!-- FontAwesome Ícones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="dashboard-container">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="main-content" style="padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2><i class="fa-solid fa-chart-line"></i> Painel Geral da Tesouraria</h2>
            </div>

            <!-- Cards de Resumo -->
            <div class="cards-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px;">
                <div class="card" style="background: #1a365d; color: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                    <h4 style="margin: 0; opacity: 0.8; font-size: 14px;">Total Dízimos</h4>
                    <p style="font-size: 26px; font-weight: bold; margin: 10px 0 0 0;">
                        <fmt:formatNumber value="${totalDizimos}" type="currency" currencySymbol="MT " minFractionDigits="2" maxFractionDigits="2" />
                    </p>
                </div>

                <div class="card" style="background: #2b6cb0; color: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                    <h4 style="margin: 0; opacity: 0.8; font-size: 14px;">Total Ofertório Coletivo</h4>
                    <p style="font-size: 26px; font-weight: bold; margin: 10px 0 0 0;">
                        <fmt:formatNumber value="${totalOfertorios}" type="currency" currencySymbol="MT " minFractionDigits="2" maxFractionDigits="2" />
                    </p>
                </div>

                <div class="card" style="background: #2c5282; color: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                    <h4 style="margin: 0; opacity: 0.8; font-size: 14px;">Total Ações de Graça</h4>
                    <p style="font-size: 26px; font-weight: bold; margin: 10px 0 0 0;">
                        <fmt:formatNumber value="${totalAcaoGraca}" type="currency" currencySymbol="MT " minFractionDigits="2" maxFractionDigits="2" />
                    </p>
                </div>
            </div>

            <!-- Gráfico Comparativo de Dados Reais -->
            <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 20px;">
                <h3 style="margin-top: 0; color: #1a365d;"><i class="fa-solid fa-chart-area"></i> Entradas vs. Saídas (Comparativo Mensal do Ano Atual)</h3>
                <div style="height: 320px; width: 100%;">
                    <canvas id="financeChart"></canvas>
                </div>
            </div>
        </main>
    </div>

    <script>
        const ctx = document.getElementById('financeChart').getContext('2d');

        // Dados reais vindos do Servlet
        const dadosEntradas = [
            <c:forEach items="${graficoEntradas}" var="valor" varStatus="loop">
                ${valor}${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        const dadosSaidas = [
            <c:forEach items="${graficoSaidas}" var="valor" varStatus="loop">
                ${valor}${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
                datasets: [{
                    label: 'Entradas (MT)',
                    data: dadosEntradas,
                    borderColor: '#2f855a',
                    backgroundColor: 'rgba(47, 133, 90, 0.1)',
                    fill: true,
                    tension: 0.3
                }, {
                    label: 'Saídas / Despesas (MT)',
                    data: dadosSaidas,
                    borderColor: '#c53030',
                    backgroundColor: 'rgba(197, 48, 48, 0.1)',
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    </script>
</body>
</html>