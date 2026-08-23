<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Relatorios.aspx.vb" Inherits="SIGEBIBLIOTECA.Relatorios" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <title>Relatórios e Exportação - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        body { background-color: #F8FCFD; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #1E3F4A; }
        .main-content { margin-left: 250px; padding: 30px; transition: all 0.3s ease; }
        
        .card-custom {
            background-color: #FFFFFF;
            border: 1px solid #D1E9EE;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(30, 63, 74, 0.05);
        }

        .btn-custom-primary {
            background-color: #4299A3;
            color: #FFFFFF;
            border: none;
            font-weight: 600;
        }
        .btn-custom-primary:hover {
            background-color: #357A82;
            color: #FFFFFF;
        }

        .btn-custom-pdf {
            background-color: #1E3F4A;
            color: #FFFFFF;
            border: none;
            font-weight: 600;
        }
        .btn-custom-pdf:hover {
            background-color: #142B33;
            color: #FFFFFF;
        }

        .table-custom th { background-color: #1E3F4A; color: #FFFFFF; font-weight: 600; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:MenuLateral runat="server" ID="ucMenuLateral" />

        <div class="main-content">
            <!-- Cabeçalho -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold" style="color: #1E3F4A;">
                        <i class="fa-solid fa-file-pdf me-2" style="color: #4299A3;"></i>Relatórios e Exportação PDF
                    </h3>
                    <p class="text-muted mb-0">Filtre as informações do sistema e gere relatórios consolidados em formato PDF.</p>
                </div>
            </div>

            <!-- Painel de Filtros -->
            <div class="card card-custom p-4 mb-4">
                <h5 class="fw-bold mb-3" style="color: #1E3F4A;"><i class="fas fa-filter me-2" style="color: #4299A3;"></i>Filtros de Pesquisa</h5>
                
                <div class="row g-3">
                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold">Tipo de Relatório</label>
                        <asp:DropDownList ID="ddlTipoRelatorio" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTipoRelatorio_SelectedIndexChanged">
                            <asp:ListItem Value="EMPRESTIMOS">Histórico de Empréstimos</asp:ListItem>
                            <asp:ListItem Value="DEVOLUCOES">Devoluções Concluídas</asp:ListItem>
                            <asp:ListItem Value="LEITORES">Cadastros de Leitores</asp:ListItem>

                            <asp:ListItem Value="LIVROS">Acervo de Livros</asp:ListItem>
                            <asp:ListItem Value="ARRECADACAO">Relatório Finanças / Arrecadação</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold">Data Inicial</label>
                        <asp:TextBox ID="txtDataInicio" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold">Data Final</label>
                        <asp:TextBox ID="txtDataFim" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-3">
                        <label class="form-label fw-bold">Filtro Secundário (Status / Termo)</label>
                        <asp:TextBox ID="txtTermoBusca" runat="server" CssClass="form-control" Placeholder="Ex: Nome, Categoria, Código..."></asp:TextBox>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    <asp:Button ID="btnFiltrar" runat="server" Text=" Visualizar Dados" CssClass="btn btn-custom-primary px-4" OnClick="btnFiltrar_Click" />
                    <asp:Button ID="btnExportarPDF" runat="server" Text=" Exportar para PDF" CssClass="btn btn-custom-pdf px-4" OnClick="btnExportarPDF_Click" />
                </div>
            </div>

            <!-- Tabela de Pré-visualização -->
            <div class="card card-custom p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0" style="color: #1E3F4A;">
                        <i class="fas fa-table me-2" style="color: #4299A3;"></i>Pré-visualização dos Registros
                    </h5>
                    <span class="badge bg-secondary p-2">
                        Total de Registros: <asp:Label ID="lblTotalRegistros" runat="server" Text="0"></asp:Label>
                    </span>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvRelatorio" runat="server" AutoGenerateColumns="true" CssClass="table table-hover align-middle mb-0 table-custom" GridLines="None" EmptyDataText="Nenhum registro encontrado para os filtros selecionados.">
                    </asp:GridView>
                </div>
            </div>

        </div>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>