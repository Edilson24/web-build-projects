Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.DAO
    Public Class LeitorDAO

        Public Function ListarTodos() As List(Of Leitor)
            Dim lista As New List(Of Leitor)()
            Dim sql As String = "SELECT idleitor, nome, endereco, telefone, tipo_leitor, curso, turma, total_emprestimos_concluidos, ativo FROM leitores ORDER BY nome ASC"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    conn.Open()
                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim obj As New Leitor() With {
                                .IdLeitor = Convert.ToInt32(reader("idleitor")),
                                .Nome = reader("nome").ToString(),
                                .Endereco = If(IsDBNull(reader("endereco")), "", reader("endereco").ToString()),
                                .Telefone = reader("telefone").ToString(),
                                .TipoLeitor = reader("tipo_leitor").ToString(),
                                .Curso = If(IsDBNull(reader("curso")), "", reader("curso").ToString()),
                                .Turma = If(IsDBNull(reader("turma")), "", reader("turma").ToString()),
                                .TotalEmprestimosConcluidos = Convert.ToInt32(reader("total_emprestimos_concluidos")),
                                .Ativo = Convert.ToBoolean(reader("ativo"))
                            }
                            lista.Add(obj)
                        End While
                    End Using
                End Using
            End Using
            Return lista
        End Function

        Public Function ObterPorId(id As Integer) As Leitor
            Dim obj As Leitor = Nothing
            Dim sql As String = "SELECT idleitor, nome, endereco, telefone, tipo_leitor, curso, turma, total_emprestimos_concluidos, ativo FROM leitores WHERE idleitor = @id"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            obj = New Leitor() With {
                                .IdLeitor = Convert.ToInt32(reader("idleitor")),
                                .Nome = reader("nome").ToString(),
                                .Endereco = If(IsDBNull(reader("endereco")), "", reader("endereco").ToString()),
                                .Telefone = reader("telefone").ToString(),
                                .TipoLeitor = reader("tipo_leitor").ToString(),
                                .Curso = If(IsDBNull(reader("curso")), "", reader("curso").ToString()),
                                .Turma = If(IsDBNull(reader("turma")), "", reader("turma").ToString()),
                                .TotalEmprestimosConcluidos = Convert.ToInt32(reader("total_emprestimos_concluidos")),
                                .Ativo = Convert.ToBoolean(reader("ativo"))
                            }
                        End If
                    End Using
                End Using
            End Using
            Return obj
        End Function

        Public Function Inserir(obj As Leitor) As Boolean
            Dim sql As String = "INSERT INTO leitores (nome, endereco, telefone, tipo_leitor, curso, turma, ativo) " &
                               "VALUES (@nome, @endereco, @telefone, @tipo_leitor, @curso, @turma, @ativo)"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@nome", obj.Nome)
                    cmd.Parameters.AddWithValue("@endereco", If(String.IsNullOrEmpty(obj.Endereco), DBNull.Value, CObj(obj.Endereco)))
                    cmd.Parameters.AddWithValue("@telefone", obj.Telefone)
                    cmd.Parameters.AddWithValue("@tipo_leitor", obj.TipoLeitor)
                    cmd.Parameters.AddWithValue("@curso", If(String.IsNullOrEmpty(obj.Curso), DBNull.Value, CObj(obj.Curso)))
                    cmd.Parameters.AddWithValue("@turma", If(String.IsNullOrEmpty(obj.Turma), DBNull.Value, CObj(obj.Turma)))
                    cmd.Parameters.AddWithValue("@ativo", obj.Ativo)

                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function

        Public Function Atualizar(obj As Leitor) As Boolean
            Dim sql As String = "UPDATE leitores SET nome = @nome, endereco = @endereco, telefone = @telefone, " &
                               "tipo_leitor = @tipo_leitor, curso = @curso, turma = @turma, ativo = @ativo " &
                               "WHERE idleitor = @idleitor"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@idleitor", obj.IdLeitor)
                    cmd.Parameters.AddWithValue("@nome", obj.Nome)
                    cmd.Parameters.AddWithValue("@endereco", If(String.IsNullOrEmpty(obj.Endereco), DBNull.Value, CObj(obj.Endereco)))
                    cmd.Parameters.AddWithValue("@telefone", obj.Telefone)
                    cmd.Parameters.AddWithValue("@tipo_leitor", obj.TipoLeitor)
                    cmd.Parameters.AddWithValue("@curso", If(String.IsNullOrEmpty(obj.Curso), DBNull.Value, CObj(obj.Curso)))
                    cmd.Parameters.AddWithValue("@turma", If(String.IsNullOrEmpty(obj.Turma), DBNull.Value, CObj(obj.Turma)))
                    cmd.Parameters.AddWithValue("@ativo", obj.Ativo)

                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function

        ''' <summary>
        ''' Trava RN 18: Verifica se o leitor possui empréstimos ativos antes de permitir alteração de status/exclusão.
        ''' </summary>
        Public Function PossuiEmprestimosAtivos(idLeitor As Integer) As Boolean
            Dim sql As String = "SELECT COUNT(*) FROM emprestimos WHERE idleitor = @idleitor AND status = 'em_andamento'"
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@idleitor", idLeitor)
                    conn.Open()
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    Return count > 0
                End Using
            End Using
        End Function

        Public Function AlterarStatus(idLeitor As Integer, novoStatus As Boolean) As Boolean
            Dim sql As String = "UPDATE leitores SET ativo = @ativo WHERE idleitor = @idleitor"
            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@idleitor", idLeitor)
                    cmd.Parameters.AddWithValue("@ativo", novoStatus)
                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function
    End Class
End Namespace