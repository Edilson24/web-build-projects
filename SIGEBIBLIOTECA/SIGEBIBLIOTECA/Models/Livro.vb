Namespace SIGEBIBLIOTECA.Models
    Public Class Livro
        Public Property IdLivro As Integer
        Public Property IdCategoria As Integer
        Public Property NomeCategoria As String ' Auxiliar para exibição em GridView / Consultas
        Public Property Titulo As String
        Public Property Autor As String
        Public Property Editora As String
        Public Property Edicao As String
        Public Property AnoPublicacao As Nullable(Of Integer)
        Public Property PrecoEmprestimoDia As Decimal
        Public Property ValorCompra As Decimal
        Public Property QtdTotal As Integer
        Public Property QtdDisponivel As Integer
        Public Property Estado As String ' 'disponivel' ou 'esgotado'

        Public Sub New()
        End Sub

        Public Sub New(idLivro As Integer, idCategoria As Integer, titulo As String, autor As String, editora As String, edicao As String, anoPublicacao As Nullable(Of Integer), precoEmprestimoDia As Decimal, valorCompra As Decimal, qtdTotal As Integer, qtdDisponivel As Integer, estado As String)
            Me.IdLivro = idLivro
            Me.IdCategoria = idCategoria
            Me.Titulo = titulo
            Me.Autor = autor
            Me.Editora = editora
            Me.Edicao = edicao
            Me.AnoPublicacao = anoPublicacao
            Me.PrecoEmprestimoDia = precoEmprestimoDia
            Me.ValorCompra = valorCompra
            Me.QtdTotal = qtdTotal
            Me.QtdDisponivel = qtdDisponivel
            Me.Estado = estado
        End Sub
    End Class
End Namespace