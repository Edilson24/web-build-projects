<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Livros.aspx.vb" Inherits="SIGEBIBLIOTECA.Livros" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Register Src="~/includes/MenuLateral.ascx" TagPrefix="uc" TagName="MenuLateral" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestão de Livros - SIGEBIBLIOTECA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .main-content { margin-left: 250px; transition: all 0.3s ease; padding: 30px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .table th { background-color: #f1f5f9; color: #475569; font-weight: 600; }
        .badge-disponivel { background-color: #10b981; color: #fff; }
        .badge-esgotado { background-color: #ef4444; color: #fff; }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
function abrirModal() {
    var modalElem = document.getElementById('modalLivro');
    if (modalElem) {
        var modalInstance = bootstrap.Modal.getOrCreateInstance(modalElem);
        modalInstance.show();
    }
}

function fecharModal() {
    var modalElem = document.getElementById('modalLivro');
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
                    <h3 class="fw-bold text-dark"><i class="fas fa-book me-2 text-primary"></i>Acervo de Livros</h3>
                    <p class="text-muted mb-0">Gerencie a disponibilidade, preços e catálogo dos livros.</p>
                </div>
                <asp:Button ID="btnNovoLivro" runat="server" Text="+ Novo Livro" CssClass="btn btn-primary fw-semibold px-4" OnClick="btnNovoLivro_Click" />
            </div>

            <asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
                <asp:Label ID="lblMensagemAlerta" runat="server"></asp:Label>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <div class="card p-3">
                <asp:GridView ID="gvLivros" runat="server" AutoGenerateColumns="False" CssClass="table table-hover align-middle" DataKeyNames="IdLivro" OnRowCommand="gvLivros_RowCommand" GridLines="None" EmptyDataText="Nenhum livro cadastrado até o momento.">
                    <Columns>
                        <asp:BoundField DataField="Titulo" HeaderText="Título" HeaderStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="Autor" HeaderText="Autor" />
                        <asp:BoundField DataField="NomeCategoria" HeaderText="Categoria" />
                        <asp:BoundField DataField="PrecoEmprestimoDia" HeaderText="Aluguel/Dia (MT)" DataFormatString="{0:N2}" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end" />
                        <asp:BoundField DataField="ValorCompra" HeaderText="Valor Compra (MT)" DataFormatString="{0:N2}" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end" />
                        <asp:BoundField DataField="QtdDisponivel" HeaderText="Disponível" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        <asp:BoundField DataField="QtdTotal" HeaderText="Total" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        
                        <asp:TemplateField HeaderText="Estado" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <span class='badge <%# If(Eval("Estado").ToString().ToLower() = "disponivel", "badge-disponivel", "badge-esgotado") %>'>
                                    <%# Eval("Estado").ToString().ToUpper() %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Ações" ItemStyle-Width="120px" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "IdLivro") %>' CssClass="btn btn-sm btn-outline-warning me-1" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnExcluir" runat="server" CommandName="Excluir" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "IdLivro") %>' CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('Deseja realmente excluir este livro?');" title="Excluir">
                                    <i class="fas fa-trash-alt"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="modal fade" id="modalLivro" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold" id="modalLabel">
                            <asp:Literal ID="litTituloModal" runat="server" Text="Cadastrar Livro"></asp:Literal>
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hfIdLivro" runat="server" Value="0" />
                        
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label fw-semibold">Título <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control" placeholder="Título completo do livro"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Categoria <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Autor <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtAutor" runat="server" CssClass="form-control" placeholder="Nome do autor"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Editora <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtEditora" runat="server" CssClass="form-control" placeholder="Nome da editora"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Edição</label>
                                <asp:TextBox ID="txtEdicao" runat="server" CssClass="form-control" placeholder="Ex: 1ª Edição"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Ano de Publicação</label>
                                <asp:TextBox ID="txtAnoPublicacao" runat="server" CssClass="form-control" TextMode="Number" placeholder="Ex: 2024"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Qtd. Total <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtQtdTotal" runat="server" CssClass="form-control" TextMode="Number" placeholder="1"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Preço Empréstimo/Dia (MT) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtPrecoEmprestimoDia" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Valor de Compra (MT) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtValorCompra" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnSalvar" runat="server" Text="Salvar Livro" CssClass="btn btn-primary px-4" OnClick="btnSalvar_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>