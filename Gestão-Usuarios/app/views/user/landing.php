<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($titulo ?? 'Gestão de Utilizadores') ?></title>
    <style>
        :root {
            --bg-primary: #0f172a;
            --text-primary: #f8fafc;
            --accent-color: #38bdf8;
            --card-bg: #1e293b;
        }
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 40px;
            background-color: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(10px);
        }
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--accent-color);
        }
        .nav-links a {
            color: var(--text-primary);
            text-decoration: none;
            margin-left: 20px;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .nav-links a.btn-login {
            border: 1px solid var(--accent-color);
            color: var(--accent-color);
        }
        .nav-links a.btn-login:hover {
            background-color: var(--accent-color);
            color: #000;
        }
        .hero {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 0 20px;
        }
        .hero h1 {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        .hero p {
            font-size: 1.2rem;
            color: #94a3b8;
            max-width: 600px;
            margin-bottom: 30px;
        }
        .btn-cta {
            background-color: var(--accent-color);
            color: #0f172a;
            font-weight: bold;
            padding: 14px 28px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 1.1rem;
            transition: transform 0.2s ease;
        }
        .btn-cta:hover {
            transform: scale(1.05);
        }
        footer {
            text-align: center;
            padding: 20px;
            color: #64748b;
            font-size: 0.9rem;
            border-top: 1px solid #334155;
        }
    </style>
</head>
<body>

    <header>
        <div class="logo">UserSystem</div>
        <div class="nav-links">
            <a href="/login" class="btn-login">Iniciar Sessão</a>
            <a href="/register" style="background-color: #38bdf8; color: #0f172a;">Cadastrar</a>
        </div>
    </header>

    <main class="hero">
        <h1>Gestão de Utilizadores Simplificada</h1>
        <p>Plataforma moderna com controlo de acessos, personalização de perfil, suporte técnico integrado e segurança avançada.</p>
        <a href="/register" class="btn-cta">Começar Agora</a>
    </main>

    <footer>
        &copy; <?= date('Y') ?> Universidade Rovuma - Todos os direitos reservados.
    </footer>

</body>
</html>