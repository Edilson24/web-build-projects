Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.views
    Partial Public Class Usuarios
        Inherits System.Web.UI.Page

        Private ReadOnly usuarioDao As New UsuarioDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Restrição de Acesso: Apenas Administradores têm acesso a esta tela (RN 16)
            Dim perfilSessao As String = If(Session("UsuarioNivel") IsNot Nothing, Session("UsuarioNivel").ToString().ToLower(), "")
            If perfilSessao <> "admin" Then
                Response.Redirect("/Dashboard.aspx")
            End If

            If Not IsPostBack Then
                CarregarUsuarios()
            End If
        End Sub

        Private Sub CarregarUsuarios()
            gvUsuarios.DataSource = usuarioDao.ListarTodos()
            gvUsuarios.DataBind()
        End Sub

        Protected Sub btnNovoUsuario_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimparFormulario()
            litTituloModal.Text = "<i class='fa-solid fa-user-plus me-2'></i>Novo Usuário"
            ' Substitua as chamadas do RegisterStartupScript no Usuarios.aspx.vb por este formato:
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "<script type='text/javascript'>abrirModal('modalUsuario');</script>", False)
        End Sub

        Protected Sub gvUsuarios_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            Dim idUsuario As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "EditarUsuario" Then
                Dim u As Usuario = usuarioDao.BuscarPorId(idUsuario)
                If u IsNot Nothing Then
                    hfIdUsuario.Value = u.IdUsuario.ToString()
                    txtNome.Text = u.Nome
                    txtEmail.Text = u.Email
                    txtSenha.Text = u.Senha
                    ddlPerfil.SelectedValue = u.Perfil.ToLower()

                    litTituloModal.Text = "<i class='fa-solid fa-user-pen me-2'></i>Editar Usuário"
                    ' Substitua as chamadas do RegisterStartupScript no Usuarios.aspx.vb por este formato:
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "<script type='text/javascript'>abrirModal('modalUsuario');</script>", False)
                End If

            ElseIf e.CommandName = "AlternarStatus" Then
                ' Trava de Segurança: Não permite que o próprio usuário logado se desative
                Dim idLogado As Integer = If(Session("UsuarioId") IsNot Nothing, Convert.ToInt32(Session("UsuarioId")), 0)
                If idUsuario = idLogado Then
                    ExibirAlerta("Operação negada: Você não pode desativar a sua própria conta logada.", False)
                    Return
                End If

                If usuarioDao.AlternarStatus(idUsuario) Then
                    ExibirAlerta("Status do usuário alterado com sucesso!", True)
                    CarregarUsuarios()
                Else
                    ExibirAlerta("Erro ao tentar alterar o status do usuário.", False)
                End If
            End If
        End Sub

        Protected Sub btnSalvarUsuario_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim idUsuario As Integer = Convert.ToInt32(hfIdUsuario.Value)
            Dim nome As String = txtNome.Text.Trim()
            Dim email As String = txtEmail.Text.Trim()
            Dim senha As String = txtSenha.Text.Trim()
            Dim perfil As String = ddlPerfil.SelectedValue

            If String.IsNullOrEmpty(nome) OrElse String.IsNullOrEmpty(email) OrElse String.IsNullOrEmpty(senha) Then
                ExibirAlerta("Preencha todos os campos obrigatórios (*).", False)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal('modalUsuario');", True)
                Return
            End If

            Dim u As New Usuario() With {
                .IdUsuario = idUsuario,
                .Nome = nome,
                .Email = email,
                .Senha = senha,
                .Perfil = perfil
            }

            Dim resultado As Boolean
            If idUsuario = 0 Then
                resultado = usuarioDao.Inserir(u)

            Else
                resultado = usuarioDao.Atualizar(u)
            End If

            If resultado Then
                ' 1. Fecha o modal e remove o fundo escuro (backdrop)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "CloseModal", "<script type='text/javascript'>fecharModal('modalUsuario');</script>", False)

                ' 2. Exibe o alerta e atualiza a tabela
                ExibirAlerta("Registro de usuário salvo com sucesso!", True)
                CarregarUsuarios()
            Else
                ExibirAlerta("Falha ao salvar o usuário. Verifique se o e-mail já está em uso.", False)
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "<script type='text/javascript'>abrirModal('modalUsuario');</script>", False)
            End If
        End Sub

        Private Sub LimparFormulario()
            hfIdUsuario.Value = "0"
            txtNome.Text = String.Empty
            txtEmail.Text = String.Empty
            txtSenha.Text = String.Empty
            ddlPerfil.SelectedIndex = 0
        End Sub

        Private Sub ExibirAlerta(mensagem As String, sucesso As Boolean)
            lblMensagemAlerta.Text = mensagem
            pnlAlerta.CssClass = If(sucesso, "alert alert-success alert-dismissible fade show", "alert alert-danger alert-dismissible fade show")
            pnlAlerta.Visible = True
        End Sub
    End Class
End Namespace