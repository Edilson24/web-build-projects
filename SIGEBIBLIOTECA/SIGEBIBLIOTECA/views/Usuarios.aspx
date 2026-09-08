<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Usuarios.aspx.vb" Inherits="SIGEBIBLIOTECA.views.Usuarios" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <title>Gestão de Usuários - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #F8FCFD; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #1E3F4A; }
        .main-content { margin-left: 250px; padding: 30px; }
        .card-custom { background-color: #FFFFFF; border: 1px solid #D1E9EE; border-radius: 12px; box-shadow: 0 4px 12px rgba(30, 63, 74, 0.08); }
        .btn-brand { background-color: #4299A3; color: #FFFFFF; border: none; font-weight: 600; }
        .btn-brand:hover { background-color: #1E3F4A; color: #FFFFFF; }
        .table-custom th { background-color: #1E3F4A; color: #FFFFFF; font-weight: 600; }
        .badge-ativo { background-color: #4299A3; color: #FFFFFF; }
        .badge-inativo { background-color: #D1E9EE; color: #1E3F4A; font-weight: bold; }
        .badge-admin { background-color: #1E3F4A; color: #FFFFFF; }
        .badge-atendente { background-color: #ABDFEA; color: #1E3F4A; font-weight: bold; }
        .modal-header-custom { background-color: #1E3F4A; color: #FFFFFF; }
    </style>

    <!-- JS do Bootstrap no Head e Função Global -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        function abrirModal(id) {
            var myModalEl = document.getElementById(id);
            if (myModalEl) {
                var modal = bootstrap.Modal.getOrCreateInstance(myModalEl);
                modal.show();
            }
        }
        function fecharModal(id) {
            var myModalEl = document.getElementById(id);
            if (myModalEl) {
                var modal = bootstrap.Modal.getInstance(myModalEl);
                if (modal) {
                    modal.hide();
                }
            }
            // Remove qualquer fundo escuro que possa ter ficado preso no DOM
            var backdrops = document.querySelectorAll('.modal-backdrop');
            backdrops.forEach(function(backdrop) {
                backdrop.remove();
            });
            document.body.classList.remove('modal-open');
            document.body.style.overflow = '';
            document.body.style.paddingRight = '';
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
                    <h3 class="fw-bold" style="color: #1E3F4A;"><i class="fa-solid fa-user-gear me-2" style="color: #4299A3;"></i>Usuários do Sistema</h3>
                    <p class="text-muted mb-0">Gerencie operadores, perfis de acesso e credenciais.</p>
                </div>
                <div>
                    <asp:Button ID="btnNovoUsuario" runat="server" Text="+ Novo Usuário" CssClass="btn btn-brand px-4 py-2" OnClick="btnNovoUsuario_Click" />
                </div>
            </div>

            <asp:UpdatePanel ID="upPrincipal" runat="server">
                <ContentTemplate>
                    <asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                        <asp:Label ID="lblMensagemAlerta" runat="server"></asp:Label>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </asp:Panel>

                    <div class="card card-custom p-3">
                        <asp:GridView ID="gvUsuarios" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle table-custom" DataKeyNames="idusuario" GridLines="None" EmptyDataText="Nenhum usuário cadastrado." OnRowCommand="gvUsuarios_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="idusuario" HeaderText="#" ItemStyle-Width="50px" />
                                <asp:BoundField DataField="nome" HeaderText="Nome de Exibição" HeaderStyle-CssClass="fw-bold" />
                                <asp:BoundField DataField="email" HeaderText="E-mail de Acesso" />
                                <asp:TemplateField HeaderText="Perfil" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                    <ItemTemplate>
                                        <span class='badge <%# If(Eval("perfil").ToString().ToLower() = "admin", "badge-admin", "badge-atendente") %>'>
                                            <%# Eval("perfil").ToString().ToUpper() %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                    <ItemTemplate>
                                        <span class='badge <%# If(Convert.ToBoolean(Eval("ativo")), "badge-ativo", "badge-inativo") %>'>
                                            <%# If(Convert.ToBoolean(Eval("ativo")), "ATIVO", "INATIVO") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Ações" ItemStyle-Width="120px" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                                    <ItemTemplate>
                                        <%-- Botão Editar --%>
                                        <asp:LinkButton ID="btnEditar" runat="server" 
                                            CommandName="EditarUsuario" 
                                            CommandArgument='<%# Eval("idusuario") %>' 
                                            CssClass="btn btn-sm text-white" 
                                            Style="background-color: #1E3F4A;" 
                                            title="Editar Usuário">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </asp:LinkButton>

                                        <%-- Botão Alternar Status: Oculto (Visible=False) se idusuario for igual ao UsuarioId da Session --%>
                                        <asp:LinkButton ID="btnAlternarStatus" runat="server" 
                                            CommandName="AlternarStatus" 
                                            CommandArgument='<%# Eval("idusuario") %>' 
                                            CssClass="btn btn-sm text-white" 
                                            Style="background-color: #4299A3;" 
                                            title="Alternar Status (Ativar/Desativar)"
                                            Visible='<%# Convert.ToInt32(Eval("idusuario")) <> Convert.ToInt32(Session("UsuarioId")) %>'>
                                            <i class="fa-solid fa-user-slash"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                    </div>

                    <!-- MODAL DE CADASTRO E EDIÇÃO -->
                    <div class="modal fade" id="modalUsuario" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content" style="border-radius: 12px; overflow: hidden;">
                                <div class="modal-header modal-header-custom">
                                    <h5 class="modal-title fw-bold">
                                        <asp:Literal ID="litTituloModal" runat="server" Text="Cadastrar Usuário"></asp:Literal>
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <asp:HiddenField ID="hfIdUsuario" runat="server" Value="0" />
                                    
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Nome Completo <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtNome" runat="server" CssClass="form-control" placeholder="Ex: João Silva"></asp:TextBox>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">E-mail <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="usuario@biblioteca.com"></asp:TextBox>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Senha <span class="text-danger">*</span></label>
                                            <asp:TextBox ID="txtSenha" runat="server" CssClass="form-control" placeholder="••••••••"></asp:TextBox>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Perfil de Acesso <span class="text-danger">*</span></label>
                                            <asp:DropDownList ID="ddlPerfil" runat="server" CssClass="form-select">
                                                <asp:ListItem Text="Atendente" Value="atendente"></asp:ListItem>
                                                <asp:ListItem Text="Administrador" Value="admin"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer" style="background-color: #F8FCFD;">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <asp:Button ID="btnSalvarUsuario" runat="server" Text="Salvar Registro" CssClass="btn btn-brand px-4" OnClick="btnSalvarUsuario_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>

</body>
</html>