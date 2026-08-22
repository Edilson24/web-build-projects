Imports MySql.Data.MySqlClient

Public Class Usuario
    Public Property Id As Integer
    Public Property Nome As String
    Public Property Email As String
    Public Property NivelAcesso As String
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
End Class