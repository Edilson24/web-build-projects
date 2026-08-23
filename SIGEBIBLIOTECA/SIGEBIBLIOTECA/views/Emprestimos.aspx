<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Emprestimos.aspx.vb" Inherits="SIGEBIBLIOTECA.Emprestimos" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestão de Empréstimos - SIGEBIBLIOTECA</title>
    
    <!-- CSS Bootstrap -->
    <link href="<%= ResolveUrl("~/Content/bootstrap.min.css") %>" rel="stylesheet" />
    <!-- FontAwesome (alinhado com as classes 'fas fa-*' do Menu Lateral e da Tabela) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <style>
        body { 
            background-color: #f8fafc; 
            color: #1e293b; 
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Área de conteúdo ajustada ao Menu Lateral Fixo (250px / 70px) */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        /* Cards e Painéis */
        .card-custom { 
            border: 1px solid #e2e8f0; 
            border-radius: 10px; 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); 
            background-color: #ffffff;
        }

        /* Botões em sintonia com a paleta do Menu */
        .btn-primary-custom { 
            background-color: #2563eb; 
            border-color: #2563eb; 
            color: #ffffff; 
            font-weight: 500;
        }
        .btn-primary-custom:hover { 
            background-color: #1d4ed8; 
            border-color: #1d4ed8; 
            color: #ffffff; 
        }

        /* Badges de Status */
        .badge-andamento { 
            background-color: #dbeafe; 
            color: #1e40af; 
            font-weight: 600; 
            padding: 0.5em 0.8em; 
            border-radius: 6px; 
        }
        .badge-devolvido { 
            background-color: #dcfce7; 
            color: #166534; 
            font-weight: 600; 
            padding: 0.5em 0.8em; 
            border-radius: 6px; 
        }

        /* Cabeçalho da Tabela */
        .table-header { 
            background-color: #f1f5f9 !important; 
            color: #334155 !important; 
            border-bottom: 2px solid #e2e8f0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <!-- Componente do Menu Lateral -->
        <uc:MenuLateral runat="server" ID="MenuLateral" />

        <!-- Conteúdo Principal com margem configurada para o menu fixo -->
        <main class="main-content">
            <div class="container-fluid p-0">
                
                <!-- Topo da Página -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-1"><i class="fas fa-exchange-alt me-2 text-primary"></i>Gestão de Empréstimos</h2>
                        <p class="text-muted mb-0 small">Controle de retiradas, devoluções e liquidação de taxas.</p>
                    </div>
                    <asp:Button ID="btnNovoEmprestimo" runat="server" Text="+ Novo Empréstimo" CssClass="btn btn-primary-custom px-4 py-2 shadow-sm" OnClick="btnNovoEmprestimo_Click" />
                </div>

                <!-- Mensagens de Feedback/Alerta -->
                <asp:Panel ID="pnlMensagem" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
                    <asp:Label ID="lblMensagem" runat="server"></asp:Label>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </asp:Panel>

                <!-- Tabela Principal -->
                <div class="card card-custom p-3">
                    <div class="table-responsive">
                        <asp:GridView ID="gvEmprestimos" runat="server" AutoGenerateColumns="False" DataKeyNames="IdEmprestimo"
                            CssClass="table table-hover align-middle mb-0" GridLines="None" EmptyDataText="Nenhum empréstimo registrado.">
                            <HeaderStyle CssClass="table-header" />
                            <Columns>
                                <asp:BoundField DataField="TituloLivro" HeaderText="Livro" HeaderStyle-CssClass="fw-semibold" />
                                <asp:BoundField DataField="NomeLeitor" HeaderText="Leitor" HeaderStyle-CssClass="fw-semibold" />
                                
                                <%-- Datas de Retirada e Previsão unificadas --%>
                                <asp:TemplateField HeaderText="Retirada / Prev. Devolução" HeaderStyle-CssClass="fw-semibold">
                                    <ItemTemplate>
                                        <div class="small">
                                            <span class="text-muted"><i class="far fa-calendar-alt me-1"></i>Retirada:</span> <%# Convert.ToDateTime(Eval("DataEmprestimo")).ToString("dd/MM/yyyy HH:mm") %>
                                        </div>
                                        <div class="small mt-1">
                                            <span class="text-muted"><i class="far fa-calendar-check me-1"></i>Previsão:</span> <%# Convert.ToDateTime(Eval("DataPrevistaDevolucao")).ToString("dd/MM/yyyy") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Data Real de Devolução --%>
                                <asp:TemplateField HeaderText="Data Devolução" HeaderStyle-CssClass="fw-semibold">
                                    <ItemTemplate>
                                        <%# If(Eval("DataRealDevolucao") IsNot Nothing AndAlso Not IsDBNull(Eval("DataRealDevolucao")), Convert.ToDateTime(Eval("DataRealDevolucao")).ToString("dd/MM/yyyy HH:mm"), "<span class='text-muted'>-</span>") %>
                                    </ItemTemplate>
                                </asp:TemplateField>                         

                                <%-- Valor Total Pago --%>
                                <asp:TemplateField HeaderText="Total Pago (MT)" HeaderStyle-CssClass="fw-semibold">
                                    <ItemTemplate>
                                        <%# If(Eval("ValorTotalPago") IsNot Nothing AndAlso Not IsDBNull(Eval("ValorTotalPago")), Convert.ToDecimal(Eval("ValorTotalPago")).ToString("N2"), "<span class='text-muted'>-</span>") %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Status --%>
                                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center fw-semibold">
                                    <ItemTemplate>
                                        <span class='badge <%# If(Eval("Status").ToString() = "em_andamento", "badge-andamento", "badge-devolvido") %>'>
                                            <%# Eval("Status").ToString().Replace("_", " ").ToUpper() %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- Ações com Ícones FontAwesome compatíveis --%>
                                <asp:TemplateField HeaderText="Ações" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end fw-semibold">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDetalhes" runat="server" CommandName="Detalhes" CommandArgument='<%# Eval("IdEmprestimo") %>' CssClass="btn btn-sm btn-outline-secondary me-1" ToolTip="Visualizar Detalhes">
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
        </main>

        <!-- ========================================== -->
        <!-- PAINÉIS DE MODAL (INTEGRIDADE PRESERVADA)   -->
        <!-- ========================================== -->

        <!-- MODAL NOVO EMPRÉSTIMO -->
        <asp:Panel ID="pnlModalNovo" runat="server" Visible="false" CssClass="modal fade show d-block" Style="background: rgba(15, 23, 42, 0.6); z-index: 1050;">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold"><i class="fas fa-plus-circle me-2 text-primary"></i>Registrar Novo Empréstimo</h5>
                        <asp:Button ID="btnCloseModalNovo" runat="server" CssClass="btn-close" OnClick="FecharModais" />
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Leitor</label>
                                <asp:DropDownList ID="ddlLeitor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="CalcularValoresNovoEmprestimo"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Livro</label>
                                <asp:DropDownList ID="ddlLivro" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="CalcularValoresNovoEmprestimo"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Data Prevista de Devolução</label>
                                <asp:TextBox ID="txtDataPrevista" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="CalcularValoresNovoEmprestimo"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Dias Previstos</label>
                                <asp:TextBox ID="txtDiasPrevistos" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-12"><hr class="text-muted" /></div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Preço/Dia Aplicado</label>
                                <asp:TextBox ID="txtPrecoDia" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                                <asp:Label ID="lblDescontoFidelidade" runat="server" CssClass="text-success small fw-bold" Visible="false">* 10% Desconto Fidelidade</asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Total Estimado</label>
                                <asp:TextBox ID="txtValorTotalEstimado" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold text-primary">Adiantamento Obrigatório (70%)</label>
                                <asp:TextBox ID="txtValor70" runat="server" CssClass="form-control fw-bold text-primary bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <asp:Button ID="btnCancelarNovo" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="FecharModais" />
                        <asp:Button ID="btnSalvarEmprestimo" runat="server" Text="Confirmar Retirada" CssClass="btn btn-primary-custom" OnClick="btnSalvarEmprestimo_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- MODAL DEVOLUÇÃO -->
        <asp:Panel ID="pnlModalDevolucao" runat="server" Visible="false" CssClass="modal fade show d-block" Style="background: rgba(15, 23, 42, 0.6); z-index: 1050;">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold"><i class="fas fa-undo me-2 text-success"></i>Processar Devolução / Liquidação</h5>
                        <asp:Button ID="btnCloseModalDevolucao" runat="server" CssClass="btn-close" OnClick="FecharModais" />
                    </div>
                    <div class="modal-body p-4">
                        <asp:HiddenField ID="hfIdEmprestimoDevolucao" runat="server" />
                        <div class="row g-3">
                            <div class="col-md-12">
                                <div class="p-3 bg-light rounded border">
                                    <strong>Livro:</strong> <asp:Label ID="lblDevLivro" runat="server" CssClass="text-primary me-3"></asp:Label> 
                                    <strong>Leitor:</strong> <asp:Label ID="lblDevLeitor" runat="server" CssClass="text-primary"></asp:Label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Data Real da Devolução</label>
                                <asp:TextBox ID="txtDataRealDevolucao" runat="server" TextMode="DateTimeLocal" CssClass="form-control" AutoPostBack="true" OnTextChanged="CalcularValoresDevolucao"></asp:TextBox>
                            </div>
                            <div class="col-md-6 align-self-end">
                                <div class="form-check mb-2">
                                    <asp:CheckBox ID="chkHouveDano" runat="server" CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="CalcularValoresDevolucao" />
                                    <label class="form-check-label text-danger fw-bold" for="chkHouveDano">Livro Danificado? (Cobrar Valor Compra)</label>
                                </div>
                            </div>
                            <div class="col-12"><hr class="text-muted" /></div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Saldo Pendente (30%)</label>
                                <asp:TextBox ID="txtSaldo30" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Multa Atraso</label>
                                <asp:TextBox ID="txtMultaAtraso" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold">Multa Dano</label>
                                <asp:TextBox ID="txtMultaDano" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-semibold text-success">Total a Pagar</label>
                                <asp:TextBox ID="txtTotalDevolucao" runat="server" CssClass="form-control fw-bold text-success bg-light" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <asp:Button ID="btnCancelarDevolucao" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="FecharModais" />
                        <asp:Button ID="btnConfirmarDevolucao" runat="server" Text="Finalizar Liquidação" CssClass="btn btn-success" OnClick="btnConfirmarDevolucao_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- MODAL DETALHES -->
        <asp:Panel ID="pnlModalDetalhes" runat="server" Visible="false" CssClass="modal fade show d-block" Style="background: rgba(15, 23, 42, 0.6); z-index: 1050;">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold"><i class="fas fa-info-circle me-2 text-info"></i>Detalhes do Empréstimo</h5>
                        <asp:Button ID="btnCloseModalDetalhes" runat="server" CssClass="btn-close" OnClick="FecharModais" />
                    </div>
                    <div class="modal-body p-4">
                        <asp:Literal ID="litDetalhes" runat="server"></asp:Literal>
                    </div>
                    <div class="modal-footer bg-light">
                        <asp:Button ID="btnFecharDetalhes" runat="server" Text="Fechar" CssClass="btn btn-secondary" OnClick="FecharModais" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </form>

    <!-- Scripts JavaScript do Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>