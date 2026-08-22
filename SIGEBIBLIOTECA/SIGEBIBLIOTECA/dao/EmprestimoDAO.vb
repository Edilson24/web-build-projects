Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.DAO
    Public Class EmprestimoDAO

        ' RN 26: Limite de no máximo 2 empréstimos simultâneos
        Public Function LeitorPodeEmprestar(idLeitor As Integer) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT COUNT(*) FROM emprestimos WHERE idleitor = @idLeitor AND status = 'em_andamento'"
                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@idLeitor", idLeitor)
                conn.Open()
                Return Convert.ToInt32(cmd.ExecuteScalar()) < 2
            End Using
        End Function

        ' RN 25: Desconto por fidelidade a cada 5 empréstimos
        Public Function VerificarDescontoFidelidade(idLeitor As Integer) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT total_emprestimos_concluidos FROM leitores WHERE idleitor = @idLeitor"
                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@idLeitor", idLeitor)
                conn.Open()
                Dim total As Integer = Convert.ToInt32(cmd.ExecuteScalar() Or 0)
                Return ((total + 1) Mod 5 = 0)
            End Using
        End Function

        ' Insert com transação: Empréstimo + Decremento de Estoque (RN 10, 24)
        Public Function InserirEmprestimo(emp As Emprestimo) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                conn.Open()
                Dim trans As MySqlTransaction = conn.BeginTransaction()
                Try
                    Dim sqlEmp As String = "INSERT INTO emprestimos (idleitor, idlivro, idusuario_emprestimo, data_emprestimo, " &
                                          "data_prevista_devolucao, dias_previstos, preco_diario_aplicado, teve_desconto_fidelidade, " &
                                          "valor_total_aluguel, valor_pago_adiantado, valor_saldo_aluguel, status) " &
                                          "VALUES (@idleitor, @idlivro, @idUserEmp, @dataEmp, @dataPrev, @diasPrev, @precoDia, " &
                                          "@desconto, @totalAluguel, @adiantado, @saldo, 'em_andamento')"

                    Dim cmdEmp As New MySqlCommand(sqlEmp, conn, trans)
                    cmdEmp.Parameters.AddWithValue("@idleitor", emp.IdLeitor)
                    cmdEmp.Parameters.AddWithValue("@idlivro", emp.IdLivro)
                    cmdEmp.Parameters.AddWithValue("@idUserEmp", emp.IdUsuarioEmprestimo)
                    cmdEmp.Parameters.AddWithValue("@dataEmp", emp.DataEmprestimo)
                    cmdEmp.Parameters.AddWithValue("@dataPrev", emp.DataPrevistaDevolucao)
                    cmdEmp.Parameters.AddWithValue("@diasPrev", emp.DiasPrevistos)
                    cmdEmp.Parameters.AddWithValue("@precoDia", emp.PrecoDiarioAplicado)
                    cmdEmp.Parameters.AddWithValue("@desconto", emp.TeveDescontoFidelidade)
                    cmdEmp.Parameters.AddWithValue("@totalAluguel", emp.ValorTotalAluguel)
                    cmdEmp.Parameters.AddWithValue("@adiantado", emp.ValorPagoAdiantado)
                    cmdEmp.Parameters.AddWithValue("@saldo", emp.ValorSaldoAluguel)
                    cmdEmp.ExecuteNonQuery()

                    ' Decrementar estoque e atualizar estado (RN 9 e 10)
                    Dim sqlEstoque As String = "UPDATE livros SET qtd_disponivel = qtd_disponivel - 1, " &
                                              "estado = IF(qtd_disponivel - 1 <= 0, 'esgotado', 'disponivel') " &
                                              "WHERE idlivro = @idlivro"
                    Dim cmdEstoque As New MySqlCommand(sqlEstoque, conn, trans)
                    cmdEstoque.Parameters.AddWithValue("@idlivro", emp.IdLivro)
                    cmdEstoque.ExecuteNonQuery()

                    trans.Commit()
                    Return True
                Catch
                    trans.Rollback()
                    Return False
                End Try
            End Using
        End Function

        ' Registrar Devolução + Retorno do Estoque + Incrementar Fidelidade (RN 21, 23, 24, 25, 29)
        Public Function RegistrarDevolucao(emp As Emprestimo) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                conn.Open()
                Dim trans As MySqlTransaction = conn.BeginTransaction()
                Try
                    Dim sqlDev As String = "UPDATE emprestimos SET idusuario_devolucao = @idUserDev, data_real_devolucao = @dataReal, " &
                                          "dias_atraso = @diasAtraso, valor_multa_atraso = @multaAtraso, houve_dano = @houveDano, " &
                                          "valor_multa_dano = @multaDano, valor_total_pago = @totalPago, status = 'devolvido' " &
                                          "WHERE idemprestimo = @idEmp"

                    Dim cmdDev As New MySqlCommand(sqlDev, conn, trans)
                    cmdDev.Parameters.AddWithValue("@idUserDev", emp.IdUsuarioDevolucao)
                    cmdDev.Parameters.AddWithValue("@dataReal", emp.DataRealDevolucao)
                    cmdDev.Parameters.AddWithValue("@diasAtraso", emp.DiasAtraso)
                    cmdDev.Parameters.AddWithValue("@multaAtraso", emp.ValorMultaAtraso)
                    cmdDev.Parameters.AddWithValue("@houveDano", emp.HouveDano)
                    cmdDev.Parameters.AddWithValue("@multaDano", emp.ValorMultaDano)
                    cmdDev.Parameters.AddWithValue("@totalPago", emp.ValorTotalPago)
                    cmdDev.Parameters.AddWithValue("@idEmp", emp.IdEmprestimo)
                    cmdDev.ExecuteNonQuery()

                    ' Reposição do estoque (RN 29)
                    Dim sqlEstoque As String = "UPDATE livros SET qtd_disponivel = qtd_disponivel + 1, estado = 'disponivel' WHERE idlivro = @idlivro"
                    Dim cmdEstoque As New MySqlCommand(sqlEstoque, conn, trans)
                    cmdEstoque.Parameters.AddWithValue("@idlivro", emp.IdLivro)
                    cmdEstoque.ExecuteNonQuery()

                    ' Incrementar fidelidade no leitor (RN 25)
                    Dim sqlLeitor As String = "UPDATE leitores SET total_emprestimos_concluidos = total_emprestimos_concluidos + 1 WHERE idleitor = @idleitor"
                    Dim cmdLeitor As New MySqlCommand(sqlLeitor, conn, trans)
                    cmdLeitor.Parameters.AddWithValue("@idleitor", emp.IdLeitor)
                    cmdLeitor.ExecuteNonQuery()

                    trans.Commit()
                    Return True
                Catch
                    trans.Rollback()
                    Return False
                End Try
            End Using
        End Function

        ' Preencher GridView
        Public Function ListarTodos() As DataTable
            Dim dt As New DataTable()
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT e.idemprestimo, l.nome AS nome_leitor, b.titulo AS titulo_livro, " &
                                     "e.data_emprestimo, e.data_prevista_devolucao, e.valor_pago_adiantado, " &
                                     "e.teve_desconto_fidelidade, e.status " &
                                     "FROM emprestimos e " &
                                     "INNER JOIN leitores l ON e.idleitor = l.idleitor " &
                                     "INNER JOIN livros b ON e.idlivro = b.idlivro " &
                                     "ORDER BY e.idemprestimo DESC"
                Dim da As New MySqlDataAdapter(sql, conn)
                da.Fill(dt)
            End Using
            Return dt
        End Function

        ' Buscar por ID para Modais
        Public Function ObterPorId(idEmprestimo As Integer) As Emprestimo
            Dim emp As Emprestimo = Nothing
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Dim sql As String = "SELECT e.*, l.nome AS nome_leitor, b.titulo AS titulo_livro, b.preco_emprestimo_dia, b.valor_compra " &
                                     "FROM emprestimos e " &
                                     "INNER JOIN leitores l ON e.idleitor = l.idleitor " &
                                     "INNER JOIN livros b ON e.idlivro = b.idlivro " &
                                     "WHERE e.idemprestimo = @id"
                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@id", idEmprestimo)
                conn.Open()
                Using dr As MySqlDataReader = cmd.ExecuteReader()
                    If dr.Read() Then
                        emp = New Emprestimo With {
                            .idEmprestimo = Convert.ToInt32(dr("idemprestimo")),
                            .IdLeitor = Convert.ToInt32(dr("idleitor")),
                            .NomeLeitor = dr("nome_leitor").ToString(),
                            .IdLivro = Convert.ToInt32(dr("idlivro")),
                            .TituloLivro = dr("titulo_livro").ToString(),
                            .DataEmprestimo = Convert.ToDateTime(dr("data_emprestimo")),
                            .DataPrevistaDevolucao = Convert.ToDateTime(dr("data_prevista_devolucao")),
                            .PrecoDiarioAplicado = Convert.ToDecimal(dr("preco_diario_aplicado")),
                            .ValorCompraLivro = Convert.ToDecimal(dr("valor_compra")),
                            .ValorTotalAluguel = Convert.ToDecimal(dr("valor_total_aluguel")),
                            .ValorPagoAdiantado = Convert.ToDecimal(dr("valor_pago_adiantado")),
                            .ValorSaldoAluguel = Convert.ToDecimal(dr("valor_saldo_aluguel")),
                            .TeveDescontoFidelidade = Convert.ToBoolean(dr("teve_desconto_fidelidade")),
                            .Status = dr("status").ToString()
                        }
                    End If
                End Using
            End Using
            Return emp
        End Function
    End Class
End Namespace