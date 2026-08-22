Option Strict On
Option Explicit On

Namespace SIGEBIBLIOTECA.views

    Partial Public Class Emprestimos

        Protected WithEvents form1 As Global.System.Web.UI.HtmlControls.HtmlForm
        Protected WithEvents ScriptManager1 As Global.System.Web.UI.ScriptManager
        Protected WithEvents MenuLateral As Global.System.Web.UI.UserControl
        Protected WithEvents upPrincipal As Global.System.Web.UI.UpdatePanel
        Protected WithEvents pnlAlerta As Global.System.Web.UI.WebControls.Panel
        Protected WithEvents lblMensagemAlerta As Global.System.Web.UI.WebControls.Label
        Protected WithEvents gvEmprestimos As Global.System.Web.UI.WebControls.GridView

        Protected WithEvents lblDetLeitor As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblDetLivro As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblDetDataEmp As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblDetDataPrev As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblDetAdiantado As Global.System.Web.UI.WebControls.Label
        Protected WithEvents lblDetSaldo As Global.System.Web.UI.WebControls.Label

        Protected WithEvents hfIdEmprestimoDev As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfDataEmprestimoDev As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfDataPrevistaDev As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfPrecoDiarioAplicado As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfValorCompraLivro As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfValorSaldoAluguel As Global.System.Web.UI.WebControls.HiddenField

        Protected WithEvents hfDiasAtraso As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfValorMultaAtraso As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfValorMultaDano As Global.System.Web.UI.WebControls.HiddenField
        Protected WithEvents hfValorTotalPago As Global.System.Web.UI.WebControls.HiddenField

        Protected WithEvents lblLivroDevolucao As Global.System.Web.UI.WebControls.Label
        Protected WithEvents txtDataRealDevolucao As Global.System.Web.UI.WebControls.TextBox
        Protected WithEvents houve_dano As Global.System.Web.UI.WebControls.CheckBox
        Protected WithEvents btnConfirmarDevolucao As Global.System.Web.UI.WebControls.Button

    End Class

End Namespace