Imports System
Imports System.Web
Imports System.Web.UI

Namespace SIGEBIBLIOTECA
    Partial Public Class Login
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Lógica de carregamento inicial (se houver)
        End Sub

        Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
            pnlErro.Visible = False
            lblErro.Text = String.Empty

            Dim email As String = txtEmail.Text.Trim()
            Dim senha As String = txtSenha.Text.Trim()

            If String.IsNullOrEmpty(email) OrElse String.IsNullOrEmpty(senha) Then
                ExibirErro("Preencha todos os campos obrigatórios.")
                Return
            End If

            Try
                Dim dao As New UsuarioDAO()
                Dim usuario As Usuario = dao.Autenticar(email, senha)

                If usuario IsNot Nothing Then
                    Session("UsuarioId") = usuario.Id
                    Session("UsuarioNome") = usuario.Nome
                    Session("UsuarioNivel") = usuario.NivelAcesso

                    Response.Redirect("~/Dashboard.aspx")
                Else
                    ExibirErro("E-mail ou senha incorretos.")
                End If

            Catch ex As Exception
                ExibirErro("Erro ao conectar ao banco de dados: " & ex.Message)
            End Try
        End Sub

        Private Sub ExibirErro(ByVal mensagem As String)
            pnlErro.Visible = True
            lblErro.Text = mensagem
        End Sub
    End Class
End Namespace