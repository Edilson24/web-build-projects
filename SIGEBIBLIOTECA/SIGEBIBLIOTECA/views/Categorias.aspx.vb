Imports System
Imports System.Collections.Generic
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA
    Partial Public Class Categorias
        Inherits System.Web.UI.Page

        Private ReadOnly dao As New CategoriaDAO()

        ' Mantido Handles Me.Load pois a página não utiliza OnLoad no ASPX
        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Obter perfil gravado no momento do Login (admin ou atendente)
            Dim perfil As String = If(Session("UsuarioNivel") IsNot Nothing, Session("UsuarioNivel").ToString().Trim(), "")

            ' Aceita 'admin' (padrão da tabela usuarios) ou 'Administrador'
            Dim ehAdmin As Boolean = perfil.Equals("admin", StringComparison.OrdinalIgnoreCase) OrElse
                                     perfil.Equals("Administrador", StringComparison.OrdinalIgnoreCase)

            ' Restrição interna via código
            If Not ehAdmin Then
                Response.Redirect("~/Dashboard.aspx", False)
                Context.ApplicationInstance.CompleteRequest()
                Return
            End If

            If Not IsPostBack Then
                CarregarCategorias()
            End If
        End Sub

        Private Sub CarregarCategorias()
            gvCategorias.DataSource = dao.ListarTodas()
            gvCategorias.DataBind()
        End Sub

        ' Removido Handles btnNovaCategoria.Click (já acionado pelo OnClick no ASPX)
        Protected Sub btnNovaCategoria_Click(ByVal sender As Object, ByVal e As EventArgs)
            hfIdCategoria.Value = "0"
            txtNome.Text = String.Empty
            txtDescricao.Text = String.Empty
            litTituloModal.Text = "Cadastrar Categoria"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
        End Sub

        ' Removido Handles btnSalvar.Click (evita cadastrar duas vezes)
        Protected Sub btnSalvar_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim id As Integer = Convert.ToInt32(hfIdCategoria.Value)
            Dim nome As String = txtNome.Text.Trim()
            Dim desc As String = txtDescricao.Text.Trim()

            If String.IsNullOrEmpty(nome) Then
                ExibirAlerta("Por favor, preencha o nome da categoria.", False)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
                Return
            End If

            Dim cat As New Categoria(id, nome, desc)
            Dim sucesso As Boolean = False

            If id = 0 Then
                sucesso = dao.Inserir(cat)
                If sucesso Then ExibirAlerta("Categoria cadastrada com sucesso!", True)
            Else
                sucesso = dao.Atualizar(cat)
                If sucesso Then ExibirAlerta("Categoria atualizada com sucesso!", True)
            End If

            If sucesso Then
                CarregarCategorias()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal", "fecharModal();", True)
            Else
                ExibirAlerta("Erro ao salvar a categoria no banco de dados.", False)
            End If
        End Sub

        ' Removido Handles gvCategorias.RowCommand (já acionado pelo OnRowCommand no ASPX)
        Protected Sub gvCategorias_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Dim cat As Categoria = dao.ObterPorId(id)
                If cat IsNot Nothing Then
                    hfIdCategoria.Value = cat.IdCategoria.ToString()
                    txtNome.Text = cat.Nome
                    txtDescricao.Text = cat.Descricao
                    litTituloModal.Text = "Editar Categoria"
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
                End If
            ElseIf e.CommandName = "Excluir" Then
                Try
                    If dao.Excluir(id) Then
                        ExibirAlerta("Categoria removida com sucesso!", True)
                        CarregarCategorias()
                    Else
                        ExibirAlerta("Não foi possível excluir a categoria.", False)
                    End If
                Catch ex As Exception
                    ExibirAlerta("Esta categoria não pode ser excluída pois existem livros vinculados a ela.", False)
                End Try
            End If
        End Sub

        Private Sub ExibirAlerta(ByVal mensagem As String, ByVal ehSucesso As Boolean)
            pnlAlerta.Visible = True
            lblMensagemAlerta.Text = mensagem
            pnlAlerta.CssClass = If(ehSucesso, "alert alert-success alert-dismissible fade show", "alert alert-danger alert-dismissible fade show")
        End Sub
    End Class
End Namespace