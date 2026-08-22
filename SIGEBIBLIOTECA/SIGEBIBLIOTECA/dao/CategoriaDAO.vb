Imports System
Imports System.Collections.Generic
Imports System.Configuration
Imports MySql.Data.MySqlClient
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.dao
    Public Class CategoriaDAO
        Private ReadOnly connectionString As String = ConfigurationManager.ConnectionStrings("SigebibliotecasConn").ConnectionString

        Public Function ListarTodas() As List(Of Categoria)
            Dim lista As New List(Of Categoria)()
            Using conn As New MySqlConnection(connectionString)
                Dim sql As String = "SELECT idcategoria, nome, descricao FROM categorias ORDER BY nome ASC"
                Using cmd As New MySqlCommand(sql, conn)
                    conn.Open()
                    Using dr As MySqlDataReader = cmd.ExecuteReader()
                        While dr.Read()
                            Dim c As New Categoria() With {
                                .IdCategoria = Convert.ToInt32(dr("idcategoria")),
                                .Nome = dr("nome").ToString(),
                                .Descricao = If(dr("descricao") Is DBNull.Value, "", dr("descricao").ToString())
                            }
                            lista.Add(c)
                        End While
                    End Using
                End Using
            End Using
            Return lista
        End Function

        Public Function ObterPorId(ByVal id As Integer) As Categoria
            Dim c As Categoria = Nothing
            Using conn As New MySqlConnection(connectionString)
                Dim sql As String = "SELECT idcategoria, nome, descricao FROM categorias WHERE idcategoria = @id"
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    Using dr As MySqlDataReader = cmd.ExecuteReader()
                        If dr.Read() Then
                            c = New Categoria() With {
                                .IdCategoria = Convert.ToInt32(dr("idcategoria")),
                                .Nome = dr("nome").ToString(),
                                .Descricao = If(dr("descricao") Is DBNull.Value, "", dr("descricao").ToString())
                            }
                        End If
                    End Using
                End Using
            End Using
            Return c
        End Function

        Public Function Inserir(ByVal cat As Categoria) As Boolean
            Using conn As New MySqlConnection(connectionString)
                Dim sql As String = "INSERT INTO categorias (nome, descricao) VALUES (@nome, @descricao)"
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@nome", cat.Nome)
                    cmd.Parameters.AddWithValue("@descricao", If(String.IsNullOrEmpty(cat.Descricao), DBNull.Value, CObj(cat.Descricao)))
                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function

        Public Function Atualizar(ByVal cat As Categoria) As Boolean
            Using conn As New MySqlConnection(connectionString)
                Dim sql As String = "UPDATE categorias SET nome = @nome, descricao = @descricao WHERE idcategoria = @id"
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@nome", cat.Nome)
                    cmd.Parameters.AddWithValue("@descricao", If(String.IsNullOrEmpty(cat.Descricao), DBNull.Value, CObj(cat.Descricao)))
                    cmd.Parameters.AddWithValue("@id", cat.IdCategoria)
                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function

        Public Function Excluir(ByVal id As Integer) As Boolean
            Using conn As New MySqlConnection(connectionString)
                Dim sql As String = "DELETE FROM categorias WHERE idcategoria = @id"
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", id)
                    conn.Open()
                    Return cmd.ExecuteNonQuery() > 0
                End Using
            End Using
        End Function
    End Class
End Namespace