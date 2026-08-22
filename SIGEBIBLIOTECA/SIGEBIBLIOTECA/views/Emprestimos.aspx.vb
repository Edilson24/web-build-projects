Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.DAO
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA.views
    Partial Class Emprestimos
        Inherits System.Web.UI.Page

        Private daoEmprestimo As New EmprestimoDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                CarregarGrid()
            End If
        End Sub

        Private Sub CarregarGrid()
            gvEmprestimos.DataSource = daoEmprestimo.ListarTodos()
            gvEmprestimos.DataBind()
        End Sub

        Protected Sub gvEmprestimos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
            Dim idEmprestimo As Integer = Convert.ToInt32(e.CommandArgument)
            Dim emp As Emprestimo = daoEmprestimo.ObterPorId(idEmprestimo)

            If emp IsNot Nothing Then
                If e.CommandName = "Visualizar" Then
                    lblDetLeitor.Text = emp.NomeLeitor
                    lblDetLivro.Text = emp.TituloLivro
                    lblDetDataEmp.Text = emp.DataEmprestimo.ToString("dd/MM/yyyy HH:mm")
                    lblDetDataPrev.Text = emp.DataPrevistaDevolucao.ToString("dd/MM/yyyy")
                    lblDetAdiantado.Text = emp.ValorPagoAdiantado.ToString("N2") & " MT"
                    lblDetSaldo.Text = emp.ValorSaldoAluguel.ToString("N2") & " MT"

                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ModalDet", "abrirModal('modalDetalhes');", True)

                ElseIf e.CommandName = "Devolver" Then
                    hfIdEmprestimoDev.Value = emp.IdEmprestimo.ToString()
                    hfDataEmprestimoDev.Value = emp.DataEmprestimo.ToString("yyyy-MM-dd")
                    hfDataPrevistaDev.Value = emp.DataPrevistaDevolucao.ToString("yyyy-MM-dd")
                    hfPrecoDiarioAplicado.Value = emp.PrecoDiarioAplicado.ToString("F2").Replace(",", ".")
                    hfValorCompraLivro.Value = emp.ValorCompraLivro.ToString("F2").Replace(",", ".")
                    hfValorSaldoAluguel.Value = emp.ValorSaldoAluguel.ToString("F2").Replace(",", ".")

                    lblLivroDevolucao.Text = emp.TituloLivro
                    txtDataRealDevolucao.Text = DateTime.Now.ToString("yyyy-MM-dd")
                    houve_dano.Checked = False

                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ModalDev", "abrirModal('modalDevolucao'); calcularDevolucaoJS();", True)
                End If
            End If
        End Sub

        Protected Sub btnConfirmarDevolucao_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim idEmp As Integer = Convert.ToInt32(hfIdEmprestimoDev.Value)
            Dim empOriginal As Emprestimo = daoEmprestimo.ObterPorId(idEmp)

            Dim emp As New Emprestimo With {
                .IdEmprestimo = empOriginal.IdEmprestimo,
                .IdLeitor = empOriginal.IdLeitor,
                .IdLivro = empOriginal.IdLivro,
                .DataRealDevolucao = Convert.ToDateTime(txtDataRealDevolucao.Text & " " & DateTime.Now.ToString("HH:mm:ss")),
                .DiasAtraso = Convert.ToInt32(hfDiasAtraso.Value),
                .ValorMultaAtraso = Convert.ToDecimal(hfValorMultaAtraso.Value.Replace(".", ",")),
                .HouveDano = houve_dano.Checked,
                .ValorMultaDano = Convert.ToDecimal(hfValorMultaDano.Value.Replace(".", ",")),
                .ValorTotalPago = Convert.ToDecimal(hfValorTotalPago.Value.Replace(".", ",")),
                .IdUsuarioDevolucao = Convert.ToInt32(Session("idusuario") Or 1)
            }

            If daoEmprestimo.RegistrarDevolucao(emp) Then
                lblMensagemAlerta.Text = "Devolução registrada e encerrada com sucesso!"
                pnlAlerta.CssClass = "alert alert-success alert-dismissible fade show"
                pnlAlerta.Visible = True
                CarregarGrid()
            Else
                lblMensagemAlerta.Text = "Erro ao registar a devolução no banco de dados."
                pnlAlerta.CssClass = "alert alert-danger alert-dismissible fade show"
                pnlAlerta.Visible = True
            End If
        End Sub
    End Class
End Namespace