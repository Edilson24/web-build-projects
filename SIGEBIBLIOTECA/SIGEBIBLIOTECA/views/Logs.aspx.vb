Imports System
Imports System.Web.UI
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.DAO

Namespace SIGEBIBLIOTECA.views
    Partial Public Class Logs
        Inherits System.Web.UI.Page

        Private ReadOnly logDao As New LogDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Restrição de Acesso: Apenas Administradores têm acesso a esta tela (RN 16)
            Dim perfil As String = If(Session("UsuarioNivel") IsNot Nothing, Session("UsuarioNivel").ToString().Trim(), "")
            Dim eAdmin As Boolean = perfil.Equals("admin", StringComparison.OrdinalIgnoreCase) OrElse
                                    perfil.Equals("Administrador", StringComparison.OrdinalIgnoreCase)

            If Not eAdmin Then
                Response.Redirect("~/views/Dashboard.aspx", False)
                Context.ApplicationInstance.CompleteRequest()
                Return
            End If

            If Not IsPostBack Then
                CarregarLogs()
            End If
        End Sub

        Private Sub CarregarLogs()
            gvLogs.DataSource = logDao.ListarTodos()
            gvLogs.DataBind()
        End Sub
    End Class
End Namespace