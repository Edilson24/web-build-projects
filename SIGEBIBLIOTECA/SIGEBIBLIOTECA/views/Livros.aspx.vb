Imports System
Imports System.Collections.Generic
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA
    Partial Public Class Livros
        Inherits System.Web.UI.Page

        Private ReadOnly livroDao As New LivroDAO()
        Private ReadOnly categoriaDao As New CategoriaDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Restrição do nível de acesso (Admin ou Atendente autorizado)
            Dim perfil As String = If(Session("UsuarioNivel") IsNot Nothing, Session("UsuarioNivel").ToString().Trim(), "")
            Dim autorizado As Boolean = perfil.Equals("admin", StringComparison.OrdinalIgnoreCase) OrElse
                                        perfil.Equals("Administrador", StringComparison.OrdinalIgnoreCase) OrElse
                                        perfil.Equals("atendente", StringComparison.OrdinalIgnoreCase)

            If Not autorizado Then
                Response.Redirect("~/Dashboard.aspx", False)
                Context.ApplicationInstance.CompleteRequest()
                Return
            End If

            If Not IsPostBack Then
                CarregarCategoriasDropdown()
                CarregarLivros()
            End If
        End Sub

        Private Sub CarregarCategoriasDropdown()
            ddlCategoria.DataSource = categoriaDao.ListarTodas()
            ddlCategoria.DataTextField = "Nome"
            ddlCategoria.DataValueField = "IdCategoria"
            ddlCategoria.DataBind()
            ddlCategoria.Items.Insert(0, New ListItem("-- Selecione uma Categoria --", "0"))
        End Sub

        Private Sub CarregarLivros()
            gvLivros.DataSource = livroDao.ListarTodos()
            gvLivros.DataBind()
        End Sub

        ' Sem 'Handles btnNovoLivro.Click' para evitar duplo disparo
        Protected Sub btnNovoLivro_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimparFormulario()
            litTituloModal.Text = "Cadastrar Livro"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
        End Sub

        ' Sem 'Handles btnSalvar.Click' para evitar duplo disparo
        Protected Sub btnSalvar_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim id As Integer = Convert.ToInt32(hfIdLivro.Value)
            Dim idCat As Integer = Convert.ToInt32(ddlCategoria.SelectedValue)
            Dim titulo As String = txtTitulo.Text.Trim()
            Dim autor As String = txtAutor.Text.Trim()
            Dim editora As String = txtEditora.Text.Trim()
            Dim edicao As String = txtEdicao.Text.Trim()

            Dim anoPublicacao As Nullable(Of Integer) = Nothing
            If Not String.IsNullOrEmpty(txtAnoPublicacao.Text.Trim()) Then
                anoPublicacao = Convert.ToInt32(txtAnoPublicacao.Text.Trim())
            End If

            Dim precoDia As Decimal = 0
            Decimal.TryParse(txtPrecoEmprestimoDia.Text.Trim().Replace(",", "."), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, precoDia)

            Dim valorCompra As Decimal = 0
            Decimal.TryParse(txtValorCompra.Text.Trim().Replace(",", "."), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, valorCompra)

            Dim qtdTotal As Integer = 0
            Integer.TryParse(txtQtdTotal.Text.Trim(), qtdTotal)

            ' Validações de entrada
            If idCat = 0 OrElse String.IsNullOrEmpty(titulo) OrElse String.IsNullOrEmpty(autor) OrElse String.IsNullOrEmpty(editora) OrElse qtdTotal <= 0 Then
                ExibirAlerta("Por favor, preencha todos os campos obrigatórios (*).", False)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
                Return
            End If

            Dim livroObj As New Livro()
            livroObj.IdLivro = id
            livroObj.IdCategoria = idCat
            livroObj.Titulo = titulo
            livroObj.Autor = autor
            livroObj.Editora = editora
            livroObj.Edicao = edicao
            livroObj.AnoPublicacao = anoPublicacao
            livroObj.PrecoEmprestimoDia = precoDia
            livroObj.ValorCompra = valorCompra
            livroObj.QtdTotal = qtdTotal

            Dim sucesso As Boolean = False

            If id = 0 Then
                ' Cadastro novo: a quantidade disponível é igual ao total inicial
                livroObj.QtdDisponivel = qtdTotal
                livroObj.Estado = If(qtdTotal > 0, "disponivel", "esgotado")
                sucesso = livroDao.Inserir(livroObj)
                If sucesso Then ExibirAlerta("Livro cadastrado com sucesso!", True)
            Else
                ' Edição: recuperar item original para manter a quantidade já emprestada em andamento
                Dim original As Livro = livroDao.ObterPorId(id)
                If original IsNot Nothing Then
                    Dim emprestadosAtualmente As Integer = original.QtdTotal - original.QtdDisponivel
                    Dim novaQtdDisponivel As Integer = qtdTotal - emprestadosAtualmente

                    If novaQtdDisponivel < 0 Then
                        ExibirAlerta("A quantidade total não pode ser menor que a quantidade de cópias atualmente emprestadas.", False)
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
                        Return
                    End If

                    livroObj.QtdDisponivel = novaQtdDisponivel
                    livroObj.Estado = If(novaQtdDisponivel > 0, "disponivel", "esgotado")
                    sucesso = livroDao.Atualizar(livroObj)
                    If sucesso Then ExibirAlerta("Livro atualizado com sucesso!", True)
                End If
            End If

            If sucesso Then
                CarregarLivros()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal", "fecharModal();", True)
            Else
                ExibirAlerta("Ocorreu um erro ao salvar o registro do livro.", False)
            End If
        End Sub

        ' Sem 'Handles gvLivros.RowCommand' para evitar duplo disparo
        Protected Sub gvLivros_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Dim lvr As Livro = livroDao.ObterPorId(id)
                If lvr IsNot Nothing Then
                    hfIdLivro.Value = lvr.IdLivro.ToString()
                    ddlCategoria.SelectedValue = lvr.IdCategoria.ToString()
                    txtTitulo.Text = lvr.Titulo
                    txtAutor.Text = lvr.Autor
                    txtEditora.Text = lvr.Editora
                    txtEdicao.Text = lvr.Edicao
                    txtAnoPublicacao.Text = If(lvr.AnoPublicacao.HasValue, lvr.AnoPublicacao.Value.ToString(), "")
                    txtPrecoEmprestimoDia.Text = lvr.PrecoEmprestimoDia.ToString("F2")
                    txtValorCompra.Text = lvr.ValorCompra.ToString("F2")
                    txtQtdTotal.Text = lvr.QtdTotal.ToString()

                    litTituloModal.Text = "Editar Livro"
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
                End If
            ElseIf e.CommandName = "Excluir" Then
                Try
                    If livroDao.Excluir(id) Then
                        ExibirAlerta("Livro removido com sucesso!", True)
                        CarregarLivros()
                    Else
                        ExibirAlerta("Não foi possível excluir o livro selecionado.", False)
                    End If
                Catch ex As Exception
                    ExibirAlerta("Este livro não pode ser removido pois existem registros de empréstimos vinculados a ele.", False)
                End Try
            End If
        End Sub

        Private Sub LimparFormulario()
            hfIdLivro.Value = "0"
            ddlCategoria.SelectedValue = "0"
            txtTitulo.Text = String.Empty
            txtAutor.Text = String.Empty
            txtEditora.Text = String.Empty
            txtEdicao.Text = String.Empty
            txtAnoPublicacao.Text = String.Empty
            txtPrecoEmprestimoDia.Text = String.Empty
            txtValorCompra.Text = String.Empty
            txtQtdTotal.Text = String.Empty
        End Sub

        Private Sub ExibirAlerta(ByVal mensagem As String, ByVal ehSucesso As Boolean)
            pnlAlerta.Visible = True
            lblMensagemAlerta.Text = mensagem
            pnlAlerta.CssClass = If(ehSucesso, "alert alert-success alert-dismissible fade show", "alert alert-danger alert-dismissible fade show")
        End Sub
    End Class
End Namespace