Imports System
Imports System.Collections.Generic
Imports System.Text
Imports System.Web.UI
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.DAO

Namespace SIGEBIBLIOTECA
    Partial Public Class Dashboard
        Inherits System.Web.UI.Page

        Private ReadOnly dashDao As New DashboardDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            If Session("UsuarioId") Is Nothing Then
                Response.Redirect("~/Login.aspx")
            End If
            If Not IsPostBack Then
                CarregarDadosDashboard()
            End If
        End Sub

        Private Sub CarregarDadosDashboard()
            ' 1. Carrega Estatísticas Gerais dos Cards
            Dim stats = dashDao.ObterEstatisticasGerais()
            litEmprestimosAtivos.Text = stats.EmprestimosAtivos.ToString()
            litDevolucoes.Text = stats.DevolucoesConcluidas.ToString()
            litReceitaTotal.Text = stats.ReceitaTotal.ToString("N2") & " MT"
            litTotalLeitores.Text = stats.TotalLeitores.ToString()

            ' 2. Carrega Tabelas de Destaques
            gvLeitoresFrequentes.DataSource = dashDao.ObterLeitoresFrequentes()
            gvLeitoresFrequentes.DataBind()

            gvLivrosSolicitados.DataSource = dashDao.ObterLivrosMaisSolicitados()
            gvLivrosSolicitados.DataBind()

            ' 3. Monta o Gráfico dinâmico
            RenderizarGrafico(dashDao.ObterEvolucaoReceitaMensal())
        End Sub

        Private Sub RenderizarGrafico(dadosReceita As Dictionary(Of String, Decimal))
            Dim labels As New List(Of String)()
            Dim valores As New List(Of String)()

            If dadosReceita.Count = 0 Then
                ' Dados padrão se não houver registros anteriores
                labels.AddRange(New String() {"Mês Atual"})
                valores.AddRange(New String() {"0"})
            Else
                For Each item In dadosReceita
                    labels.Add("'" & item.Key & "'")
                    valores.Add(item.Value.ToString("F2", System.Globalization.CultureInfo.InvariantCulture))
                Next
            End If

            Dim strLabels As String = String.Join(",", labels)
            Dim strValores As String = String.Join(",", valores)

            ' Injeção do Script do Chart.js com as cores da identidade visual (#4299A3)
            Dim sb As New StringBuilder()
            sb.AppendLine("<script>")
            sb.AppendLine("document.addEventListener('DOMContentLoaded', function () {")
            sb.AppendLine("    var ctx = document.getElementById('chartRenda').getContext('2d');")
            sb.AppendLine("    var chartRenda = new Chart(ctx, {")
            sb.AppendLine("        type: 'line',")
            sb.AppendLine("        data: {")
            sb.AppendLine("            labels: [" & strLabels & "],")
            sb.AppendLine("            datasets: [{")
            sb.AppendLine("                label: 'Receita (MT)',")
            sb.AppendLine("                data: [" & strValores & "],")
            sb.AppendLine("                borderColor: '#4299A3',")
            sb.AppendLine("                backgroundColor: 'rgba(66, 153, 163, 0.15)',")
            sb.AppendLine("                fill: true,")
            sb.AppendLine("                tension: 0.35,")
            sb.AppendLine("                borderWidth: 3")
            sb.AppendLine("            }]")
            sb.AppendLine("        },")
            sb.AppendLine("        options: {")
            sb.AppendLine("            responsive: true,")
            sb.AppendLine("            maintainAspectRatio: false,")
            sb.AppendLine("            plugins: { legend: { display: false } },")
            sb.AppendLine("            scales: { y: { beginAtZero: true } }")
            sb.AppendLine("        }")
            sb.AppendLine("    });")
            sb.AppendLine("});")
            sb.AppendLine("</script>")

            litScriptGrafico.Text = sb.ToString()
        End Sub
    End Class
End Namespace