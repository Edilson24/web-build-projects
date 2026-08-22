Imports System.Collections.Generic
Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Helpers
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.dao
    Public Class LivroDAO
        Public Function ListarTodos() As List(Of Livro)
            Dim lista As New List(Of Livro)()
            Dim sql As String = "SELECT l.*, c.nome AS NomeCategoria " &
                               "FROM livros l " &
                               "INNER JOIN categorias c ON l.idcategoria = c.idcategoria " &
                               "ORDER BY l.titulo ASC"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    conn.Open()
                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim item As New Livro() With {
                                .IdLivro = Convert.ToInt32(reader("idlivro")),
                                .IdCategoria = Convert.ToInt32(reader("idcategoria")),
                                .NomeCategoria = reader("NomeCategoria").ToString(),
                                .Titulo = reader("titulo").ToString(),
                                .Autor = reader("autor").ToString(),
                                .Editora = reader("editora").ToString(),
                                .Edicao = If(IsDBNull(reader("edicao")), "", reader("edicao").ToString()),
                                .AnoPublicacao = If(IsDBNull(reader("ano_publicacao")), CType(Nothing, Nullable(Of Integer)), Convert.ToInt32(reader("ano_publicacao"))),
                                .PrecoEmprestimoDia = Convert.ToDecimal(reader("preco_emprestimo_dia")),
                                .ValorCompra = Convert.ToDecimal(reader("valor_compra")),
                                .QtdTotal = Convert.ToInt32(reader("qtd_total")),
                                .QtdDisponivel = Convert.ToInt32(reader("qtd_disponivel")),
                                .Estado = reader("estado").ToString()
                            }
                            lista.Add(item)
                        End While
                    End Using
                End Using
            End Using
            Return lista
        End Function

        Public Function ObterPorId(id As Integer) As Livro
            Dim item As Livro = Nothing
            Dim sql As String = "SELECT * FROM livros WHERE idlivro = @id"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            item = New Livro() With {
                                .IdLivro = Convert.ToInt32(reader("idlivro")),
                                .IdCategoria = Convert.ToInt32(reader("idcategoria")),
                                .Titulo = reader("titulo").ToString(),
                                .Autor = reader("autor").ToString(),
                                .Editora = reader("editora").ToString(),
                                .Edicao = If(IsDBNull(reader("edicao")), "", reader("edicao").ToString()),
                                .AnoPublicacao = If(IsDBNull(reader("ano_publicacao")), CType(Nothing, Nullable(Of Integer)), Convert.ToInt32(reader("ano_publicacao"))),
                                .PrecoEmprestimoDia = Convert.ToDecimal(reader("preco_emprestimo_dia")),
                                .ValorCompra = Convert.ToDecimal(reader("valor_compra")),
                                .QtdTotal = Convert.ToInt32(reader("qtd_total")),
                                .QtdDisponivel = Convert.ToInt32(reader("qtd_disponivel")),
                                .Estado = reader("estado").ToString()
                            }
                        End If
                    End Using
                End Using
            End Using
            Return item
        End Function

        Public Function Inserir(obj As Livro) As Boolean
            Dim sql As String = "INSERT INTO livros (idcategoria, titulo, autor, editora, edicao, ano_publicacao, preco_emprestimo_dia, valor_compra, qtd_total, qtd_disponivel, estado) " &
                               "VALUES (@idcategoria, @titulo, @autor, @editora, @edicao, @ano_publicacao, @preco_emprestimo_dia, @valor_compra, @qtd_total, @qtd_disponivel, @estado)"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@idcategoria", obj.IdCategoria)
                    cmd.Parameters.AddWithValue("@titulo", obj.Titulo)
                    cmd.Parameters.AddWithValue("@autor", obj.Autor)
                    cmd.Parameters.AddWithValue("@editora", obj.Editora)
                    cmd.Parameters.AddWithValue("@edicao", If(String.IsNullOrEmpty(obj.Edicao), DBNull.Value, CObj(obj.Edicao)))
                    cmd.Parameters.AddWithValue("@ano_publicacao", If(obj.AnoPublicacao.HasValue, CObj(obj.AnoPublicacao.Value), DBNull.Value))
                    cmd.Parameters.AddWithValue("@preco_emprestimo_dia", obj.PrecoEmprestimoDia)
                    cmd.Parameters.AddWithValue("@valor_compra", obj.ValorCompra)
                    cmd.Parameters.AddWithValue("@qtd_total", obj.QtdTotal)
                    cmd.Parameters.AddWithValue("@qtd_disponivel", obj.QtdDisponivel)
                    cmd.Parameters.AddWithValue("@estado", obj.Estado)

                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function

        Public Function Atualizar(obj As Livro) As Boolean
            Dim sql As String = "UPDATE livros SET idcategoria = @idcategoria, titulo = @titulo, autor = @autor, " &
                               "editora = @editora, edicao = @edicao, ano_publicacao = @ano_publicacao, " &
                               "preco_emprestimo_dia = @preco_emprestimo_dia, valor_compra = @valor_compra, " &
                               "qtd_total = @qtd_total, qtd_disponivel = @qtd_disponivel, estado = @estado " &
                               "WHERE idlivro = @idlivro"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@idlivro", obj.IdLivro)
                    cmd.Parameters.AddWithValue("@idcategoria", obj.IdCategoria)
                    cmd.Parameters.AddWithValue("@titulo", obj.Titulo)
                    cmd.Parameters.AddWithValue("@autor", obj.Autor)
                    cmd.Parameters.AddWithValue("@editora", obj.Editora)
                    cmd.Parameters.AddWithValue("@edicao", If(String.IsNullOrEmpty(obj.Edicao), DBNull.Value, CObj(obj.Edicao)))
                    cmd.Parameters.AddWithValue("@ano_publicacao", If(obj.AnoPublicacao.HasValue, CObj(obj.AnoPublicacao.Value), DBNull.Value))
                    cmd.Parameters.AddWithValue("@preco_emprestimo_dia", obj.PrecoEmprestimoDia)
                    cmd.Parameters.AddWithValue("@valor_compra", obj.ValorCompra)
                    cmd.Parameters.AddWithValue("@qtd_total", obj.QtdTotal)
                    cmd.Parameters.AddWithValue("@qtd_disponivel", obj.QtdDisponivel)
                    cmd.Parameters.AddWithValue("@estado", obj.Estado)

                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function

        Public Function Excluir(id As Integer) As Boolean
            Dim sql As String = "DELETE FROM livros WHERE idlivro = @id"

            Using conn As MySqlConnection = DatabaseHelper.GetConnection()
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function
    End Class
End Namespace