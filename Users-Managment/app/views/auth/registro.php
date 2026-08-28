<!DOCTYPE html>
<html lang="pt" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Criar Conta</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="auth-wrapper">
    <div class="glow-bg"></div>

    <header class="navbar">
        <a href="/" class="logo">
            <div class="logo-icon">L</div>
            <span class="logo-text">LIFTER</span>
        </a>
        <div class="nav-links">
            <button id="theme-toggle" class="theme-toggle-btn" type="button" aria-label="Alternar Tema">
                <svg id="sun-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
                <svg id="moon-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:none;"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                <span id="theme-text">Modo Claro</span>
            </button>
        </div>
    </header>

    <main class="auth-container">
        <div class="auth-card" style="max-width: 500px;">
            <div class="auth-header">
                <h2>Criar uma Conta</h2>
                <p>Preencha os dados abaixo para se juntar à LIFTER</p>
            </div>

            <!-- Alerta de Segurança (Ataques Bloqueados) -->
            <?php if (!empty($alertaSeguranca)): ?>
                <div class="alert alert-security">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L3 7v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-9-5z"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    <span><?= htmlspecialchars($alertaSeguranca) ?></span>
                </div>
            <?php endif; ?>

            <?php if (!empty($erro)): ?>
                <div class="alert alert-danger">
                    <span><?= htmlspecialchars($erro) ?></span>
                </div>
            <?php endif; ?>

            <form action="/registro" method="POST" enctype="multipart/form-data" class="auth-form">
                <div class="form-group">
                    <label for="nome">Nome Completo *</label>
                    <input type="text" name="nome" id="nome" placeholder="Ex: João Silva" required>
                </div>

                <div class="form-group">
                    <label for="email">E-mail *</label>
                    <input type="email" name="email" id="email" placeholder="seuemail@exemplo.com" required>
                </div>

                <div class="form-group">
                    <label for="username">Username (Opcional)</label>
                    <input type="text" name="username" id="username" placeholder="@seuusuario">
                </div>

                <div class="form-group">
                    <label for="senha">Senha *</label>
                    <input type="password" name="senha" id="senha" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label for="confirmar_senha">Confirmar Senha *</label>
                    <input type="password" name="confirmar_senha" id="confirmar_senha" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label for="foto">Foto de Perfil (Opcional)</label>
                    <input type="file" name="foto" id="foto" accept="image/*" style="padding: 0.4rem;">
                </div>

                <button type="submit" class="btn btn-gold btn-block" style="margin-top: 1rem;">Cadastrar Conta</button>
            </form>

            <div class="auth-footer">
                <p>Já possui uma conta? <a href="/login">Iniciar Sessão</a></p>
            </div>
        </div>
    </main>

    <script src="/js/theme.js"></script>
</body>
</html>