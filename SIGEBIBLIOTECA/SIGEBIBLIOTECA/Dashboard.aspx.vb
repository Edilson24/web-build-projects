Imports System

Namespace SIGEBIBLIOTECA
    Partial Public Class Dashboard
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Proteção de página: Redireciona para o Login se a Sessão tiver expirado
            If Session("UsuarioId") Is Nothing Then
                Response.Redirect("~/Login.aspx")
            End If
        End Sub
    End Class
End Namespace