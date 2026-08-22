Namespace SIGEBIBLIOTECA.Models
    Public Class Emprestimo
        Public Property IdEmprestimo As Integer
        Public Property IdLeitor As Integer
        Public Property NomeLeitor As String
        Public Property IdLivro As Integer
        Public Property TituloLivro As String
        Public Property IdUsuarioEmprestimo As Integer
        Public Property IdUsuarioDevolucao As Nullable(Of Integer)

        Public Property DataEmprestimo As DateTime
        Public Property DataPrevistaDevolucao As DateTime
        Public Property DataRealDevolucao As Nullable(Of DateTime)

        Public Property DiasPrevistos As Integer
        Public Property PrecoDiarioAplicado As Decimal
        Public Property TeveDescontoFidelidade As Boolean

        Public Property ValorTotalAluguel As Decimal
        Public Property ValorPagoAdiantado As Decimal ' 70%
        Public Property ValorSaldoAluguel As Decimal  ' 30%

        Public Property DiasAtraso As Integer
        Public Property ValorMultaAtraso As Decimal
        Public Property HouveDano As Boolean
        Public Property ValorMultaDano As Decimal
        Public Property ValorTotalPago As Nullable(Of Decimal)

        Public Property Status As String ' 'em_andamento' ou 'devolvido'
        Public Property ValorCompraLivro As Decimal ' Auxiliar para cálculo de dano
    End Class
End Namespace