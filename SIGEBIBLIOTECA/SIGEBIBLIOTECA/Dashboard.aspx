<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Dashboard.aspx.vb" Inherits="SIGEBIBLIOTECA.Dashboard" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <title>Painel de Controle - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body { background-color: #F8FCFD; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #1E3F4A; }
        .main-content { margin-left: 250px; padding: 30px; transition: all 0.3s ease; }
        
        .card-stat {
            background-color: #FFFFFF;
            border: 1px solid #D1E9EE;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(30, 63, 74, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card-stat:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(30, 63, 74, 0.1); }
        
        .icon-box {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            background-color: rgba(66, 153, 163, 0.12);
            color: #4299A3;
        }

        .table-custom th { background-color: #1E3F4A; color: #FFFFFF; font-weight: 600; }
        .badge-custom { background-color: #4299A3; color: #FFFFFF; font-size: 0.8rem; border-radius: 6px; padding: 5px 10px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:MenuLateral runat="server" ID="ucMenuLateral" />

        <div class="main-content">
            <!-- Cabeçalho -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold" style="color: #1E3F4A;"><i class="fa-solid fa-chart-pie me-2" style="color: #4299A3;"></i>Painel de Controle</h3>
                    <p class="text-muted mb-0">Resumo consolidado e indicadores de desempenho em tempo real.</p>
                </div>
                <span class="badge bg-white text-dark border p-2 shadow-sm" style="border-color: #D1E9EE !important;">
                    <i class="far fa-calendar-alt text-primary me-2" style="color: #4299A3 !important;"></i>
                    <%= DateTime.Now.ToString("dd/MM/yyyy") %>
                </span>
            </div>

            <!-- Cards de Estatísticas Globais -->
            <div class="row g-3 mb-4">
                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Empréstimos Ativos</small>
                                <h3 class="fw-bold my-1" style="color: #1E3F4A;"><asp:Literal ID="litEmprestimosAtivos" runat="server">0</asp:Literal></h3>
                                <span class="badge bg-warning text-dark"><i class="fas fa-clock me-1"></i> Em andamento</span>
                            </div>
                            <div class="icon-box">
                                <i class="fas fa-book-reader"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Devoluções</small>
                                <h3 class="fw-bold my-1" style="color: #1E3F4A;"><asp:Literal ID="litDevolucoes" runat="server">0</asp:Literal></h3>
                                <span class="badge bg-success"><i class="fas fa-check-circle me-1"></i> Concluídos</span>
                            </div>
                            <div class="icon-box">
                                <i class="fas fa-file-invoice"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Receita Arrecadada</small>
                                <h3 class="fw-bold my-1" style="color: #1E3F4A;"><asp:Literal ID="litReceitaTotal" runat="server">0,00 MT</asp:Literal></h3>
                                <span class="badge" style="background-color: #4299A3;"><i class="fas fa-wallet me-1"></i> Total acumulado</span>
                            </div>
                            <div class="icon-box">
                                <i class="fas fa-hand-holding-dollar"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="card card-stat p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Total de Leitores</small>
                                <h3 class="fw-bold my-1" style="color: #1E3F4A;"><asp:Literal ID="litTotalLeitores" runat="server">0</asp:Literal></h3>
                                <span class="badge" style="background-color: #1E3F4A;"><i class="fas fa-users me-1"></i> Cadastrados</span>
                            </div>
                            <div class="icon-box">
                                <i class="fas fa-user-graduate"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gráfico de Evolução de Arrecadação -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card card-stat p-4">
                        <h5 class="fw-bold mb-3" style="color: #1E3F4A;"><i class="fas fa-chart-line me-2" style="color: #4299A3;"></i>Evolução de Arrecadação Mensal (Aluguéis e Multas em MT)</h5>
                        <div style="height: 280px;">
                            <canvas id="chartRenda"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabelas de Destaques -->
            <div class="row g-4">
                <!-- Leitores Mais Frequentes -->
                <div class="col-12 col-lg-6">
                    <div class="card card-stat p-3">
                        <h5 class="fw-bold mb-3" style="color: #1E3F4A;"><i class="fas fa-user-check me-2" style="color: #4299A3;"></i>Leitores Mais Frequentes</h5>
                        <div class="table-responsive">
                            <asp:GridView ID="gvLeitoresFrequentes" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle mb-0 table-custom" GridLines="None" EmptyDataText="Nenhum leitor registrado em empréstimos.">
                                <Columns>
                                    <asp:BoundField DataField="NomeLeitor" HeaderText="Leitor" HeaderStyle-CssClass="fw-bold" />
                                    <asp:TemplateField HeaderText="Empréstimos">
                                        <ItemTemplate>
                                            <%# Eval("QtdEmprestimos") %> livros
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Situação">
                                        <ItemTemplate>
                                            <span class="badge badge-custom"><i class="fa-solid fa-check me-1"></i>Ativo</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <!-- Livros Mais Solicitados -->
                <div class="col-12 col-lg-6">
                    <div class="card card-stat p-3">
                        <h5 class="fw-bold mb-3" style="color: #1E3F4A;"><i class="fas fa-book-open me-2" style="color: #4299A3;"></i>Livros Mais Solicitados</h5>
                        <div class="table-responsive">
                            <asp:GridView ID="gvLivrosSolicitados" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle mb-0 table-custom" GridLines="None" EmptyDataText="Nenhum histórico de livro emprestado.">
                                <Columns>
                                    <asp:BoundField DataField="Titulo" HeaderText="Título do Livro" HeaderStyle-CssClass="fw-bold" />
                                    <asp:BoundField DataField="Categoria" HeaderText="Categoria" />
                                    <asp:TemplateField HeaderText="Exemplares">
                                        <ItemTemplate>
                                            <span class="badge" style="background-color: #1E3F4A;"><%# Eval("QtdExemplares") %> un.</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </form>

    <!-- Script Chart.js montado dinamicamente no Code-Behind -->
    <asp:Literal ID="litScriptGrafico" runat="server"></asp:Literal>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>