<!DOCTYPE html>
<html lang="pt" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Iniciar Sessão</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="auth-wrapper">
    <!-- Background Glow Effect -->
    <div class="glow-bg"></div>

    <!-- Navegação Superior -->
    <header class="navbar">
        <a href="/" class="logo">
            <div class="logo-icon">L</div>
            <span class="logo-text">LIFTER</span>
        </a>
        <div class="nav-links">
            <button id="theme-toggle" class="theme-toggle-btn" type="button" aria-label="Alternar Tema">
                <!-- Sol SVG Icon -->
                <svg id="sun-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
                <!-- Lua SVG Icon -->
                <svg id="moon-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:none;"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                <span id="theme-text">Modo Claro</span>
            </button>
        </div>
    </header>

    <!-- Form Card Central sobre o Glow -->
    <main class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Acessar a Plataforma</h2>
                <p>Introduza as suas credenciais para continuar</p>
            </div>
            <?php if (isset($_SESSION['sucesso_registro'])): ?>
    <div class="alert alert-sucesso" style="background: rgba(34, 197, 94, 0.15); border: 1px solid #22C55E; color: #4ADE80; padding: 0.75rem 1rem; border-radius: 8px; margin-bottom: 1rem; font-size: 0.9rem;">
        <span><?= htmlspecialchars($_SESSION['sucesso_registro']); unset($_SESSION['sucesso_registro']); ?></span>
    </div>
<?php endif; ?>

            <!-- Alerta de Segurança (SQL Injection Detectado) -->
            <?php if (!empty($alertaSeguranca)): ?>
                <div class="alert alert-security">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L3 7v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-9-5z"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    <span><?= htmlspecialchars($alertaSeguranca) ?></span>
                </div>
            <?php endif; ?>

            <!-- Alerta de Acesso Negado (Redirecionamento Anónimo) -->
            <?php if (isset($_SESSION['erro_acesso'])): ?>
                <div class="alert alert-warning">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span><?= htmlspecialchars($_SESSION['erro_acesso']); unset($_SESSION['erro_acesso']); ?></span>
                </div>
            <?php endif; ?>

            <?php if (!empty($erro)): ?>
                <div class="alert alert-danger">
                    <span><?= htmlspecialchars($erro) ?></span>
                </div>
            <?php endif; ?>

            <form action="/login" method="POST" class="auth-form">
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <input type="email" name="email" id="email" placeholder="seuemail@exemplo.com" required>
                </div>

                <div class="form-group">
                    <label for="senha">Senha</label>
                    <input type="password" name="senha" id="senha" placeholder="••••••••" required>
                </div>

                <div class="form-options">
                    <label class="checkbox-container">
                        <input type="checkbox" name="remember_me" value="1">
                        <span class="checkmark"></span>
                        Lembrar-me por 7 dias
                    </label>
                    <a href="/recuperar-senha" class="forgot-link">Esqueceu a senha?</a>
                </div>

                <button type="submit" class="btn btn-gold btn-block">Entrar</button>
            </form>

            <div class="auth-footer">
                <p>Ainda não tem uma conta? <a href="/registro">Criar Conta</a></p>
            </div>
        </div>
    </main>

    <script src="/js/theme.js"></script>
</body>
</html>