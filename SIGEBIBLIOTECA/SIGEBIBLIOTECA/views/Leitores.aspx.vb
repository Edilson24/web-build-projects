Imports SIGEBIBLIOTECA.DAO
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.DAO
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA
    Partial Public Class Leitores
        Inherits System.Web.UI.Page

        Private dao As New LeitorDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CarregarGrid()
            End If
        End Sub

        Private Sub CarregarGrid()
            gvLeitores.DataSource = dao.ListarTodos()
            gvLeitores.DataBind()
        End Sub

        Protected Function ObterCssBadgeTipo(tipo As String) As String
            Select Case tipo.ToLower()
                Case "estudante"
                    Return "badge-estudante"
                Case "docente"
                    Return "badge-docente"
                Case Else
                    Return "badge-externo"
            End Select
        End Function

        Protected Sub btnNovoLeitor_Click(ByVal sender As Object, ByVal e As EventArgs)
            LimparFormulario()
            litTituloModal.Text = "Cadastrar Leitor"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
        End Sub

        Protected Sub ddlTipoLeitor_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
            pnlAcademico.Visible = (ddlTipoLeitor.SelectedValue <> "externo")
        End Sub

        Protected Sub btnSalvar_Click(ByVal sender As Object, ByVal e As EventArgs)
            Try
                Dim id As Integer = Convert.ToInt32(hfIdLeitor.Value)
                Dim leitorObj As New Leitor() With {
                    .IdLeitor = id,
                    .Nome = txtNome.Text.Trim(),
                    .Telefone = txtTelefone.Text.Trim(),
                    .Endereco = txtEndereco.Text.Trim(),
                    .TipoLeitor = ddlTipoLeitor.SelectedValue,
                    .Curso = If(ddlTipoLeitor.SelectedValue <> "externo", txtCurso.Text.Trim(), ""),
                    .Turma = If(ddlTipoLeitor.SelectedValue <> "externo", txtTurma.Text.Trim(), ""),
                    .Ativo = True
                }

                If String.IsNullOrEmpty(leitorObj.Nome) OrElse String.IsNullOrEmpty(leitorObj.Telefone) Then
                    ExibirAlerta("Preencha todos os campos obrigatórios (*).", "danger")
                    Return
                End If

                Dim sucesso As Boolean
                If id = 0 Then
                    sucesso = dao.Inserir(leitorObj)
                Else
                    sucesso = dao.Atualizar(leitorObj)
                End If

                If sucesso Then
                    ExibirAlerta("Leitor salvo com sucesso!", "success")
                    CarregarGrid()
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideModal", "fecharModal();", True)
                Else
                    ExibirAlerta("Erro ao salvar o leitor.", "danger")
                End If
            Catch ex As Exception
                ExibirAlerta("Erro interno: " & ex.Message, "danger")
            End Try
        End Sub

        Protected Sub gvLeitores_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            Dim idLeitor As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Editar" Then
                Dim obj = dao.ObterPorId(idLeitor)
                If obj IsNot Nothing Then
                    hfIdLeitor.Value = obj.IdLeitor.ToString()
                    txtNome.Text = obj.Nome
                    txtTelefone.Text = obj.Telefone
                    txtEndereco.Text = obj.Endereco
                    ddlTipoLeitor.SelectedValue = obj.TipoLeitor
                    txtCurso.Text = obj.Curso
                    txtTurma.Text = obj.Turma
                    pnlAcademico.Visible = (obj.TipoLeitor <> "externo")

                    litTituloModal.Text = "Editar Leitor"
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "PopModal", "abrirModal();", True)
                End If

            ElseIf e.CommandName = "ToggleStatus" Then
                ' Aplicação da RN 18: Verificar se tem empréstimo em andamento
                Dim leitorAtual = dao.ObterPorId(idLeitor)
                If leitorAtual IsNot Nothing Then
                    ' Se for desativar, verifica pendências
                    If leitorAtual.Ativo AndAlso dao.PossuiEmprestimosAtivos(idLeitor) Then
                        ExibirAlerta("<strong>Bloqueio de Segurança (RN 18):</strong> O leitor possui empréstimos em andamento e não pode ser desativado até a devolução do livro.", "warning")
                        Return
                    End If

                    Dim novoStatus As Boolean = Not leitorAtual.Ativo
                    If dao.AlterarStatus(idLeitor, novoStatus) Then
                        ExibirAlerta("Status do leitor alterado com sucesso!", "success")
                        CarregarGrid()
                    Else
                        ExibirAlerta("Erro ao alterar o status do leitor.", "danger")
                    End If
                End If
            End If
        End Sub

        Private Sub LimparFormulario()
            hfIdLeitor.Value = "0"
            txtNome.Text = String.Empty
            txtTelefone.Text = String.Empty
            txtEndereco.Text = String.Empty
            txtCurso.Text = String.Empty
            txtTurma.Text = String.Empty
            ddlTipoLeitor.SelectedValue = "estudante"
            pnlAcademico.Visible = True
        End Sub

        Private Sub ExibirAlerta(mensagem As String, tipoCss As String)
            pnlAlerta.CssClass = "alert alert-" & tipoCss & " alert-dismissible fade show"
            lblMensagemAlerta.Text = mensagem
            pnlAlerta.Visible = True
        End Sub
    End Class
End Namespace