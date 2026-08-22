Imports System

Namespace SIGEBIBLIOTECA.Models
    Public Class Emprestimo
        Public Property IdEmprestimo As Integer
        Public Property IdLivro As Integer
        Public Property IdLeitor As Integer
        Public Property IdUsuarioEmprestimo As Integer
        Public Property IdUsuarioDevolucao As Nullable(Of Integer)

        Public Property DataEmprestimo As DateTime
        Public Property DataPrevistaDevolucao As DateTime
        Public Property DataRealDevolucao As Nullable(Of DateTime)

        Public Property DiasPrevistos As Integer
        Public Property PrecoDiarioAplicado As Decimal
        Public Property TeveDescontoFidelidade As Boolean
        Public Property ValorTotalAluguel As Decimal
        Public Property ValorPagoAdiantado As Decimal
        Public Property ValorSaldoAluguel As Decimal

        Public Property DiasAtraso As Integer
        Public Property ValorMultaAtraso As Decimal

        Public Property HouveDano As Boolean
        Public Property ValorMultaDano As Decimal
        Public Property ValorTotalPago As Nullable(Of Decimal)
        Public Property Status As String ' "em_andamento" ou "devolvido"

        ' Propriedades para exibição na Grid (Joins)
        Public Property TituloLivro As String
        Public Property NomeLeitor As String
        Public Property NomeUsuarioEmprestimo As String
        Public Property NomeUsuarioDevolucao As String

        Public Sub New()
            Me.Status = "em_andamento"
            Me.DiasAtraso = 0
            Me.ValorMultaAtraso = 0
            Me.HouveDano = False
            Me.ValorMultaDano = 0
        End Sub
    End Class
End Namespace