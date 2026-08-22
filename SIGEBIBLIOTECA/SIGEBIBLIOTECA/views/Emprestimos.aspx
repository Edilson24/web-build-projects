<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Emprestimos.aspx.vb" Inherits="SIGEBIBLIOTECA.Emprestimos" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestão de Empréstimos - SIGEBIBLIOTECA</title>
    
    <!-- Usa ResolveUrl para garantir a rota correta a partir da raiz (~/) -->
    <link href="<%= ResolveUrl("~/Content/bootstrap.min.css") %>" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    
    <style>
        body { background-color: #F8FCFD; color: #1E3F4A; }
        .card-custom { border: 1px solid #D1E9EE; border-radius: 8px; box-shadow: 0 4px 6px rgba(30, 63, 74, 0.05); }
        .btn-primary-custom { background-color: #4299A3; border-color: #4299A3; color: #FFFFFF; }
        .btn-primary-custom:hover { background-color: #1E3F4A; border-color: #1E3F4A; color: #FFFFFF; }
        .badge-andamento { background-color: #ABDFEA; color: #1E3F4A; font-weight: 600; padding: 0.5em 0.75em; border-radius: 4px; }
        .badge-devolvido { background-color: #D1E9EE; color: #4299A3; font-weight: 600; padding: 0.5em 0.75em; border-radius: 4px; }
        .table-header { background-color: #D1E9EE !important; color: #1E3F4A !important; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <uc:MenuLateral runat="server" ID="MenuLateral" />
        
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-journal-bookmark me-2"></i>Gestão de Empréstimos</h2>
                <asp:Button ID="btnNovoEmprestimo" runat="server" Text="+ Novo Empréstimo" CssClass="btn btn-primary-custom px-4" OnClick="btnNovoEmprestimo_Click" />
            </div>

            <asp:Panel ID="pnlMensagem" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                <asp:Label ID="lblMensagem" runat="server"></asp:Label>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

<div class="card card-custom p-3">
                <div class="table-responsive">
                    <asp:GridView ID="gvEmprestimos" runat="server" AutoGenerateColumns="False" DataKeyNames="IdEmprestimo"
                        CssClass="table table-hover align-middle mb-0" GridLines="None" EmptyDataText="Nenhum empréstimo registrado.">
                        <HeaderStyle CssClass="table-header" />
                        <Columns>
                            <asp:BoundField DataField="TituloLivro" HeaderText="Livro" HeaderStyle-CssClass="fw-bold" />
                            <asp:BoundField DataField="NomeLeitor" HeaderText="Leitor" HeaderStyle-CssClass="fw-bold" />
                            
                            <%-- 1. Datas de Retirada e Previsão unificadas --%>
                            <asp:TemplateField HeaderText="Retirada / Prev. Devolução" HeaderStyle-CssClass="fw-bold">
                                <ItemTemplate>
                                    <small class="text-muted"><i class="fas fa-calendar-out me-1"></i>Retirada:</small> <%# Convert.ToDateTime(Eval("DataEmprestimo")).ToString("dd/MM/yyyy HH:mm") %>
                                    <br />
                                    <small class="text-muted"><i class="fas fa-calendar-check me-1"></i>Previsão:</small> <%# Convert.ToDateTime(Eval("DataPrevistaDevolucao")).ToString("dd/MM/yyyy") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- Nova coluna: Data Real de Devolução --%>
                            <asp:TemplateField HeaderText="Data Devolução" HeaderStyle-CssClass="fw-bold">
                                <ItemTemplate>
                                    <%# If(Eval("DataRealDevolucao") IsNot Nothing AndAlso Not IsDBNull(Eval("DataRealDevolucao")), Convert.ToDateTime(Eval("DataRealDevolucao")).ToString("dd/MM/yyyy HH:mm"), "<span class='text-muted'>-</span>") %>
                                </ItemTemplate>
                            </asp:TemplateField>                          

                            <%-- 2. Coluna única para Valor Total Pago --%>
                            <asp:TemplateField HeaderText="Total Pago (MT)" HeaderStyle-CssClass="fw-bold">
                                <ItemTemplate>
                                    <%# If(Eval("ValorTotalPago") IsNot Nothing AndAlso Not IsDBNull(Eval("ValorTotalPago")), Convert.ToDecimal(Eval("ValorTotalPago")).ToString("N2"), "<span class='text-muted'>-</span>") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center fw-bold">
                                <ItemTemplate>
                                    <span class='badge <%# If(Eval("Status").ToString() = "em_andamento", "badge-andamento", "badge-devolvido") %>'>
                                        <%# Eval("Status").ToString().Replace("_", " ").ToUpper() %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Ações" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end fw-bold">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDetalhes" runat="server" CommandName="Detalhes" CommandArgument='<%# Eval("IdEmprestimo") %>' CssClass="btn btn-sm btn-outline-info me-1" ToolTip="Visualizar Detalhes">
                                        <i class="fas fa-eye"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDevolucao" runat="server" CommandName="Devolucao" CommandArgument='<%# Eval("IdEmprestimo") %>' 
                                        CssClass="btn btn-sm btn-outline-success" Visible='<%# Eval("Status").ToString() = "em_andamento" %>' ToolTip="Efetuar Devolução">
                                        <i class="fas fa-undo"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- MODAL NOVO EMPRÉSTIMO -->
        <asp:Panel ID="pnlModalNovo" runat="server" Visible="false" CssClass="modal fade show d-block" Style="background: rgba(30, 63, 74, 0.5);">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header" style="background-color: #ABDFEA;">
                        <h5 class="modal-title">Registrar Novo Empréstimo</h5>
                        <asp:Button ID="btnCloseModalNovo" runat="server" CssClass="btn-close" OnClick="FecharModais" />
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Leitor</label>
                                <asp:DropDownList ID="ddlLeitor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="CalcularValoresNovoEmprestimo"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Livro</label>
                                <asp:DropDownList ID="ddlLivro" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="CalcularValoresNovoEmprestimo"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Data Prevista de Devolução</label>
                                <asp:TextBox ID="txtDataPrevista" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="CalcularValoresNovoEmprestimo"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Dias Previstos</label>
                                <asp:TextBox ID="txtDiasPrevistos" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-12"><hr /></div>
                            <div class="col-md-4">
                                <label class="form-label">Preço/Dia Aplicado</label>
                                <asp:TextBox ID="txtPrecoDia" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                <asp:Label ID="lblDescontoFidelidade" runat="server" CssClass="text-success small" Visible="false">* 10% Desconto Fidelidade</asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Total Estimado</label>
                                <asp:TextBox ID="txtValorTotalEstimado" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label"><strong>Adiantamento (70%)</strong></label>
                                <asp:TextBox ID="txtValor70" runat="server" CssClass="form-control fw-bold text-primary" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnCancelarNovo" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="FecharModais" />
                        <asp:Button ID="btnSalvarEmprestimo" runat="server" Text="Confirmar Retirada" CssClass="btn btn-primary-custom" OnClick="btnSalvarEmprestimo_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- MODAL DEVOLUÇÃO -->
        <asp:Panel ID="pnlModalDevolucao" runat="server" Visible="false" CssClass="modal fade show d-block" Style="background: rgba(30, 63, 74, 0.5);">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header" style="background-color: #D1E9EE;">
                        <h5 class="modal-title">Processar Devolução / Liquidação</h5>
                        <asp:Button ID="btnCloseModalDevolucao" runat="server" CssClass="btn-close" OnClick="FecharModais" />
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hfIdEmprestimoDevolucao" runat="server" />
                        <div class="row g-3">
                            <div class="col-md-12">
                                <p><strong>Livro:</strong> <asp:Label ID="lblDevLivro" runat="server"></asp:Label> | <strong>Leitor:</strong> <asp:Label ID="lblDevLeitor" runat="server"></asp:Label></p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Data Real da Devolução</label>
                                <asp:TextBox ID="txtDataRealDevolucao" runat="server" TextMode="DateTimeLocal" CssClass="form-control" AutoPostBack="true" OnTextChanged="CalcularValoresDevolucao"></asp:TextBox>
                            </div>
                            <div class="col-md-6 align-self-end">
                                <div class="form-check mb-2">
                                    <asp:CheckBox ID="chkHouveDano" runat="server" CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="CalcularValoresDevolucao" />
                                    <label class="form-check-label text-danger fw-bold" for="chkHouveDano">Livro Danificado? (Cobrar Valor Compra)</label>
                                </div>
                            </div>
                            <div class="col-12"><hr /></div>
                            <div class="col-md-3">
                                <label class="form-label">Saldo Pendente (30%)</label>
                                <asp:TextBox ID="txtSaldo30" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Multa Atraso</label>
                                <asp:TextBox ID="txtMultaAtraso" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Multa Dano</label>
                                <asp:TextBox ID="txtMultaDano" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label"><strong>Total a Pagar</strong></label>
                                <asp:TextBox ID="txtTotalDevolucao" runat="server" CssClass="form-control fw-bold text-success" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnCancelarDevolucao" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="FecharModais" />
                        <asp:Button ID="btnConfirmarDevolucao" runat="server" Text="Finalizar Liquidação" CssClass="btn btn-success" OnClick="btnConfirmarDevolucao_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- MODAL DETALHES -->
        <asp:Panel ID="pnlModalDetalhes" runat="server" Visible="false" CssClass="modal fade show d-block" Style="background: rgba(30, 63, 74, 0.5);">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Detalhes do Empréstimo</h5>
                        <asp:Button ID="btnCloseModalDetalhes" runat="server" CssClass="btn-close" OnClick="FecharModais" />
                    </div>
                    <div class="modal-body">
                        <asp:Literal ID="litDetalhes" runat="server"></asp:Literal>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnFecharDetalhes" runat="server" Text="Fechar" CssClass="btn btn-secondary" OnClick="FecharModais" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </form>

    <!-- Script JavaScript do Bootstrap para garantir interatividade dos componentes -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>