Namespace SIGEBIBLIOTECA.Models
    Public Class Leitor
        Public Property IdLeitor As Integer
        Public Property Nome As String
        Public Property Endereco As String
        Public Property Telefone As String
        Public Property TipoLeitor As String ' estudante, docente, externo
        Public Property Curso As String
        Public Property Turma As String
        Public Property TotalEmprestimosConcluidos As Integer
        Public Property Ativo As Boolean

        Public Sub New()
            Me.Ativo = True
            Me.TotalEmprestimosConcluidos = 0
        End Sub
    End Class
End Namespace