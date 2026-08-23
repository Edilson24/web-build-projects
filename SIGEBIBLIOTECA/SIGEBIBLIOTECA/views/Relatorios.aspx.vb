Imports System
Imports System.Data
Imports System.IO
Imports System.Web.UI
' Imports do iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports SIGEBIBLIOTECA.dao
Imports SIGEBIBLIOTECA.SIGEBIBLIOTECA.DAO

Namespace SIGEBIBLIOTECA
    Partial Public Class Relatorios
        Inherits System.Web.UI.Page

        Private ReadOnly relDao As New RelatoriosDAO()

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
            ' Controle de Acesso por Sessão
            If Session("UsuarioId") Is Nothing Then
                Response.Redirect("~/Login.aspx")
                Return
            End If

            If Not IsPostBack Then
                ' Define datas padrão (Mês atual)
                txtDataInicio.Text = New DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("yyyy-MM-dd")
                txtDataFim.Text = DateTime.Now.ToString("yyyy-MM-dd")
                CarregarDados()
            End If
        End Sub

        Protected Sub ddlTipoRelatorio_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
            CarregarDados()
        End Sub

        Protected Sub btnFiltrar_Click(ByVal sender As Object, ByVal e As EventArgs)
            CarregarDados()
        End Sub

        Private Sub CarregarDados()
            Dim dt As DataTable = ObterDadosAtuais()
            gvRelatorio.DataSource = dt
            gvRelatorio.DataBind()
            lblTotalRegistros.Text = dt.Rows.Count.ToString()
        End Sub

        Private Function ObterDadosAtuais() As DataTable
            Dim tipo As String = ddlTipoRelatorio.SelectedValue
            Dim dataInicio As String = txtDataInicio.Text
            Dim dataFim As String = txtDataFim.Text
            Dim termo As String = txtTermoBusca.Text.Trim()

            Return relDao.ObterDadosRelatorio(tipo, dataInicio, dataFim, termo)
        End Function

        Protected Sub btnExportarPDF_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim dt As DataTable = ObterDadosAtuais()

            If dt.Rows.Count = 0 Then
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('Não há dados para exportar com os filtros selecionados.');", True)
                Return
            End If

            ' Gerar PDF
            GerarDocumentoPDF(dt)
        End Sub

        Private Sub GerarDocumentoPDF(dt As DataTable)
            ' Configurações do Documento PDF (Formato A4 Deitado / Landscape para melhor encaixe de colunas)
            Dim doc As New Document(PageSize.A4.Rotate(), 20.0F, 20.0F, 30.0F, 30.0F)
            Dim ms As New MemoryStream()
            Dim writer As PdfWriter = PdfWriter.GetInstance(doc, ms)

            doc.Open()

            ' Paleta de Cores do Sistema
            Dim corEscura As New BaseColor(30, 63, 74)     ' #1E3F4A
            Dim corPrincipal As New BaseColor(66, 153, 163) ' #4299A3

            ' Fontes
            Dim fonteTitulo As Font = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 18.0F, corEscura)
            Dim fonteSubtitulo As Font = FontFactory.GetFont(FontFactory.HELVETICA, 10.0F, BaseColor.GRAY)
            Dim fonteHeaderTabela As Font = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10.0F, BaseColor.WHITE)
            Dim fonteCorpo As Font = FontFactory.GetFont(FontFactory.HELVETICA, 9.0F, BaseColor.BLACK)

            ' 1. Cabeçalho do Documento
            Dim pTitulo As New Paragraph("SIGEBIBLIOTECA - Sistema de Gestão de Biblioteca", fonteTitulo)
            pTitulo.Alignment = Element.ALIGN_LEFT
            doc.Add(pTitulo)

            Dim pNomeRelatorio As New Paragraph("RELATÓRIO DE " & ddlTipoRelatorio.SelectedItem.Text.ToUpper(), FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12.0F, corPrincipal))
            pNomeRelatorio.SpacingAfter = 5.0F
            doc.Add(pNomeRelatorio)

            Dim pInfo As New Paragraph("Data de Emissão: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm") & " | Período: " & txtDataInicio.Text & " a " & txtDataFim.Text, fonteSubtitulo)
            pInfo.SpacingAfter = 15.0F
            doc.Add(pInfo)

            ' 2. Tabela com os Dados
            Dim pdfTable As New PdfPTable(dt.Columns.Count)
            pdfTable.WidthPercentage = 100.0F

            ' Adicionar Cabeçalhos
            For Each col As DataColumn In dt.Columns
                Dim cell As New PdfPCell(New Phrase(col.ColumnName, fonteHeaderTabela))
                cell.BackgroundColor = corEscura
                cell.HorizontalAlignment = Element.ALIGN_CENTER
                cell.Padding = 6.0F
                pdfTable.AddCell(cell)
            Next

            ' Adicionar Linhas
            For Each row As DataRow In dt.Rows
                For Each col As DataColumn In dt.Columns
                    Dim cell As New PdfPCell(New Phrase(row(col.ColumnName).ToString(), fonteCorpo))
                    cell.Padding = 5.0F
                    cell.HorizontalAlignment = Element.ALIGN_LEFT
                    pdfTable.AddCell(cell)
                Next
            Next

            doc.Add(pdfTable)
            doc.Close()

            ' 3. Download do arquivo PDF no navegador
            Response.Clear()
            Response.ContentType = "application/pdf"
            Response.AddHeader("content-disposition", "attachment;filename=Relatorio_" & ddlTipoRelatorio.SelectedValue & "_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".pdf")
            Response.Buffer = True
            Response.OutputStream.Write(ms.ToArray(), 0, ms.ToArray().Length)
            Response.OutputStream.Flush()
            Response.End()
        End Sub

    End Class
End Namespace