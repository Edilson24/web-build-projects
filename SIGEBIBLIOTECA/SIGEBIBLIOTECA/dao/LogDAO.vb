Imports System.Collections.Generic
Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.DAO
    Public Class LogDAO

        ''' <summary>
        ''' Registra uma nova ação diretamente na tabela de logs nativa.
        ''' </summary>
        Public Function RegistrarLog(idUsuario As Integer, acao As String) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "INSERT INTO logs_sistema (idusuario, acao, data_hora) VALUES (@idusuario, @acao, NOW())"
                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@idusuario", idUsuario)
                cmd.Parameters.AddWithValue("@acao", acao)
                conn.Open()
                Return cmd.ExecuteNonQuery() > 0
            End Using
        End Function

        ''' <summary>
        ''' Retorna a auditoria unificada trazendo dados da tabela logs_sistema 
        ''' e combinando com o histórico operacional da tabela emprestimos.
        ''' </summary>
        Public Function ListarTodos() As List(Of LogModel)
            Dim lista As New List(Of LogModel)()
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                ' Consulta unificada (UNION ALL)
                Dim sql As String = "SELECT * FROM (" &
                                    "  SELECT l.idlog AS id_origem, l.idusuario, u.nome AS nome_usuario, l.acao, l.data_hora " &
                                    "  FROM logs_sistema l " &
                                    "  INNER JOIN usuarios u ON l.idusuario = u.idusuario " &
                                    "  UNION ALL " &
                                    "  SELECT e.idemprestimo AS id_origem, e.idusuario_emprestimo AS idusuario, u.nome AS nome_usuario, " &
                                    "         CONCAT('Registro de Empréstimo (Cód: #', e.idemprestimo, ' - Total: ', FORMAT(e.valor_total_aluguel, 2), ' MT)') AS acao, " &
                                    "         e.data_emprestimo AS data_hora " &
                                    "  FROM emprestimos e " &
                                    "  INNER JOIN usuarios u ON e.idusuario_emprestimo = u.idusuario " &
                                    "  UNION ALL " &
                                    "  SELECT e.idemprestimo AS id_origem, e.idusuario_devolucao AS idusuario, u.nome AS nome_usuario, " &
                                    "         CONCAT('Devolução Concluída (Cód: #', e.idemprestimo, ' - Total Pago: ', FORMAT(IFNULL(e.valor_total_pago, 0), 2), ' MT)') AS acao, " &
                                    "         e.data_real_devolucao AS data_hora " &
                                    "  FROM emprestimos e " &
                                    "  INNER JOIN usuarios u ON e.idusuario_devolucao = u.idusuario " &
                                    "  WHERE e.data_real_devolucao IS NOT NULL " &
                                    ") AS auditoria_unificada " &
                                    "ORDER BY data_hora DESC LIMIT 150"

                Dim cmd As New MySqlCommand(sql, conn)
                conn.Open()
                Using dr As MySqlDataReader = cmd.ExecuteReader()
                    Dim idContador As Integer = 1
                    While dr.Read()
                        lista.Add(New LogModel() With {
                            .IdLog = idContador,
                            .IdUsuario = Convert.ToInt32(dr("idusuario")),
                            .NomeUsuario = dr("nome_usuario").ToString(),
                            .Acao = dr("acao").ToString(),
                            .DataHora = Convert.ToDateTime(dr("data_hora"))
                        })
                        idContador += 1
                    End While
                End Using
            End Using
            Return lista
        End Function

    End Class
End Namespace