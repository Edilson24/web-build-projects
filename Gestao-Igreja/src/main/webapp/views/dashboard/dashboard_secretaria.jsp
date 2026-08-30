<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Usuario, model.Crente, dao.CrenteDAO, java.util.List" %>



<%@ page import="model.Batismo" %>

<%@ page import="dao.BatismoDAO" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%
Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Declaração das variáveis de dados
    int totalMembros = 0;
    int totalBatizados = 0;
    int totalNaoBatizados = 0;
    List<Crente> ultimosMembros = new ArrayList<>();
    List<Batismo> proximosBatismos = new ArrayList<>();

    try {
        // Instâncias DAO e busca de métricas em tempo real (Membros)
        CrenteDAO crenteDAO = new CrenteDAO();
        totalMembros = crenteDAO.contarTotalMembros();
        totalBatizados = crenteDAO.contarPorStatusBatismo("BATIZADO");
        totalNaoBatizados = crenteDAO.contarPorStatusBatismo("NAO_BATIZADO");
        ultimosMembros = crenteDAO.listarUltimosCadastrados(5);

        // Instância DAO e busca de Batismos em tempo real
        BatismoDAO batismoDAO = new BatismoDAO();
        proximosBatismos = batismoDAO.listarTodos();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGEIGREJA - Painel da Secretaria</title>
    <!-- Font Awesome & Chart.js CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styleSecretaria.css">
</head>
<body class="dashboard-body">

    <!-- Topbar -->
    <header class="top-bar">
        <div class="brand">
            <i class="fa-solid fa-church"></i>
            <span>SIGEIGREJA</span>
        </div>
        <div class="user-info">
            <span><i class="fa-solid fa-user-circle"></i> <%= usuario.getNome() %> (<strong><%= usuario.getFuncao() %></strong>)</span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <i class="fa-solid fa-right-from-bracket"></i> Sair
            </a>
        </div>
    </header>

    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/dashboard" class="nav-item active">
                    <i class="fa-solid fa-chart-line"></i> Visão Geral
                </a>
                <a href="<%= request.getContextPath() %>/secretaria/membros" class="nav-item">
                    <i class="fa-solid fa-users"></i> Gestão de Membros
                </a>
                <a href="<%= request.getContextPath() %>/secretaria/batismos" class="nav-item">
                    <i class="fa-solid fa-water"></i> Batismos
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h2>Resumo da Secretaria</h2>
                <p>Indicadores em tempo real obtidos diretamente da base de dados.</p>
            </div>

            <!-- 1. CARDS DE KPIs (Dinâmicos via Banco) -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon blue"><i class="fa-solid fa-users"></i></div>
                    <div class="kpi-data">
                        <span class="kpi-title">Total de Membros</span>
                        <h3 class="kpi-value"><%= totalMembros %></h3>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon green"><i class="fa-solid fa-water"></i></div>
                    <div class="kpi-data">
                        <span class="kpi-title">Membros Batizados</span>
                        <h3 class="kpi-value"><%= totalBatizados %></h3>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon orange"><i class="fa-solid fa-clock"></i></div>
                    <div class="kpi-data">
                        <span class="kpi-title">Não Batizados</span>
                        <h3 class="kpi-value"><%= totalNaoBatizados %></h3>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon purple"><i class="fa-solid fa-calendar-check"></i></div>
                    <div class="kpi-data">
                        <span class="kpi-title">Cerimônias Ativas</span>
                        <h3 class="kpi-value">2</h3>
                    </div>
                </div>
            </div>

            <!-- 2. SEÇÃO DE GRÁFICO (Entre KPIs e Tabelas) -->
            <div class="chart-section">
                <div class="widget-card">
                    <div class="widget-header">
                        <h3><i class="fa-solid fa-chart-area"></i> Crescimento de Novos Membros & Distribuição de Batismo</h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="graficoSecretaria"></canvas>
                    </div>
                </div>
            </div>

            <!-- 3. SEÇÃO DE TABELAS RESUMO -->
            <div class="dashboard-widgets" style="margin-top: 1.5rem;">

                <div class="widget-card flex-2">
                    <div class="widget-header">
                        <h3><i class="fa-solid fa-user-plus"></i> Últimos Crentes Cadastrados</h3>
                        <a href="<%= request.getContextPath() %>/secretaria/membros" class="widget-action">Ver Todos</a>
                    </div>
                    <table class="mini-table">
                        <thead>
                            <tr>
                                <th>Nome</th>
                                <th>Telefone</th>
                                <th>Status Batismo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (ultimosMembros != null && !ultimosMembros.isEmpty()) {
                                  for (Crente c : ultimosMembros) { %>
                                <tr>
                                    <td><strong><%= c.getNome() %></strong></td>
                                    <td><%= c.getTelefone() != null ? c.getTelefone() : "-" %></td>
                                    <td>
                                        <% if ("BATIZADO".equals(c.getStatusBatismo())) { %>
                                            <span class="badge badge-success"><i class="fa-solid fa-check"></i> Batizado</span>
                                        <% } else { %>
                                            <span class="badge badge-warning"><i class="fa-solid fa-hourglass-half"></i> Não Batizado</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%   }
                               } else { %>
                                <tr>
                                    <td colspan="4" style="text-align: center;">Nenhum crente cadastrado até o momento.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- WIDGET 2: PRÓXIMOS BATISMOS (COM DADOS REAIS DO BANCO) -->
                <div class="widget-card flex-1">
                    <div class="widget-header">
                        <h3><i class="fa-solid fa-calendar-days"></i> Próximos Batismos</h3>
                    </div>
                    <div class="activity-list">
                        <%
                            if (proximosBatismos != null && !proximosBatismos.isEmpty()) {
                                // Formata o mês em 3 letras maiúsculas (ex: SET, OUT, NOV)
                                DateTimeFormatter fmtMes = DateTimeFormatter.ofPattern("MMM", new Locale("pt", "BR"));

                                for (Batismo b : proximosBatismos) {
                                    LocalDate dataBatismo = b.getData().toLocalDate();
                                    String dia = String.format("%02d", dataBatismo.getDayOfMonth());
                                    String mes = dataBatismo.format(fmtMes).toUpperCase().replace(".", "");
                        %>
                            <div class="activity-item">
                                <div class="activity-date">
                                    <span class="day"><%= dia %></span>
                                    <span class="month"><%= mes %></span>
                                </div>
                                <div class="activity-details">
                                    <h4><%= b.getLocal() %></h4>
                                    <p><%= b.getTotalCandidatos() %> <%= b.getTotalCandidatos() == 1 ? "candidato inscrito" : "candidatos inscritos" %></p>
                                </div>
                            </div>
                        <%      }
                            } else {
                        %>
                            <div class="activity-item">
                                <div class="activity-details">
                                    <p style="color: #666; font-style: italic;">Nenhuma cerimônia de batismo agendada.</p>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <!-- Script de Inicialização do Gráfico Chart.js -->
    <script>
        const ctx = document.getElementById('graficoSecretaria').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Total Geral', 'Batizados', 'Não Batizados'],
                datasets: [{
                    label: 'Quantidade de Crentes',
                    data: [<%= totalMembros %>, <%= totalBatizados %>, <%= totalNaoBatizados %>],
                    backgroundColor: [
                        '#2563eb', // Ocean Blue
                        '#10b981', // Verde
                        '#D66F1B'  // Laranja Queimado #D66F1B
                    ],
                    borderRadius: 8,
                    maxBarThickness: 50
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f1f5f9' } },
                    x: { grid: { display: false } }
                }
            }
        });
    </script>

</body>
</html>