Imports System

Namespace SIGEBIBLIOTECA.Models
    Public Class Categoria
        Public Property IdCategoria As Integer
        Public Property Nome As String
        Public Property Descricao As String

        Public Sub New()
        End Sub

        Public Sub New(ByVal id As Integer, ByVal nome As String, ByVal descricao As String)
            Me.IdCategoria = id
            Me.Nome = nome
            Me.Descricao = descricao
        End Sub
    End Class
End Namespace