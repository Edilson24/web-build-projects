<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Dashboard.aspx.vb" Inherits="SIGEBIBLIOTECA.Dashboard" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt">
<head runat="server">
    <meta charset="utf-8" />
    <title>Dashboard - GESTÃO DE BIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-content {
            margin-left: 250px;
            padding: 30px;
            transition: all 0.3s ease;
        }
        /* Estilização dos Cards com Gradientes */
        .card-stat {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.2s ease;
        }
        .card-stat:hover {
            transform: translateY(-5px);
        }
        .icon-box {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        /* Tabela Personalizada */
        .table-custom {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <uc:MenuLateral runat="server" ID="ucMenuLateral" />

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-0">Painel de Controle</h3>
                    <p class="text-muted small">Resumo geral das atividades e indicadores da biblioteca.</p>
                </div>
                <span class="badge bg-white text-dark border p-2 shadow-sm">
                    <i class="far fa-calendar-alt text-primary me-2"></i>
                    <%= DateTime.Now.ToString("dd/MM/yyyy") %>
                </span>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat bg-white p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Empréstimos Ativos</small>
                                <h3 class="fw-bold my-1 text-dark">42</h3>
                                <span class="badge bg-warning text-dark"><i class="fas fa-clock me-1"></i> Em andamento</span>
                            </div>
                            <div class="icon-box bg-warning bg-opacity-10 text-warning">
                                <i class="fas fa-book-reader"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat bg-white p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Devoluções</small>
                                <h3 class="fw-bold my-1 text-dark">128</h3>
                                <span class="badge bg-success"><i class="fas fa-check-circle me-1"></i> Concluídos</span>
                            </div>
                            <div class="icon-box bg-success bg-opacity-10 text-success">
                                <i class="fas fa-file-invoice"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat bg-white p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Renda Total (Multas)</small>
                                <h3 class="fw-bold my-1 text-dark">12.450 MZN</h3>
                                <span class="badge bg-info text-dark"><i class="fas fa-arrow-up me-1"></i> +12% este mês</span>
                            </div>
                            <div class="icon-box bg-info bg-opacity-10 text-info">
                                <i class="fas fa-wallet"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat bg-white p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Total de Leitores</small>
                                <h3 class="fw-bold my-1 text-dark">315</h3>
                                <span class="badge bg-primary"><i class="fas fa-user-plus me-1"></i> Cadastrados</span>
                            </div>
                            <div class="icon-box bg-primary bg-opacity-10 text-primary">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-12">
                    <div class="card card-stat bg-white p-4">
                        <h5 class="fw-bold text-dark mb-3"><i class="fas fa-chart-line text-primary me-2"></i>Evolução de Renda por Mês (Multas & Taxas)</h5>
                        <div style="height: 280px;">
                            <canvas id="chartRenda"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-12 col-lg-6">
                    <div class="card card-stat bg-white p-3">
                        <h5 class="fw-bold text-dark mb-3"><i class="fas fa-user-check text-success me-2"></i>Leitores Mais Frequentes</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Leitor</th>
                                        <th>Empréstimos</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Anifa Armando</td>
                                        <td>15 livros</td>
                                        <td><span class="badge bg-success">Regular</span></td>
                                    </tr>
                                    <tr>
                                        <td>Alberto Junjo</td>
                                        <td>12 livros</td>
                                        <td><span class="badge bg-success">Regular</span></td>
                                    </tr>
                                    <tr>
                                        <td>Renildo Cândido</td>
                                        <td>9 livros</td>
                                        <td><span class="badge bg-warning text-dark">Pendência</span></td>
                                    </tr>
                                    <tr>
                                        <td>Robson Muadica</td>
                                        <td>7 livros</td>
                                        <td><span class="badge bg-danger">Bloqueado</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-6">
                    <div class="card card-stat bg-white p-3">
                        <h5 class="fw-bold text-dark mb-3"><i class="fas fa-book-open text-primary me-2"></i>Livros Mais Solicitados</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Título</th>
                                        <th>Categoria</th>
                                        <th>Disponibilidade</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Engenharia de Software</td>
                                        <td>Informatica</td>
                                        <td><span class="badge bg-success">Disponível</span></td>
                                    </tr>
                                    <tr>
                                        <td>Estrutura de Dados em Java</td>
                                        <td>Informatica</td>
                                        <td><span class="badge bg-warning text-dark">Poucas unidades</span></td>
                                    </tr>
                                    <tr>
                                        <td>Redes de Computadores</td>
                                        <td>Informatica</td>
                                        <td><span class="badge bg-danger">Esgotado</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </form>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var ctx = document.getElementById('chartRenda').getContext('2d');
            var chartRenda = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago'],
                    datasets: [{
                        label: 'Renda (MZN)',
                        data: [1200, 1900, 3000, 2500, 4200, 3800, 5100, 12450],
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: { beginAtZero: true }
                    }
                }
            });
        });
    </script>
</body>
</html>