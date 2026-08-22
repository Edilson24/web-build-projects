Imports System
Imports System.Collections.Generic
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.Models
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.DAO
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.Models

Namespace SIGEBIBLIOTECA
    Partial Public Class Emprestimos
        Inherits System.Web.UI.Page

        Private ReadOnly emprestimoDao As New EmprestimoDAO()
        Private ReadOnly livroDao As New LivroDAO()
        Private ReadOnly leitorDao As New LeitorDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Restrição do nível de acesso
            Dim perfil As String = If(Session("UsuarioNivel") IsNot Nothing, Session("UsuarioNivel").ToString().Trim(), "")
            If String.IsNullOrEmpty(perfil) Then
                Response.Redirect("Login.aspx")
            End If

            If Not IsPostBack Then
                CarregarGrid()
            End If
        End Sub

        Private Sub CarregarGrid()
            gvEmprestimos.DataSource = emprestimoDao.ListarTodos()
            gvEmprestimos.DataBind()
        End Sub

        Protected Sub btnNovoEmprestimo_Click(ByVal sender As Object, ByVal e As EventArgs)
            CarregarDropdowns()
            txtDataPrevista.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd")
            pnlModalNovo.Visible = True
            CalcularValoresNovoEmprestimo(Nothing, Nothing)
        End Sub

        Private Sub CarregarDropdowns()
            ddlLeitor.DataSource = leitorDao.ListarAtivos()
            ddlLeitor.DataTextField = "Nome"
            ddlLeitor.DataValueField = "IdLeitor"
            ddlLeitor.DataBind()
            ddlLeitor.Items.Insert(0, New ListItem("-- Selecione o Leitor --", "0"))

            ddlLivro.DataSource = livroDao.ListarDisponiveis()
            ddlLivro.DataTextField = "Titulo"
            ddlLivro.DataValueField = "IdLivro"
            ddlLivro.DataBind()
            ddlLivro.Items.Insert(0, New ListItem("-- Selecione o Livro --", "0"))
        End Sub

        Protected Sub CalcularValoresNovoEmprestimo(ByVal sender As Object, ByVal e As EventArgs)
            lblDescontoFidelidade.Visible = False

            If ddlLeitor.SelectedValue = "0" OrElse ddlLivro.SelectedValue = "0" OrElse String.IsNullOrEmpty(txtDataPrevista.Text) Then
                Exit Sub
            End If

            Dim idLeitor As Integer = Convert.ToInt32(ddlLeitor.SelectedValue)
            Dim idLivro As Integer = Convert.ToInt32(ddlLivro.SelectedValue)
            Dim dataPrevista As DateTime = Convert.ToDateTime(txtDataPrevista.Text)
            Dim dataHoje As DateTime = DateTime.Now.Date

            Dim dias As Integer = CInt((dataPrevista - dataHoje).TotalDays)
            If dias <= 0 Then dias = 1
            txtDiasPrevistos.Text = dias.ToString()

            Dim livroObj = livroDao.ObterPorId(idLivro)
            Dim leitorObj = leitorDao.ObterPorId(idLeitor)

            Dim precoDiario As Decimal = livroObj.PrecoEmprestimoDia

            ' RN 25: Desconto Fidelidade no 5º ou 10º empréstimo concluído
            If leitorObj.TotalEmprestimosConcluidos = 4 OrElse leitorObj.TotalEmprestimosConcluidos = 9 Then
                precoDiario = precoDiario * 0.9D
                lblDescontoFidelidade.Visible = True
            End If

            txtPrecoDia.Text = precoDiario.ToString("N2")

            Dim totalEstimado As Decimal = dias * precoDiario
            txtValorTotalEstimado.Text = totalEstimado.ToString("N2")

            ' RN 24: Pagamento Adiantado 70%
            Dim adiantamento As Decimal = totalEstimado * 0.7D
            txtValor70.Text = adiantamento.ToString("N2")
        End Sub

        Protected Sub btnSalvarEmprestimo_Click(ByVal sender As Object, ByVal e As EventArgs)
            Try
                Dim idLeitor As Integer = Convert.ToInt32(ddlLeitor.SelectedValue)
                Dim idLivro As Integer = Convert.ToInt32(ddlLivro.SelectedValue)

                ' RN 26: Limite de 2 empréstimos simultâneos
                If emprestimoDao.ObterEmprestimosAtivosPorLeitor(idLeitor) >= 2 Then
                    ExibirMensagem("O leitor já possui 2 empréstimos ativos! Devolução é obrigatória para nova retirada.", False)
                    Exit Sub
                End If

                Dim livroObj = livroDao.ObterPorId(idLivro)
                If livroObj.QtdDisponivel <= 0 Then
                    ExibirMensagem("Livro indisponível/esgotado no estoque.", False)
                    Exit Sub
                End If

                Dim leitorObj = leitorDao.ObterPorId(idLeitor)
                Dim dias As Integer = Convert.ToInt32(txtDiasPrevistos.Text)
                Dim precoDiario As Decimal = Convert.ToDecimal(txtPrecoDia.Text)
                Dim totalEstimado As Decimal = Convert.ToDecimal(txtValorTotalEstimado.Text)
                Dim adiantamento As Decimal = Convert.ToDecimal(txtValor70.Text)
                Dim saldo30 As Decimal = totalEstimado - adiantamento

                Dim emp As New Emprestimo() With {
                    .idLeitor = idLeitor,
                    .idLivro = idLivro,
                    .IdUsuarioEmprestimo = Convert.ToInt32(Session("UsuarioId")),
                    .DataEmprestimo = DateTime.Now,
                    .DataPrevistaDevolucao = Convert.ToDateTime(txtDataPrevista.Text),
                    .DiasPrevistos = dias,
                    .PrecoDiarioAplicado = precoDiario,
                    .TeveDescontoFidelidade = lblDescontoFidelidade.Visible,
                    .ValorTotalAluguel = totalEstimado,
                    .ValorPagoAdiantado = adiantamento,
                    .ValorSaldoAluguel = saldo30
                }

                If emprestimoDao.RegistrarRetirada(emp) Then
                    ExibirMensagem("Empréstimo registrado com sucesso!", True)
                    FecharModais(Nothing, Nothing)
                    CarregarGrid()
                End If
            Catch ex As Exception
                ExibirMensagem("Erro ao registrar empréstimo: " & ex.Message, False)
            End Try
        End Sub

        Protected Sub gvEmprestimos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs) Handles gvEmprestimos.RowCommand
            Dim idEmprestimo As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "Devolucao" Then
                Dim emp = emprestimoDao.ObterPorId(idEmprestimo)
                hfIdEmprestimoDevolucao.Value = emp.IdEmprestimo.ToString()
                lblDevLivro.Text = emp.TituloLivro
                lblDevLeitor.Text = emp.NomeLeitor
                txtDataRealDevolucao.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm")
                txtSaldo30.Text = emp.ValorSaldoAluguel.ToString("N2")
                chkHouveDano.Checked = False

                pnlModalDevolucao.Visible = True
                CalcularValoresDevolucao(Nothing, Nothing)

            ElseIf e.CommandName = "Detalhes" Then
                Dim emp = emprestimoDao.ObterPorId(idEmprestimo)
                litDetalhes.Text = $"<p><strong>Empréstimo ID:</strong> {emp.IdEmprestimo}</p>" &
                                  $"<p><strong>Livro:</strong> {emp.TituloLivro}</p>" &
                                  $"<p><strong>Leitor:</strong> {emp.NomeLeitor}</p>" &
                                  $"<p><strong>Status:</strong> {emp.Status}</p>" &
                                  $"<p><strong>Adiantamento (70%):</strong> {emp.ValorPagoAdiantado:N2} MT</p>" &
                                  $"<p><strong>Saldo Restante (30%):</strong> {emp.ValorSaldoAluguel:N2} MT</p>"
                pnlModalDetalhes.Visible = True
            End If
        End Sub

        Protected Sub CalcularValoresDevolucao(ByVal sender As Object, ByVal e As EventArgs)
            If String.IsNullOrEmpty(hfIdEmprestimoDevolucao.Value) OrElse String.IsNullOrEmpty(txtDataRealDevolucao.Text) Then Exit Sub

            Dim emp = emprestimoDao.ObterPorId(Convert.ToInt32(hfIdEmprestimoDevolucao.Value))
            Dim dataReal As DateTime = Convert.ToDateTime(txtDataRealDevolucao.Text)

            ' Trava: Data real não pode ser menor que empréstimo
            If dataReal < emp.DataEmprestimo Then
                txtDataRealDevolucao.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm")
                dataReal = DateTime.Now
            End If

            ' RN 28: Cálculo de Atraso (50% do valor diário por dia de atraso)
            Dim diasAtraso As Integer = 0
            Dim multaAtraso As Decimal = 0

            If dataReal.Date > emp.DataPrevistaDevolucao.Date Then
                diasAtraso = CInt((dataReal.Date - emp.DataPrevistaDevolucao.Date).TotalDays)
                multaAtraso = diasAtraso * (0.5D * emp.PrecoDiarioAplicado)
            End If

            txtMultaAtraso.Text = multaAtraso.ToString("N2")

            ' RN 28: Cálculo de Dano (Valor de Compra)
            Dim multaDano As Decimal = 0
            If chkHouveDano.Checked Then
                Dim livroObj = livroDao.ObterPorId(emp.IdLivro)
                multaDano = livroObj.ValorCompra
            End If

            txtMultaDano.Text = multaDano.ToString("N2")

            ' RN 28: Total Liquidado = Saldo 30% + Multa Atraso + Multa Dano
            Dim totalDevolucao As Decimal = emp.ValorSaldoAluguel + multaAtraso + multaDano
            txtTotalDevolucao.Text = totalDevolucao.ToString("N2")
        End Sub

        Protected Sub btnConfirmarDevolucao_Click(ByVal sender As Object, ByVal e As EventArgs)
            Try
                Dim emp = emprestimoDao.ObterPorId(Convert.ToInt32(hfIdEmprestimoDevolucao.Value))
                Dim dataReal As DateTime = Convert.ToDateTime(txtDataRealDevolucao.Text)

                Dim diasAtraso As Integer = 0
                Dim multaAtraso As Decimal = Convert.ToDecimal(txtMultaAtraso.Text)
                If dataReal.Date > emp.DataPrevistaDevolucao.Date Then
                    diasAtraso = CInt((dataReal.Date - emp.DataPrevistaDevolucao.Date).TotalDays)
                End If

                emp.IdUsuarioDevolucao = Convert.ToInt32(Session("UsuarioId"))
                emp.DataRealDevolucao = dataReal
                emp.DiasAtraso = diasAtraso
                emp.ValorMultaAtraso = multaAtraso
                emp.HouveDano = chkHouveDano.Checked
                emp.ValorMultaDano = Convert.ToDecimal(txtMultaDano.Text)
                emp.ValorTotalPago = Convert.ToDecimal(txtTotalDevolucao.Text)

                If emprestimoDao.RegistrarDevolucao(emp) Then
                    ExibirMensagem("Devolucao e liquidação concluídas com sucesso!", True)
                    FecharModais(Nothing, Nothing)
                    CarregarGrid()
                End If
            Catch ex As Exception
                ExibirMensagem("Erro na devolução: " & ex.Message, False)
            End Try
        End Sub

        Protected Sub FecharModais(ByVal sender As Object, ByVal e As EventArgs)
            pnlModalNovo.Visible = False
            pnlModalDevolucao.Visible = False
            pnlModalDetalhes.Visible = False
        End Sub

        Private Sub ExibirMensagem(msg As String, sucesso As Boolean)
            lblMensagem.Text = msg
            pnlMensagem.CssClass = "alert alert-dismissible fade show " & If(sucesso, "alert-success", "alert-danger")
            pnlMensagem.Visible = True
        End Sub
    End Class
End Namespace