<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Emprestimos.aspx.vb" Inherits="SIGEBIBLIOTECA.views.Emprestimos" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <title>Gestão de Empréstimos - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #F8FCFD; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #1E3F4A; }
        .main-content { margin-left: 250px; padding: 30px; }
        .card-custom { background-color: #FFFFFF; border: 1px solid #D1E9EE; border-radius: 12px; box-shadow: 0 4px 12px rgba(30, 63, 74, 0.08); }
        .btn-brand { background-color: #4299A3; color: #FFFFFF; border: none; font-weight: 600; }
        .btn-brand:hover { background-color: #1E3F4A; color: #FFFFFF; }
        .table-custom th { background-color: #1E3F4A; color: #FFFFFF; font-weight: 600; }
        .badge-andamento { background-color: #4299A3; color: #FFFFFF; }
        .badge-devolvida { background-color: #D1E9EE; color: #1E3F4A; font-weight: bold; }
        .modal-header-custom { background-color: #1E3F4A; color: #FFFFFF; }
        .box-resumo { background-color: #F8FCFD; border: 1px solid #ABDFEA; border-radius: 8px; padding: 15px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <uc:MenuLateral runat="server" ID="MenuLateral" />

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold" style="color: #1E3F4A;"><i class="fa-solid fa-hand-holding-book me-2" style="color: #4299A3;"></i>Gestão de Empréstimos</h3>
                    <p class="text-muted mb-0">Painel operacional de empréstimos e devoluções.</p>
                </div>
                <!-- BOTÃO DE REGISTRAR NOVO EMPRÉSTIMO ADICIONADO -->
                <div>
                    <asp:Button ID="btnNovoEmprestimo" runat="server" Text="+ Novo Empréstimo" CssClass="btn btn-brand px-4 py-2" OnClick="btnNovoEmprestimo_Click" />
                </div>
            </div>

            <asp:UpdatePanel ID="upPrincipal" runat="server">
                <ContentTemplate>
                    <asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                        <asp:Label ID="lblMensagemAlerta" runat="server"></asp:Label>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </asp:Panel>

                    <div class="card card-custom p-3">
                        <asp:GridView ID="gvEmprestimos" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle table-custom" DataKeyNames="idemprestimo" GridLines="None" EmptyDataText="Nenhum empréstimo cadastrado." OnRowCommand="gvEmprestimos_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="idemprestimo" HeaderText="#" ItemStyle-Width="50px" />
                                <asp:BoundField DataField="nome_leitor" HeaderText="Leitor" HeaderStyle-CssClass="fw-bold" />
                                <asp:BoundField DataField="titulo_livro" HeaderText="Livro" />
                                <asp:TemplateField HeaderText="Datas">
                                    <ItemTemplate>
                                        <small><i class="fa-regular fa-calendar me-1 text-muted"></i>Retirada: <%# Convert.ToDateTime(Eval("data_emprestimo")).ToString("dd/MM/yyyy") %></small><br />
                                        <small><i class="fa-regular fa-calendar-check me-1 text-primary"></i>Previsão: <%# Convert.ToDateTime(Eval("data_prevista_devolucao")).ToString("dd/MM/yyyy") %></small>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Pago no Ato (70%)">
                                    <ItemTemplate>
                                        <strong><%# Convert.ToDecimal(Eval("valor_pago_adiantado")).ToString("N2") %> MT</strong>
                                        <%# If(Convert.ToBoolean(Eval("teve_desconto_fidelidade")), "<br/><span class='badge bg-success'>-10% Fidelidade</span>", "") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Situação" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                    <ItemTemplate>
                                        <span class='badge <%# If(Eval("status").ToString() = "em_andamento", "badge-andamento", "badge-devolvida") %>'>
                                            <%# If(Eval("status").ToString() = "em_andamento", "EM ANDAMENTO", "DEVOLVIDO") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Ações" ItemStyle-Width="120px" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnVisualizar" runat="server" CommandName="Visualizar" CommandArgument='<%# Eval("idemprestimo") %>' CssClass="btn btn-sm text-white" Style="background-color: #1E3F4A;" title="Visualizar Detalhes">
                                            <i class="fa-solid fa-eye"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDevolucao" runat="server" CommandName="Devolver" CommandArgument='<%# Eval("idemprestimo") %>' CssClass="btn btn-sm text-white" Style="background-color: #4299A3;" title="Registrar Devolução" Visible='<%# Eval("status").ToString() = "em_andamento" %>'>
                                            <i class="fa-solid fa-rotate-left"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <!-- MODAL DETALHES -->
                    <div class="modal fade" id="modalDetalhes" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content" style="border-radius: 12px; overflow: hidden;">
                                <div class="modal-header modal-header-custom">
                                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-eye me-2"></i>Detalhes do Empréstimo</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <div class="box-resumo">
                                        <p class="mb-1"><strong>Leitor:</strong> <asp:Label ID="lblDetLeitor" runat="server"></asp:Label></p>
                                        <p class="mb-1"><strong>Livro:</strong> <asp:Label ID="lblDetLivro" runat="server"></asp:Label></p>
                                        <p class="mb-1"><strong>Retirada:</strong> <asp:Label ID="lblDetDataEmp" runat="server"></asp:Label></p>
                                        <p class="mb-1"><strong>Previsão:</strong> <asp:Label ID="lblDetDataPrev" runat="server"></asp:Label></p>
                                        <hr/>
                                        <p class="mb-1"><strong>Valor Pago Adiantado (70%):</strong> <asp:Label ID="lblDetAdiantado" runat="server" CssClass="text-success fw-bold"></asp:Label></p>
                                        <p class="mb-0"><strong>Saldo Restante (30%):</strong> <asp:Label ID="lblDetSaldo" runat="server" CssClass="text-primary fw-bold"></asp:Label></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- MODAL DEVOLUÇÃO -->
                    <div class="modal fade" id="modalDevolucao" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-md modal-dialog-centered">
                            <div class="modal-content" style="border-radius: 12px; overflow: hidden;">
                                <div class="modal-header modal-header-custom">
                                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-rotate-left me-2"></i>Registrar Devolução</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <asp:HiddenField ID="hfIdEmprestimoDev" runat="server" />
                                    <asp:HiddenField ID="hfDataEmprestimoDev" runat="server" />
                                    <asp:HiddenField ID="hfDataPrevistaDev" runat="server" />
                                    <asp:HiddenField ID="hfPrecoDiarioAplicado" runat="server" />
                                    <asp:HiddenField ID="hfValorCompraLivro" runat="server" />
                                    <asp:HiddenField ID="hfValorSaldoAluguel" runat="server" />

                                    <asp:HiddenField ID="hfDiasAtraso" runat="server" />
                                    <asp:HiddenField ID="hfValorMultaAtraso" runat="server" />
                                    <asp:HiddenField ID="hfValorMultaDano" runat="server" />
                                    <asp:HiddenField ID="hfValorTotalPago" runat="server" />

                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Livro a Devolver:</label>
                                        <asp:Label ID="lblLivroDevolucao" runat="server" CssClass="form-control bg-light fw-bold"></asp:Label>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Data Real Devolução <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="txtDataRealDevolucao" runat="server" TextMode="Date" CssClass="form-control" onchange="calcularDevolucaoJS()"></asp:TextBox>
                                        </div>
                                        <div class="col-md-6 d-flex align-items-end">
                                            <div class="form-check mb-2">
                                                <asp:CheckBox ID="houve_dano" runat="server" CssClass="form-check-input" onchange="calcularDevolucaoJS()" />
                                                <label class="form-check-label fw-semibold text-danger" for="houve_dano">
                                                    <i class="fa-solid fa-triangle-exclamation me-1"></i>Houve Dano?
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="box-resumo mb-3">
                                        <h6 class="fw-bold mb-3" style="color: #1E3F4A;"><i class="fa-solid fa-file-invoice-dollar me-2"></i>Extrato de Liquidação</h6>
                                        <div class="row g-2">
                                            <div class="col-6"><small class="text-muted d-block">Saldo Restante (30%):</small><span id="spnSaldo30" class="fw-bold text-dark">0.00 MT</span></div>
                                            <div class="col-6 text-end"><small class="text-muted d-block">Dias de Atraso:</small><span id="spnDiasAtraso" class="fw-bold text-danger">0 dia(s)</span></div>
                                            <div class="col-6"><small class="text-muted d-block">Multa Atraso (50%/dia):</small><span id="spnMultaAtraso" class="fw-semibold text-danger">0.00 MT</span></div>
                                            <div class="col-6 text-end"><small class="text-muted d-block">Multa por Dano:</small><span id="spnMultaDano" class="fw-semibold text-danger">0.00 MT</span></div>
                                            <div class="col-12"><hr class="my-1"/></div>
                                            <div class="col-12 text-end">
                                                <small class="text-muted d-block"><strong>Valor Total a Receber:</strong></small>
                                                <span id="spnTotalPago" class="fw-bold fs-4" style="color: #4299A3;">0.00 MT</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer" style="background-color: #F8FCFD;">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <asp:Button ID="btnConfirmarDevolucao" runat="server" Text="Encerrar Devolução" CssClass="btn btn-brand px-4" OnClick="btnConfirmarDevolucao_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        function calcularDevolucaoJS() {
            var strDataEmp = document.getElementById('<%= hfDataEmprestimoDev.ClientID %>').value;
            var strDataPrev = document.getElementById('<%= hfDataPrevistaDev.ClientID %>').value;
            var precoDia = parseFloat(document.getElementById('<%= hfPrecoDiarioAplicado.ClientID %>').value) || 0;
            var precoCompra = parseFloat(document.getElementById('<%= hfValorCompraLivro.ClientID %>').value) || 0;
            var saldo30 = parseFloat(document.getElementById('<%= hfValorSaldoAluguel.ClientID %>').value) || 0;

            var inputDataReal = document.getElementById('<%= txtDataRealDevolucao.ClientID %>');
            var chkDano = document.getElementById('<%= houve_dano.ClientID %>').checked;

            if (!inputDataReal.value) return;

            var dtEmp = new Date(strDataEmp + "T00:00:00");
            var dtPrev = new Date(strDataPrev + "T00:00:00");
            var dtReal = new Date(inputDataReal.value + "T00:00:00");

            // Trava: Data real nao pode ser anterior ao emprestimo
            if (dtReal < dtEmp) {
                alert("A data de devolução não pode ser anterior à data em que o livro foi emprestado.");
                inputDataReal.value = strDataEmp;
                dtReal = dtEmp;
            }

            // Calculo do Atraso
            var diasAtraso = 0;
            var multaAtraso = 0;
            if (dtReal > dtPrev) {
                var diffTime = Math.abs(dtReal - dtPrev);
                diasAtraso = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                multaAtraso = diasAtraso * (precoDia * 0.50);
            }

            // Calculo do Dano
            var multaDano = chkDano ? precoCompra : 0;
            var totalFinal = saldo30 + multaAtraso + multaDano;

            document.getElementById('spnSaldo30').innerText = saldo30.toFixed(2) + " MT";
            document.getElementById('spnDiasAtraso').innerText = diasAtraso + " dia(s)";
            document.getElementById('spnMultaAtraso').innerText = multaAtraso.toFixed(2) + " MT";
            document.getElementById('spnMultaDano').innerText = multaDano.toFixed(2) + " MT";
            document.getElementById('spnTotalPago').innerText = totalFinal.toFixed(2) + " MT";

            document.getElementById('<%= hfDiasAtraso.ClientID %>').value = diasAtraso;
            document.getElementById('<%= hfValorMultaAtraso.ClientID %>').value = multaAtraso;
            document.getElementById('<%= hfValorMultaDano.ClientID %>').value = multaDano;
            document.getElementById('<%= hfValorTotalPago.ClientID %>').value = totalFinal;
        }

        function abrirModal(id) {
            var el = document.getElementById(id);
            if (el) {
                var modal = bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el);
                modal.show();
            }
        }

        // Garante re-execucao de chamadas JS apos AJAX do UpdatePanel
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                // Re-inicializacoes necessarias pós-postback podem ser inseridas aqui
            });
        }
    </script>
</body>
</html>