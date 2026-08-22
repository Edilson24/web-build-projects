Imports MySql.Data.MySqlClient

Public Class Usuario
    Public Property Id As Integer
    Public Property Nome As String
    Public Property Email As String
    Public Property NivelAcesso As String
    Public Property IdUsuario As Integer
    Public Property Senha As String
    Public Property Perfil As String
    Public Property Ativo As Boolean
End Class

Public Class UsuarioDAO
    Public Function Autenticar(email As String, senha As String) As Usuario
        Dim usuarioLogado As Usuario = Nothing


        ' Comparação direta no banco sem necessidade de funções de criptografia
        Dim query As String = "SELECT idusuario, nome, email, perfil FROM usuarios WHERE email = @Email AND senha = @Senha AND ativo = 1 LIMIT 1;"

        Using conn As MySqlConnection = DatabaseHelper.GetConnection()
            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Senha", senha)

                conn.Open()
                Using reader As MySqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        usuarioLogado = New Usuario() With {
                            .Id = Convert.ToInt32(reader("idusuario")),
                            .Nome = reader("nome").ToString(),
                            .Email = reader("email").ToString(),
                            .NivelAcesso = reader("perfil").ToString()
                        }
                    End If
                End Using
            End Using
        End Using

        Return usuarioLogado
    End Function

    ' Listar todos os usuários
    Public Function ListarTodos() As List(Of Usuario)
        Dim lista As New List(Of Usuario)()
        Using conn As MySqlConnection = DatabaseHelper.GetConnection()
            Dim sql As String = "SELECT idusuario, nome, email, senha, perfil, ativo FROM usuarios ORDER BY nome ASC"
            Dim cmd As New MySqlCommand(sql, conn)
            conn.Open()
            Using dr As MySqlDataReader = cmd.ExecuteReader()
                While dr.Read()
                    lista.Add(New Usuario() With {
                        .IdUsuario = Convert.ToInt32(dr("idusuario")),
                        .Nome = dr("nome").ToString(),
                        .Email = dr("email").ToString(),
                        .Senha = dr("senha").ToString(),
                        .Perfil = dr("perfil").ToString(),
                        .Ativo = Convert.ToBoolean(dr("ativo"))
                    })
                End While
            End Using
        End Using
        Return lista
    End Function

    ' Buscar usuário por ID
    Public Function BuscarPorId(id As Integer) As Usuario
        Dim u As Usuario = Nothing
        Using conn As MySqlConnection = DatabaseHelper.GetConnection()
            Dim sql As String = "SELECT idusuario, nome, email, senha, perfil, ativo FROM usuarios WHERE idusuario = @id"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@id", id)
            conn.Open()
            Using dr As MySqlDataReader = cmd.ExecuteReader()
                If dr.Read() Then
                    u = New Usuario() With {
                        .IdUsuario = Convert.ToInt32(dr("idusuario")),
                        .Nome = dr("nome").ToString(),
                        .Email = dr("email").ToString(),
                        .Senha = dr("senha").ToString(),
                        .Perfil = dr("perfil").ToString(),
                        .Ativo = Convert.ToBoolean(dr("ativo"))
                    }
                End If
            End Using
        End Using
        Return u
    End Function

    ' Inserir novo usuário
    Public Function Inserir(u As Usuario) As Boolean
        Using conn As MySqlConnection = DatabaseHelper.GetConnection()
            Dim sql As String = "INSERT INTO usuarios (nome, email, senha, perfil, ativo) VALUES (@nome, @email, @senha, @perfil, 1)"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@nome", u.Nome)
            cmd.Parameters.AddWithValue("@email", u.Email)
            cmd.Parameters.AddWithValue("@senha", u.Senha)
            cmd.Parameters.AddWithValue("@perfil", u.Perfil)
            conn.Open()
            Return cmd.ExecuteNonQuery() > 0
        End Using
    End Function

    ' Atualizar usuário existente
    Public Function Atualizar(u As Usuario) As Boolean
        Using conn As MySqlConnection = DatabaseHelper.GetConnection()
            Dim sql As String = "UPDATE usuarios SET nome = @nome, email = @email, senha = @senha, perfil = @perfil WHERE idusuario = @id"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@nome", u.Nome)
            cmd.Parameters.AddWithValue("@email", u.Email)
            cmd.Parameters.AddWithValue("@senha", u.Senha)
            cmd.Parameters.AddWithValue("@perfil", u.Perfil)
            cmd.Parameters.AddWithValue("@id", u.IdUsuario)
            conn.Open()
            Return cmd.ExecuteNonQuery() > 0
        End Using
    End Function

    ' Alternar status Ativo/Inativo
    Public Function AlternarStatus(id As Integer) As Boolean
        Using conn As MySqlConnection = DatabaseHelper.GetConnection()
            Dim sql As String = "UPDATE usuarios SET ativo = NOT ativo WHERE idusuario = @id"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@id", id)
            conn.Open()
            Return cmd.ExecuteNonQuery() > 0
        End Using
    End Function


End Class