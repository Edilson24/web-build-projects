<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Logs.aspx.vb" Inherits="SIGEBIBLIOTECA.views.Logs" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <title>Logs de Auditoria - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #F8FCFD; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #1E3F4A; }
        .main-content { margin-left: 250px; padding: 30px; }
        .card-custom { background-color: #FFFFFF; border: 1px solid #D1E9EE; border-radius: 12px; box-shadow: 0 4px 12px rgba(30, 63, 74, 0.08); }
        .table-custom th { background-color: #1E3F4A; color: #FFFFFF; font-weight: 600; }
        .badge-acao { background-color: #4299A3; color: #FFFFFF; font-size: 0.85rem; padding: 6px 12px; border-radius: 6px; font-weight: 500; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <uc:MenuLateral runat="server" ID="MenuLateral" />

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold" style="color: #1E3F4A;"><i class="fa-solid fa-clock-rotate-left me-2" style="color: #4299A3;"></i>Logs de Auditoria</h3>
                    <p class="text-muted mb-0">Rastreabilidade completa de ações e movimentações operacionais do sistema.</p>
                </div>
            </div>

            <asp:UpdatePanel ID="upPrincipal" runat="server">
                <ContentTemplate>
                    <div class="card card-custom p-3">
                        <asp:GridView ID="gvLogs" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle table-custom" GridLines="None" EmptyDataText="Nenhum registro de log ou operação encontrado.">
                            <Columns>                           
                                <asp:BoundField DataField="DataHora" HeaderText="Data / Hora" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}" ItemStyle-Width="180px" />
                                <asp:BoundField DataField="NomeUsuario" HeaderText="Usuário Operador" HeaderStyle-CssClass="fw-bold" ItemStyle-Width="220px" />
                                <asp:TemplateField HeaderText="Ação / Detalhes da Operação">
                                    <ItemTemplate>
                                        <span class="badge badge-acao"><i class="fa-solid fa-receipt me-1"></i><%# Eval("Acao") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>