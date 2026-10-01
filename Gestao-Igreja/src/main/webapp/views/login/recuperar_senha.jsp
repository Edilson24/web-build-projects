<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGEIGREJA - Recuperar senha</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body class="login-body">
    <div class="login-split-card">
        <div class="login-banner">
            <img src="<%= request.getContextPath() %>/assets/imagens/login.jpeg" alt="Imagem da igreja" class="banner-img">
            <div class="banner-overlay">
                <div class="banner-badge"><i class="fa-solid fa-church"></i> SIGEIGREJA</div>
                <h3>Recuperação de acesso</h3>
                <p>Confirme sua identidade para definir uma nova senha com segurança.</p>
            </div>
        </div>
        <div class="login-form-panel">
            <% String etapa = (String) request.getAttribute("etapa"); %>
            <% if ("email".equals(etapa)) { %>
                <div class="login-header">
                    <h2>Esqueceu sua senha?</h2>
                    <p>Informe o e-mail da sua conta para receber um PIN de recuperação.</p>
                </div>
            <% } else if ("pin".equals(etapa)) { %>
                <div class="login-header">
                    <h2>Verifique seu e-mail</h2>
                    <p>Digite o PIN de 6 dígitos enviado ao e-mail da sua conta. Ele expira em 10 minutos.</p>
                </div>
            <% } else if ("senha".equals(etapa)) { %>
                <div class="login-header">
                    <h2>Defina uma nova senha</h2>
                    <p>Informe a nova senha duas vezes para confirmar.</p>
                </div>
            <% } else { %>
                <div class="login-header">
                    <h2>Senha alterada</h2>
                    <p><%= request.getAttribute("mensagem") %></p>
                </div>
            <% } %>

            <% String erro = (String) request.getAttribute("erro"); %>
            <% if (erro != null) { %>
                <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i><span><%= erro %></span></div>
            <% } %>
            <% String mensagem = (String) request.getAttribute("mensagem"); %>
            <% if (mensagem != null && !"concluido".equals(etapa)) { %>
                <div class="alert-success"><i class="fa-solid fa-circle-check"></i><span><%= mensagem %></span></div>
            <% } %>

            <% if ("email".equals(etapa)) { %>
                <form action="<%= request.getContextPath() %>/recuperar-senha" method="post" class="login-form">
                    <input type="hidden" name="acao" value="solicitar">
                    <div class="form-group">
                        <label for="email">E-mail de acesso</label>
                        <div class="input-icon-wrapper">
                            <i class="fa-regular fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" placeholder="seu.email@exemplo.com" required autofocus>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary"><span>Enviar PIN</span><i class="fa-solid fa-paper-plane"></i></button>
                </form>
            <% } else if ("pin".equals(etapa)) { %>
                <form action="<%= request.getContextPath() %>/recuperar-senha" method="post" class="login-form">
                    <input type="hidden" name="acao" value="verificar">
                    <div class="form-group">
                        <label for="pin">PIN recebido por e-mail</label>
                        <div class="input-icon-wrapper">
                            <i class="fa-solid fa-key input-icon"></i>
                            <input type="text" id="pin" name="pin" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" placeholder="000000" required autofocus>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary"><span>Validar PIN</span><i class="fa-solid fa-check"></i></button>
                </form>
            <% } else if ("senha".equals(etapa)) { %>
                <form action="<%= request.getContextPath() %>/recuperar-senha" method="post" class="login-form">
                    <input type="hidden" name="acao" value="alterar">
                    <div class="form-group">
                        <label for="senha">Nova senha</label>
                        <div class="input-icon-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="senha" name="senha" minlength="8" maxlength="255" autocomplete="new-password" required autofocus>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmarSenha">Confirme a nova senha</label>
                        <div class="input-icon-wrapper">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="confirmarSenha" name="confirmarSenha" minlength="8" maxlength="255" autocomplete="new-password" required>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary"><span>Alterar senha</span><i class="fa-solid fa-key"></i></button>
                </form>
            <% } %>

            <a class="login-forgot-password" href="<%= request.getContextPath() %>/login">Voltar para o login</a>
            <div class="login-footer"><small>&copy; lifter - Todos os direitos reservados</small></div>
        </div>
    </div>
</body>
</html>
