Imports System

Namespace SIGEBIBLIOTECA
    Partial Public Class MenuLateral
        Inherits System.Web.UI.UserControl

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                ' Carrega informações de sessão do usuário
                If Session("UsuarioNome") IsNot Nothing Then
                    litNomeUsuario.Text = Session("UsuarioNome").ToString()
                Else
                    litNomeUsuario.Text = "Usuário"
                End If

                ' Controle de Acesso Baseado no Nível do Usuário (aceita "admin" ou "Administrador")
                Dim nivel As String = Convert.ToString(Session("UsuarioNivel")).Trim()
                Dim ehAdmin As Boolean = nivel.Equals("admin", StringComparison.OrdinalIgnoreCase) OrElse
                                         nivel.Equals("Administrador", StringComparison.OrdinalIgnoreCase)

                phMenuAdmin.Visible = ehAdmin
                phLogsAdmin.Visible = ehAdmin
            End If
        End Sub

        ''' <summary>
        ''' Função helper para destacar visualmente a opção ativa no menu
        ''' </summary>
        Protected Function ObterClasseAtiva(ByVal nomePagina As String) As String
            Dim caminhoAtual As String = Request.Url.AbsolutePath
            If caminhoAtual.EndsWith(nomePagina, StringComparison.OrdinalIgnoreCase) Then
                Return "active"
            End If
            Return String.Empty
        End Function

        ' Realiza o encerramento seguro da sessão
        Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
            Session.Clear()
            Session.Abandon()
            Response.Redirect("~/Login.aspx")
        End Sub
    End Class
End Namespace