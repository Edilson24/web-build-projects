<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Leitores.aspx.vb" Inherits="SIGEBIBLIOTECA.Leitores" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestão de Leitores - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .main-content { margin-left: 250px; transition: all 0.3s ease; padding: 30px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .table th { background-color: #f1f5f9; color: #475569; font-weight: 600; }
        .badge-estudante { background-color: #0284c7; color: #fff; }
        .badge-docente { background-color: #7c3aed; color: #fff; }
        .badge-externo { background-color: #059669; color: #fff; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
function abrirModal() {
    var modalElem = document.getElementById('modalLeitor');
    if (modalElem) {
        var modalInstance = bootstrap.Modal.getOrCreateInstance(modalElem);
        modalInstance.show();
    }
}

function fecharModal() {
    var modalElem = document.getElementById('modalLeitor');
    if (modalElem) {
        var modalInstance = bootstrap.Modal.getInstance(modalElem);
        if (modalInstance) { modalInstance.hide(); }
    }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <uc:MenuLateral runat="server" ID="MenuLateral" />

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold text-dark"><i class="fas fa-users me-2 text-primary"></i>Gestão de Leitores</h3>
                    <p class="text-muted mb-0">Cadastre e gerencie estudantes, docentes e leitores externos.</p>
                </div>
                <asp:Button ID="btnNovoLeitor" runat="server" Text="+ Novo Leitor" CssClass="btn btn-primary fw-semibold px-4" OnClick="btnNovoLeitor_Click" />
            </div>

            <asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                <asp:Label ID="lblMensagemAlerta" runat="server"></asp:Label>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <div class="card p-3">
                <asp:GridView ID="gvLeitores" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle" DataKeyNames="IdLeitor" OnRowCommand="gvLeitores_RowCommand" GridLines="None" EmptyDataText="Nenhum leitor cadastrado.">
                    <Columns>
                        <asp:BoundField DataField="Nome" HeaderText="Nome Completo" HeaderStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="Telefone" HeaderText="Telefone" />
                        
                        <asp:TemplateField HeaderText="Tipo de Leitor">
                            <ItemTemplate>
                                <span class='badge <%# ObterCssBadgeTipo(Eval("TipoLeitor").ToString()) %>'>
                                    <%# Eval("TipoLeitor").ToString().ToUpper() %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Curso / Turma">
                            <ItemTemplate>
                                <%# If(String.IsNullOrEmpty(Eval("Curso").ToString()), "-", Eval("Curso").ToString() & " (" & Eval("Turma").ToString() & ")") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Devoluções" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <span class="badge bg-light text-dark border fw-bold">
                                    <i class="fas fa-check-circle text-success me-1"></i><%# Eval("TotalEmprestimosConcluidos") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Situação" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <span class='badge <%# If(Convert.ToBoolean(Eval("Ativo")), "bg-success", "bg-danger") %>'>
                                    <%# If(Convert.ToBoolean(Eval("Ativo")), "ATIVO", "INATIVO") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Ações" ItemStyle-Width="140px" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("IdLeitor") %>' CssClass="btn btn-sm btn-outline-warning me-1" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnToggleStatus" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("IdLeitor") %>' 
                                    CssClass='<%# If(Convert.ToBoolean(Eval("Ativo")), "btn btn-sm btn-outline-danger", "btn btn-sm btn-outline-success") %>' 
                                    title='<%# If(Convert.ToBoolean(Eval("Ativo")), "Desativar Leitor", "Ativar Leitor") %>'>
                                    <i class='<%# If(Convert.ToBoolean(Eval("Ativo")), "fas fa-user-slash", "fas fa-user-check") %>'></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Modal Cadastrar / Editar -->
        <div class="modal fade" id="modalLeitor" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold" id="modalLabel">
                            <asp:Literal ID="litTituloModal" runat="server" Text="Cadastrar Leitor"></asp:Literal>
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hfIdLeitor" runat="server" Value="0" />
                        
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label fw-semibold">Nome Completo <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtNome" runat="server" CssClass="form-control" placeholder="Nome do leitor"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Tipo de Leitor <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlTipoLeitor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTipoLeitor_SelectedIndexChanged">
                                    <asp:ListItem Text="Estudante" Value="estudante" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Docente" Value="docente"></asp:ListItem>
                                    <asp:ListItem Text="Externo" Value="externo"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Telefone <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTelefone" runat="server" CssClass="form-control" placeholder="+258 ..."></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Endereço</label>
                                <asp:TextBox ID="txtEndereco" runat="server" CssClass="form-control" placeholder="Bairro, Cidade"></asp:TextBox>
                            </div>
                            <asp:Panel ID="pnlAcademico" runat="server" CssClass="row g-3 mt-1">
                                <div class="col-md-8">
                                    <label class="form-label fw-semibold">Curso</label>
                                    <asp:TextBox ID="txtCurso" runat="server" CssClass="form-control" placeholder="Ex: Licenciatura em Informática"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Turma / Ano</label>
                                    <asp:TextBox ID="txtTurma" runat="server" CssClass="form-control" placeholder="Ex: 3º Ano - Diurno"></asp:TextBox>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnSalvar" runat="server" Text="Salvar Leitor" CssClass="btn btn-primary px-4" OnClick="btnSalvar_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>