Imports System
Imports System.Data
Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers

Namespace SIGEBIBLIOTECA.DAO
    Public Class RelatoriosDAO

        Public Function ObterDadosRelatorio(tipo As String, dataInicio As String, dataFim As String, termo As String) As DataTable
            Dim dt As New DataTable()

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = ""
                Dim cmd As New MySqlCommand()
                cmd.Connection = conn

                ' Formata datas para o padrão MySQL (YYYY-MM-DD HH:MM:SS) nas comparações
                Dim dtInicioFmt As String = If(Not String.IsNullOrEmpty(dataInicio), dataInicio & " 00:00:00", "")
                Dim dtFimFmt As String = If(Not String.IsNullOrEmpty(dataFim), dataFim & " 23:59:59", "")

                Select Case tipo.ToUpper()
                    Case "EMPRESTIMOS"
                        sql = "SELECT e.idemprestimo AS 'ID', " &
                              "l.nome AS 'Leitor', " &
                              "lv.titulo AS 'Livro', " &
                              "DATE_FORMAT(e.data_emprestimo, '%d/%m/%Y %H:%i') AS 'Data Empréstimo', " &
                              "DATE_FORMAT(e.data_prevista_devolucao, '%d/%m/%Y') AS 'Devolução Prevista', " &
                              "e.status AS 'Status', " &
                              "FORMAT(IFNULL(e.valor_total_pago, e.valor_pago_adiantado), 2) AS 'Pago Até Momento (MT)' " &
                              "FROM emprestimos e " &
                              "INNER JOIN leitores l ON e.idleitor = l.idleitor " &
                              "INNER JOIN livros lv ON e.idlivro = lv.idlivro " &
                              "WHERE 1=1 "

                        If Not String.IsNullOrEmpty(dataInicio) Then
                            sql &= " AND e.data_emprestimo >= @dataInicio"
                            cmd.Parameters.AddWithValue("@dataInicio", dtInicioFmt)
                        End If
                        If Not String.IsNullOrEmpty(dataFim) Then
                            sql &= " AND e.data_emprestimo <= @dataFim"
                            cmd.Parameters.AddWithValue("@dataFim", dtFimFmt)
                        End If
                        If Not String.IsNullOrEmpty(termo) Then
                            sql &= " AND (l.nome LIKE @termo OR lv.titulo LIKE @termo OR e.status LIKE @termo)"
                            cmd.Parameters.AddWithValue("@termo", "%" & termo & "%")
                        End If

                        sql &= " ORDER BY e.idemprestimo DESC"

                    Case "DEVOLUCOES"
                        sql = "SELECT e.idemprestimo AS 'ID', " &
                              "l.nome AS 'Leitor', " &
                              "lv.titulo AS 'Livro', " &
                              "DATE_FORMAT(e.data_emprestimo, '%d/%m/%Y') AS 'Data Empréstimo', " &
                              "DATE_FORMAT(e.data_real_devolucao, '%d/%m/%Y %H:%i') AS 'Data Devolução Real', " &
                              "FORMAT((IFNULL(e.valor_multa_atraso, 0) + IFNULL(e.valor_multa_dano, 0)), 2) AS 'Total Multas (MT)', " &
                              "FORMAT(IFNULL(e.valor_total_pago, (e.valor_pago_adiantado + e.valor_saldo_aluguel + IFNULL(e.valor_multa_atraso, 0) + IFNULL(e.valor_multa_dano, 0))), 2) AS 'Total Pago (MT)' " &
                              "FROM emprestimos e " &
                              "INNER JOIN leitores l ON e.idleitor = l.idleitor " &
                              "INNER JOIN livros lv ON e.idlivro = lv.idlivro " &
                              "WHERE e.status = 'devolvido' "

                        If Not String.IsNullOrEmpty(dataInicio) Then
                            sql &= " AND e.data_real_devolucao >= @dataInicio"
                            cmd.Parameters.AddWithValue("@dataInicio", dtInicioFmt)
                        End If
                        If Not String.IsNullOrEmpty(dataFim) Then
                            sql &= " AND e.data_real_devolucao <= @dataFim"
                            cmd.Parameters.AddWithValue("@dataFim", dtFimFmt)
                        End If
                        If Not String.IsNullOrEmpty(termo) Then
                            sql &= " AND (l.nome LIKE @termo OR lv.titulo LIKE @termo)"
                            cmd.Parameters.AddWithValue("@termo", "%" & termo & "%")
                        End If

                        sql &= " ORDER BY e.data_real_devolucao DESC"

                    Case "LEITORES"
                        ' Ajustado conforme a tabela `leitores`
                        sql = "SELECT idleitor AS 'ID', " &
                              "nome AS 'Nome Completo', " &
                              "telefone AS 'Telefone', " &
                              "tipo_leitor AS 'Tipo Leitor', " &
                              "IFNULL(curso, '-') AS 'Curso', " &
                              "IFNULL(turma, '-') AS 'Turma', " &
                              "total_emprestimos_concluidos AS 'Empréstimos Concluídos', " &
                              "IF(ativo = 1, 'Ativo', 'Inativo') AS 'Situação' " &
                              "FROM leitores WHERE 1=1 "

                        If Not String.IsNullOrEmpty(termo) Then
                            sql &= " AND (nome LIKE @termo OR telefone LIKE @termo OR curso LIKE @termo OR turma LIKE @termo)"
                            cmd.Parameters.AddWithValue("@termo", "%" & termo & "%")
                        End If

                        sql &= " ORDER BY nome ASC"

                    Case "LIVROS"
                        ' Ajustado conforme a tabela `livros`
                        sql = "SELECT lv.idlivro AS 'ID', " &
                              "lv.titulo AS 'Título', " &
                              "lv.autor AS 'Autor', " &
                              "lv.editora AS 'Editora', " &
                              "IFNULL(c.nome, 'Sem Categoria') AS 'Categoria', " &
                              "FORMAT(lv.preco_emprestimo_dia, 2) AS 'Preço/Dia (MT)', " &
                              "lv.qtd_total AS 'Total', " &
                              "lv.qtd_disponivel AS 'Disponíveis', " &
                              "lv.estado AS 'Estado' " &
                              "FROM livros lv " &
                              "LEFT JOIN categorias c ON lv.idcategoria = c.idcategoria " &
                              "WHERE 1=1 "

                        If Not String.IsNullOrEmpty(termo) Then
                            sql &= " AND (lv.titulo LIKE @termo OR lv.autor LIKE @termo OR lv.editora LIKE @termo OR c.nome LIKE @termo)"
                            cmd.Parameters.AddWithValue("@termo", "%" & termo & "%")
                        End If

                        sql &= " ORDER BY lv.titulo ASC"

                    Case "ARRECADACAO"
                        sql = "SELECT e.idemprestimo AS 'Código Emp.', " &
                              "l.nome AS 'Leitor', " &
                              "DATE_FORMAT(e.data_emprestimo, '%d/%m/%Y') AS 'Data Início', " &
                              "FORMAT(e.valor_total_aluguel, 2) AS 'Aluguel Total (MT)', " &
                              "FORMAT(e.valor_pago_adiantado, 2) AS 'Pago Adiantado (MT)', " &
                              "FORMAT((IFNULL(e.valor_multa_atraso, 0) + IFNULL(e.valor_multa_dano, 0)), 2) AS 'Total Multas (MT)', " &
                              "FORMAT(IFNULL(e.valor_total_pago, (e.valor_pago_adiantado + e.valor_saldo_aluguel + IFNULL(e.valor_multa_atraso, 0) + IFNULL(e.valor_multa_dano, 0))), 2) AS 'Total Recolhido (MT)' " &
                              "FROM emprestimos e " &
                              "INNER JOIN leitores l ON e.idleitor = l.idleitor " &
                              "WHERE (e.valor_pago_adiantado > 0 OR e.valor_total_pago > 0) "

                        If Not String.IsNullOrEmpty(dataInicio) Then
                            sql &= " AND e.data_emprestimo >= @dataInicio"
                            cmd.Parameters.AddWithValue("@dataInicio", dtInicioFmt)
                        End If
                        If Not String.IsNullOrEmpty(dataFim) Then
                            sql &= " AND e.data_emprestimo <= @dataFim"
                            cmd.Parameters.AddWithValue("@dataFim", dtFimFmt)
                        End If
                        If Not String.IsNullOrEmpty(termo) Then
                            sql &= " AND (l.nome LIKE @termo)"
                            cmd.Parameters.AddWithValue("@termo", "%" & termo & "%")
                        End If

                        sql &= " ORDER BY e.idemprestimo DESC"
                End Select

                cmd.CommandText = sql
                conn.Open()
                Using adapter As New MySqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using
            End Using

            Return dt
        End Function

    End Class
End Namespace