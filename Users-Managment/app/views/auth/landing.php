<!DOCTYPE html>
<html lang="pt" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - User Management System</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="glow-bg"></div>

    <!-- Navegação Superior -->
    <header class="navbar">
        <a href="/" class="logo">
            <div class="logo-icon">L</div>
            <span class="logo-text">LIFTER</span>
        </a>
        <nav class="nav-links">
            <!-- Botão para Alternar o Tema -->
            <button id="theme-toggle" class="theme-toggle-btn" type="button" aria-label="Alternar Tema">
                <span id="theme-icon">☀️</span>
                <span id="theme-text">Modo Claro</span>
            </button>

            <a href="/login" class="nav-link">Entrar</a>
            <a href="/registro" class="btn btn-gold">Criar Conta</a>
        </nav>
    </header>

    <!-- Hero Section -->
    <main>
        <section class="hero-section">
            <div class="hero-badge">Ecossistema de Gestão & Autenticação</div>
            <h1 class="hero-title">
                Plataforma de Gestão de Utilizadores <br>
                <span class="gradient-text">Segura, Rápida e Inteligente</span>
            </h1>
            <p class="hero-description">
                A LIFTER desenvolve soluções enterprise para controlo de acesso, gestão de perfis dinâmicos, integração de redes sociais e suporte em tempo real.
            </p>
            <div class="hero-actions">
                <a href="/registro" class="btn btn-gold">Começar Gratuitamente</a>
                <a href="/login" class="btn btn-outline">Acessar a Plataforma</a>
            </div>
        </section>

        <!-- Grid de Recursos -->
        <section class="features-section">
            <div class="section-header">
                <h2 class="section-title">Serviços & Funcionalidades da LIFTER</h2>
            </div>
            <div class="features-grid">
                <div class="card">
                    <div class="card-icon">⚡</div>
                    <h3>Autenticação & Sessões</h3>
                    <p>Controlo de acessos com encriptação avançada, suporte a token "Lembrar-me" por 7 dias e recuperação segura de credenciais.</p>
                </div>

                <div class="card">
                    <div class="card-icon">👤</div>
                    <h3>Perfis Personalizados</h3>
                    <p>Geração automática de avatares com inicial do nome, personalização de temas visuais e integração inteligente com redes sociais.</p>
                </div>

                <div class="card">
                    <div class="card-icon">🛡️</div>
                    <h3>Gestão Administrativa</h3>
                    <p>Painel administrativo robusto para gerir utilizadores, ativar/desativar contas e monitorizar acessos em tempo real.</p>
                </div>

                <div class="card">
                    <div class="card-icon">💬</div>
                    <h3>Suporte Integrado</h3>
                    <p>Central de assistência direta para contas desativadas ou dúvidas, conectando os utilizadores diretamente à equipe de administração.</p>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <p>&copy; <?= date('Y') ?> LIFTER - User Management System. Todos os direitos reservados.</p>
    </footer>

    <!-- Script JS para controlo do tema -->
    <script src="/js/theme.js"></script>
</body>
</html>