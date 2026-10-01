<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGEIGREJA - Autenticação</title>
    <!-- Font Awesome para ícones vetoriais -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body class="login-body">

    <!-- Card Split Lado a Lado inspirado no modelo -->
    <div class="login-split-card">

        <!-- Painel Esquerdo: Imagem da Igreja + Banner Overlay -->
        <div class="login-banner">
            <img src="<%= request.getContextPath() %>/assets/imagens/login.jpeg" alt="Logo/Imagem da Igreja" class="banner-img">
            <div class="banner-overlay">
                <div class="banner-badge">
                    <i class="fa-solid fa-church"></i> SIGEIGREJA
                </div>
                <h3>Gestão Integrada & Eficiente</h3>
                <p>Plataforma centralizada para administração de membros, finanças e atividades pastorais.</p>
            </div>
        </div>

        <!-- Painel Direito: Formulário de Autenticação -->
        <div class="login-form-panel">
            <div class="login-header">
                <h2>Bem-vindo de volta!</h2>
                <p>Insira suas credenciais para acessar o sistema.</p>
            </div>

            <%-- Exibição de mensagens de erro capturadas pela LoginServlet --%>
            <%
                String erro = (String) request.getAttribute("erro");
                if (erro != null) {
            %>
                <div class="alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= erro %></span>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post" class="login-form">
                <div class="form-group">
                    <label for="email">E-mail de Acesso</label>
                    <div class="input-icon-wrapper">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" placeholder="seu.email@sigeigreja.com" required autofocus>
                    </div>
                </div>

                <div class="form-group">
                    <label for="senha">Senha</label>
                    <div class="input-icon-wrapper">
                        <i class="fa-solid fa-lock input-icon"></i>
                        <input type="password" id="senha" name="senha" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary">
                    <span>Entrar no Sistema</span>
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                </button>
            </form>

            <a class="login-forgot-password" href="<%= request.getContextPath() %>/recuperar-senha">Esqueceu sua senha?</a>

            <div class="login-footer">
                <small>&copy; lifter - Todos os direitos reservados</small>
            </div>
        </div>

    </div>

</body>
</html>