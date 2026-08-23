Imports System
Imports System.Collections.Generic
Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers

Namespace SIGEBIBLIOTECA.DAO
    Public Class DashboardDAO

        ' Estruturas DTO internas para transporte leve de dados
        Public Class EstatisticasDTO
            Public Property EmprestimosAtivos As Integer
            Public Property DevolucoesConcluidas As Integer
            Public Property ReceitaTotal As Decimal
            Public Property TotalLeitores As Integer
        End Class

        Public Class LeitorFrequenteDTO
            Public Property NomeLeitor As String
            Public Property QtdEmprestimos As Integer
            Public Property Status As String
        End Class

        Public Class LivroSolicitadoDTO
            Public Property Titulo As String
            Public Property Categoria As String
            Public Property QtdExemplares As Integer
        End Class

        ''' <summary>
        ''' Obtém os 4 indicadores principais dos cards
        ''' </summary>
        Public Function ObterEstatisticasGerais() As EstatisticasDTO
            Dim stats As New EstatisticasDTO()

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                conn.Open()

                ' 1. Empréstimos Ativos
                Dim sqlEmprestimos As String = "SELECT COUNT(*) FROM emprestimos WHERE status = 'em_andamento'"
                Using cmd As New MySqlCommand(sqlEmprestimos, conn)
                    stats.EmprestimosAtivos = Convert.ToInt32(cmd.ExecuteScalar())
                End Using

                ' 2. Devoluções Concluídas
                Dim sqlDevolucoes As String = "SELECT COUNT(*) FROM emprestimos WHERE status = 'devolvido'"
                Using cmd As New MySqlCommand(sqlDevolucoes, conn)
                    stats.DevolucoesConcluidas = Convert.ToInt32(cmd.ExecuteScalar())
                End Using

                ' 3. Receita Total (Soma de aluguéis e multas cobradas)
                Dim sqlReceita As String = "SELECT IFNULL(SUM(valor_total_pago), 0) FROM emprestimos"
                Using cmd As New MySqlCommand(sqlReceita, conn)
                    stats.ReceitaTotal = Convert.ToDecimal(cmd.ExecuteScalar())
                End Using

                ' 4. Total de Leitores Cadastrados
                Dim sqlLeitores As String = "SELECT COUNT(*) FROM leitores"
                Using cmd As New MySqlCommand(sqlLeitores, conn)
                    stats.TotalLeitores = Convert.ToInt32(cmd.ExecuteScalar())
                End Using
            End Using

            Return stats
        End Function

        ''' <summary>
        ''' Obtém o faturamento mensal dos últimos 6 meses para o gráfico
        ''' </summary>
        Public Function ObterEvolucaoReceitaMensal() As Dictionary(Of String, Decimal)
            Dim resultado As New Dictionary(Of String, Decimal)()

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT DATE_FORMAT(data_emprestimo, '%b/%Y') AS mes_ano, " &
                                    "       IFNULL(SUM(valor_total_pago), 0) AS total " &
                                    "FROM emprestimos " &
                                    "WHERE data_emprestimo >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " &
                                    "GROUP BY YEAR(data_emprestimo), MONTH(data_emprestimo), DATE_FORMAT(data_emprestimo, '%b/%Y') " &
                                    "ORDER BY YEAR(data_emprestimo) ASC, MONTH(data_emprestimo) ASC"

                Dim cmd As New MySqlCommand(sql, conn)
                conn.Open()
                Using dr As MySqlDataReader = cmd.ExecuteReader()
                    While dr.Read()
                        resultado.Add(dr("mes_ano").ToString(), Convert.ToDecimal(dr("total")))
                    End While
                End Using
            End Using

            Return resultado
        End Function

        ''' <summary>
        ''' Lista os leitores com maior número de empréstimos
        ''' </summary>
        Public Function ObterLeitoresFrequentes() As List(Of LeitorFrequenteDTO)
            Dim lista As New List(Of LeitorFrequenteDTO)()
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT l.nome, COUNT(e.idemprestimo) AS total_emp " &
                                    "FROM emprestimos e " &
                                    "INNER JOIN leitores l ON e.idleitor = l.idleitor " &
                                    "GROUP BY l.idleitor, l.nome " &
                                    "ORDER BY total_emp DESC LIMIT 5"

                Dim cmd As New MySqlCommand(sql, conn)
                conn.Open()
                Using dr As MySqlDataReader = cmd.ExecuteReader()
                    While dr.Read()
                        lista.Add(New LeitorFrequenteDTO() With {
                            .NomeLeitor = dr("nome").ToString(),
                            .QtdEmprestimos = Convert.ToInt32(dr("total_emp")),
                            .Status = "Ativo"
                        })
                    End While
                End Using
            End Using
            Return lista
        End Function

        ''' <summary>
        ''' Lista os livros mais requisitados
        ''' </summary>
        Public Function ObterLivrosMaisSolicitados() As List(Of LivroSolicitadoDTO)
            Dim lista As New List(Of LivroSolicitadoDTO)()
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT lv.titulo, IFNULL(c.nome, 'Geral') AS categoria, lv.qtd_disponivel " &
                                    "FROM emprestimos e " &
                                    "INNER JOIN livros lv ON e.idlivro = lv.idlivro " &
                                    "LEFT JOIN categorias c ON lv.idcategoria = c.idcategoria " &
                                    "GROUP BY lv.idlivro, lv.titulo, c.nome, lv.qtd_disponivel " &
                                    "ORDER BY COUNT(e.idemprestimo) DESC LIMIT 5"

                Dim cmd As New MySqlCommand(sql, conn)
                conn.Open()
                Using dr As MySqlDataReader = cmd.ExecuteReader()
                    While dr.Read()
                        lista.Add(New LivroSolicitadoDTO() With {
                            .Titulo = dr("titulo").ToString(),
                            .Categoria = dr("categoria").ToString(),
                            .QtdExemplares = Convert.ToInt32(dr("qtd_disponivel"))
                        })
                    End While
                End Using
            End Using
            Return lista
        End Function

    End Class
End Namespace