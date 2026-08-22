Imports MySql.Data.MySqlClient
Imports System.Configuration

Public Class DatabaseHelper
    Private Shared ReadOnly ConnectionString As String = ConfigurationManager.ConnectionStrings("SigebibliotecasConn").ConnectionString

    Public Shared Function GetConnection() As MySqlConnection
        Return New MySqlConnection(ConnectionString)
    End Function
End Class