Imports System
Imports System.Collections.Generic
Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.DAO
    Public Class EmprestimoDAO

        Public Function ListarTodos() As List(Of Emprestimo)
            Dim lista As New List(Of Emprestimo)()
            Dim sql As String = "SELECT e.*, l.titulo AS TituloLivro, lei.nome AS NomeLeitor, " &
                               "u1.nome AS NomeUsuarioEmprestimo, u2.nome AS NomeUsuarioDevolucao " &
                               "FROM emprestimos e " &
                               "INNER JOIN livros l ON e.idlivro = l.idlivro " &
                               "INNER JOIN leitores lei ON e.idleitor = lei.idleitor " &
                               "INNER JOIN usuarios u1 ON e.idusuario_emprestimo = u1.idusuario " &
                               "LEFT JOIN usuarios u2 ON e.idusuario_devolucao = u2.idusuario " &
                               "ORDER BY e.idemprestimo DESC"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    conn.Open()
                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim item As New Emprestimo() With {
                                .IdEmprestimo = Convert.ToInt32(reader("idemprestimo")),
                                .IdLivro = Convert.ToInt32(reader("idlivro")),
                                .IdLeitor = Convert.ToInt32(reader("idleitor")),
                                .IdUsuarioEmprestimo = Convert.ToInt32(reader("idusuario_emprestimo")),
                                .DataEmprestimo = Convert.ToDateTime(reader("data_emprestimo")),
                                .DataPrevistaDevolucao = Convert.ToDateTime(reader("data_prevista_devolucao")),
                                .DiasPrevistos = Convert.ToInt32(reader("dias_previstos")),
                                .PrecoDiarioAplicado = Convert.ToDecimal(reader("preco_diario_aplicado")),
                                .TeveDescontoFidelidade = Convert.ToBoolean(reader("teve_desconto_fidelidade")),
                                .ValorTotalAluguel = Convert.ToDecimal(reader("valor_total_aluguel")),
                                .ValorPagoAdiantado = Convert.ToDecimal(reader("valor_pago_adiantado")),
                                .ValorSaldoAluguel = Convert.ToDecimal(reader("valor_saldo_aluguel")),
                                .ValorMultaAtraso = Convert.ToDecimal(reader("valor_multa_atraso")),
                                .HouveDano = Convert.ToBoolean(reader("houve_dano")),
                                .ValorMultaDano = Convert.ToDecimal(reader("valor_multa_dano")),
                                .Status = reader("status").ToString(),
                                .TituloLivro = reader("TituloLivro").ToString(),
                                .NomeLeitor = reader("NomeLeitor").ToString(),
                                .NomeUsuarioEmprestimo = reader("NomeUsuarioEmprestimo").ToString()
                            }

                            If Not IsDBNull(reader("idusuario_devolucao")) Then
                                item.IdUsuarioDevolucao = Convert.ToInt32(reader("idusuario_devolucao"))
                            End If
                            If Not IsDBNull(reader("data_real_devolucao")) Then
                                item.DataRealDevolucao = Convert.ToDateTime(reader("data_real_devolucao"))
                            End If
                            If Not IsDBNull(reader("valor_total_pago")) Then
                                item.ValorTotalPago = Convert.ToDecimal(reader("valor_total_pago"))
                            End If
                            If Not IsDBNull(reader("NomeUsuarioDevolucao")) Then
                                item.NomeUsuarioDevolucao = reader("NomeUsuarioDevolucao").ToString()
                            End If

                            lista.Add(item)
                        End While
                    End Using
                End Using
            End Using
            Return lista
        End Function

        Public Function ObterPorId(id As Integer) As Emprestimo
            Dim item As Emprestimo = Nothing
            Dim sql As String = "SELECT e.*, l.titulo AS TituloLivro, lei.nome AS NomeLeitor " &
                               "FROM emprestimos e " &
                               "INNER JOIN livros l ON e.idlivro = l.idlivro " &
                               "INNER JOIN leitores lei ON e.idleitor = lei.idleitor " &
                               "WHERE e.idemprestimo = @id"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            item = New Emprestimo() With {
                                .IdEmprestimo = Convert.ToInt32(reader("idemprestimo")),
                                .IdLivro = Convert.ToInt32(reader("idlivro")),
                                .IdLeitor = Convert.ToInt32(reader("idleitor")),
                                .DataEmprestimo = Convert.ToDateTime(reader("data_emprestimo")),
                                .DataPrevistaDevolucao = Convert.ToDateTime(reader("data_prevista_devolucao")),
                                .DiasPrevistos = Convert.ToInt32(reader("dias_previstos")),
                                .PrecoDiarioAplicado = Convert.ToDecimal(reader("preco_diario_aplicado")),
                                .ValorTotalAluguel = Convert.ToDecimal(reader("valor_total_aluguel")),
                                .ValorPagoAdiantado = Convert.ToDecimal(reader("valor_pago_adiantado")),
                                .ValorSaldoAluguel = Convert.ToDecimal(reader("valor_saldo_aluguel")),
                                .Status = reader("status").ToString(),
                                .TituloLivro = reader("TituloLivro").ToString(),
                                .NomeLeitor = reader("NomeLeitor").ToString()
                            }
                        End If
                    End Using
                End Using
            End Using
            Return item
        End Function

        Public Function ObterEmprestimosAtivosPorLeitor(idLeitor As Integer) As Integer
            Dim sql As String = "SELECT COUNT(*) FROM emprestimos WHERE idleitor = @idleitor AND status = 'em_andamento'"
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@idleitor", idLeitor)
                    conn.Open()
                    Return Convert.ToInt32(cmd.ExecuteScalar())
                End Using
            End Using
        End Function

        Public Function RegistrarRetirada(obj As Emprestimo) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                conn.Open()
                Using trans As MySqlTransaction = conn.BeginTransaction()
                    Try
                        ' 1. Inserir Empréstimo
                        Dim sqlInsert As String = "INSERT INTO emprestimos (idlivro, idleitor, idusuario_emprestimo, data_emprestimo, data_prevista_devolucao, " &
                                                 "dias_previstos, preco_diario_aplicado, teve_desconto_fidelidade, valor_total_aluguel, valor_pago_adiantado, valor_saldo_aluguel, status) " &
                                                 "VALUES (@idlivro, @idleitor, @idusuario_emprestimo, @data_emprestimo, @data_prevista_devolucao, " &
                                                 "@dias_previstos, @preco_diario_aplicado, @teve_desconto_fidelidade, @valor_total_aluguel, @valor_pago_adiantado, @valor_saldo_aluguel, 'em_andamento')"

                        Using cmdInsert As New MySqlCommand(sqlInsert, conn, trans)
                            cmdInsert.Parameters.AddWithValue("@idlivro", obj.IdLivro)
                            cmdInsert.Parameters.AddWithValue("@idleitor", obj.IdLeitor)
                            cmdInsert.Parameters.AddWithValue("@idusuario_emprestimo", obj.IdUsuarioEmprestimo)
                            cmdInsert.Parameters.AddWithValue("@data_emprestimo", obj.DataEmprestimo)
                            cmdInsert.Parameters.AddWithValue("@data_prevista_devolucao", obj.DataPrevistaDevolucao)
                            cmdInsert.Parameters.AddWithValue("@dias_previstos", obj.DiasPrevistos)
                            cmdInsert.Parameters.AddWithValue("@preco_diario_aplicado", obj.PrecoDiarioAplicado)
                            cmdInsert.Parameters.AddWithValue("@teve_desconto_fidelidade", obj.TeveDescontoFidelidade)
                            cmdInsert.Parameters.AddWithValue("@valor_total_aluguel", obj.ValorTotalAluguel)
                            cmdInsert.Parameters.AddWithValue("@valor_pago_adiantado", obj.ValorPagoAdiantado)
                            cmdInsert.Parameters.AddWithValue("@valor_saldo_aluguel", obj.ValorSaldoAluguel)
                            cmdInsert.ExecuteNonQuery()
                        End Using

                        ' 2. Decrementar Estoque
                        Dim sqlStock As String = "UPDATE livros SET qtd_disponivel = qtd_disponivel - 1, " &
                                                "estado = IF(qtd_disponivel - 1 <= 0, 'esgotado', 'disponivel') " &
                                                "WHERE idlivro = @idlivro"
                        Using cmdStock As New MySqlCommand(sqlStock, conn, trans)
                            cmdStock.Parameters.AddWithValue("@idlivro", obj.IdLivro)
                            cmdStock.ExecuteNonQuery()
                        End Using

                        trans.Commit()
                        Return True
                    Catch
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Function

        Public Function RegistrarDevolucao(obj As Emprestimo) As Boolean
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                conn.Open()
                Using trans As MySqlTransaction = conn.BeginTransaction()
                    Try
                        ' 1. Atualizar Empréstimo
                        Dim sqlUpdate As String = "UPDATE emprestimos SET idusuario_devolucao = @idusuario_devolucao, data_real_devolucao = @data_real_devolucao, " &
                                                 "dias_atraso = @dias_atraso, valor_multa_atraso = @valor_multa_atraso, houve_dano = @houve_dano, " &
                                                 "valor_multa_dano = @valor_multa_dano, valor_total_pago = @valor_total_pago, status = 'devolvido' " &
                                                 "WHERE idemprestimo = @idemprestimo"

                        Using cmdUpdate As New MySqlCommand(sqlUpdate, conn, trans)
                            cmdUpdate.Parameters.AddWithValue("@idusuario_devolucao", obj.IdUsuarioDevolucao)
                            cmdUpdate.Parameters.AddWithValue("@data_real_devolucao", obj.DataRealDevolucao)
                            cmdUpdate.Parameters.AddWithValue("@dias_atraso", obj.DiasAtraso)
                            cmdUpdate.Parameters.AddWithValue("@valor_multa_atraso", obj.ValorMultaAtraso)
                            cmdUpdate.Parameters.AddWithValue("@houve_dano", obj.HouveDano)
                            cmdUpdate.Parameters.AddWithValue("@valor_multa_dano", obj.ValorMultaDano)
                            cmdUpdate.Parameters.AddWithValue("@valor_total_pago", obj.ValorTotalPago)
                            cmdUpdate.Parameters.AddWithValue("@idemprestimo", obj.IdEmprestimo)
                            cmdUpdate.ExecuteNonQuery()
                        End Using

                        ' 2. Repor Estoque (RN 29)
                        Dim sqlStock As String = "UPDATE livros SET qtd_disponivel = qtd_disponivel + 1, estado = 'disponivel' WHERE idlivro = @idlivro"
                        Using cmdStock As New MySqlCommand(sqlStock, conn, trans)
                            cmdStock.Parameters.AddWithValue("@idlivro", obj.IdLivro)
                            cmdStock.ExecuteNonQuery()
                        End Using

                        ' 3. Incrementar Total de Empréstimos Concluídos do Leitor (RN 25)
                        Dim sqlLeitor As String = "UPDATE leitores SET total_emprestimos_concluidos = total_emprestimos_concluidos + 1 WHERE idleitor = @idleitor"
                        Using cmdLeitor As New MySqlCommand(sqlLeitor, conn, trans)
                            cmdLeitor.Parameters.AddWithValue("@idleitor", obj.IdLeitor)
                            cmdLeitor.ExecuteNonQuery()
                        End Using

                        trans.Commit()
                        Return True
                    Catch
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Function
    End Class
End Namespace