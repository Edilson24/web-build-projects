<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Categorias.aspx.vb" Inherits="SIGEBIBLIOTECA.Categorias" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestão de Categorias - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .main-content { margin-left: 250px; transition: all 0.3s ease; padding: 30px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .table th { background-color: #f1f5f9; color: #475569; font-weight: 600; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        function abrirModal() {
            var modalElem = document.getElementById('modalCategoria');
            if (modalElem) {
                var modalInstance = bootstrap.Modal.getOrCreateInstance(modalElem);
                modalInstance.show();
            }
        }

        function fecharModal() {
            var modalElem = document.getElementById('modalCategoria');
            if (modalElem) {
                var modalInstance = bootstrap.Modal.getInstance(modalElem);
                if (modalInstance) {
                    modalInstance.hide();
                }
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
                    <h3 class="fw-bold text-dark"><i class="fas fa-tags me-2 text-primary"></i>Categorias de Livros</h3>
                    <p class="text-muted mb-0">Gerencie as categorias para classificação do acervo bibliográfico.</p>
                </div>
                <asp:Button ID="btnNovaCategoria" runat="server" Text="+ Nova Categoria" CssClass="btn btn-primary fw-semibold px-4" OnClick="btnNovaCategoria_Click" />
            </div>

            <asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                <asp:Label ID="lblMensagemAlerta" runat="server"></asp:Label>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <div class="card p-3">
                <!-- DataKeyNames guarda o ID internamente sem precisar exibi-lo -->
                <asp:GridView ID="gvCategorias" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle" DataKeyNames="IdCategoria" OnRowCommand="gvCategorias_RowCommand" GridLines="None" EmptyDataText="Nenhuma categoria cadastrada até o momento.">
                    <Columns>
                        <asp:BoundField DataField="Nome" HeaderText="Nome da Categoria" HeaderStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="Descricao" HeaderText="Descrição" NullDisplayText="Sem descrição" />
                        
                        <asp:TemplateField HeaderText="Ações" ItemStyle-Width="120px" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "IdCategoria") %>' CssClass="btn btn-sm btn-outline-warning me-1" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnExcluir" runat="server" CommandName="Excluir" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "IdCategoria") %>' CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('Deseja realmente excluir esta categoria?');" title="Excluir">
                                    <i class="fas fa-trash-alt"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="modal fade" id="modalCategoria" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold" id="modalLabel">
                            <asp:Literal ID="litTituloModal" runat="server" Text="Cadastrar Categoria"></asp:Literal>
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hfIdCategoria" runat="server" Value="0" />
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nome da Categoria <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNome" runat="server" CssClass="form-control" placeholder="Ex: Informática, Romance, História"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Descrição</label>
                            <asp:TextBox ID="txtDescricao" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Breve resumo sobre esta categoria..."></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnSalvar" runat="server" Text="Salvar Categoria" CssClass="btn btn-primary px-4" OnClick="btnSalvar_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>