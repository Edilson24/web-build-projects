<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="SIGEBIBLIOTECA.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="pt">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SIGEBIBLIOTECAS - Autenticação</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <style>
        :root {
            --color-light-blue: #ABDFEA;
            --color-medium-blue: #4299A3;
            --color-dark-blue: #1E3F4A;
            --color-soft-white: #F8FCFD;
        }

        /* Fundo em gradiente suave com a paleta */
        body {
            background: linear-gradient(135deg, var(--color-light-blue) 0%, var(--color-medium-blue) 50%, var(--color-dark-blue) 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Card Flutuante */
        .card-login {
            background-color: var(--color-soft-white);
            border: 1px solid rgba(171, 223, 234, 0.5);
            border-radius: 1rem;
            box-shadow: 0 15px 35px rgba(30, 63, 74, 0.25);
        }

        /* Títulos e Destaques */
        .text-brand-dark {
            color: var(--color-dark-blue);
        }

        .icon-brand {
            color: var(--color-medium-blue);
        }

        /* Estilização dos Input Groups */
        .input-group-text-custom {
            background-color: #FFFFFF;
            border-color: #D1E9EE;
            color: var(--color-medium-blue);
        }

        .form-control-custom {
            border-color: #D1E9EE;
            color: var(--color-dark-blue);
        }

        .form-control-custom:focus {
            border-color: var(--color-medium-blue);
            box-shadow: 0 0 0 0.25rem rgba(66, 153, 163, 0.25);
        }

        /* Botão Personalizado */
        .btn-brand {
            background-color: var(--color-dark-blue);
            border-color: var(--color-dark-blue);
            color: #FFFFFF;
            transition: all 0.3s ease;
        }

        .btn-brand:hover {
            background-color: var(--color-medium-blue);
            border-color: var(--color-medium-blue);
            color: #FFFFFF;
            box-shadow: 0 5px 15px rgba(66, 153, 163, 0.4);
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100 m-0">
    <form id="form1" runat="server" class="w-100">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 col-sm-10 col-md-6 col-lg-4">
                    
                    <div class="card card-login p-3">
                        <div class="card-body p-4 text-center">
                            
                            <div class="mb-3 icon-brand">
                                <i class="fas fa-book-reader fa-3x"></i>
                            </div>
                            <h4 class="fw-bold mb-1 text-brand-dark">GESTÃO DE BIBLIOTECAS</h4>
                            <p class="text-muted small mb-4">Acesso Restrito ao Sistema</p>

                            <asp:Panel ID="pnlErro" runat="server" Visible="false" CssClass="alert alert-danger p-2 small mb-3">
                                <asp:Label ID="lblErro" runat="server"></asp:Label>
                            </asp:Panel>

                            <div class="text-start">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-brand-dark">E-mail</label>
                                    <div class="input-group">
                                        <span class="input-group-text input-group-text-custom"><i class="fas fa-envelope"></i></span>
                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-custom" TextMode="Email" placeholder="seu email" Required="true"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold small text-brand-dark">Senha</label>
                                    <div class="input-group">
                                        <span class="input-group-text input-group-text-custom"><i class="fas fa-lock"></i></span>
                                        <asp:TextBox ID="txtSenha" runat="server" CssClass="form-control form-control-custom" TextMode="Password" placeholder="••••••••" Required="true"></asp:TextBox>
                                    </div>
                                </div>

                                <asp:Button ID="btnLogin" runat="server" Text="Entrar no Sistema" CssClass="btn btn-brand w-100 fw-semibold py-2 mt-3" OnClick="btnLogin_Click" />
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>