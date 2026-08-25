<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sessão - UserSystem</title>
    <style>
        body { background: #0f172a; color: #fff; font-family: sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: #1e293b; padding: 30px; border-radius: 10px; width: 350px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        h2 { text-align: center; color: #38bdf8; margin-top: 0; }
        .input-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-size: 0.9rem; color: #94a3b8; }
        input[type="email"], input[type="password"] { width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #334155; background: #0f172a; color: #fff; box-sizing: border-box; }
        .checkbox-group { display: flex; align-items: center; margin-bottom: 15px; font-size: 0.85rem; color: #94a3b8; }
        .checkbox-group input { margin-right: 8px; }
        .btn { width: 100%; padding: 12px; border: none; border-radius: 5px; background: #38bdf8; color: #0f172a; font-weight: bold; cursor: pointer; }
        .btn:hover { background: #0284c7; color: #fff; }
        .error { background: #ef4444; color: #fff; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 0.85rem; }
        .success { background: #22c55e; color: #fff; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 0.85rem; }
        .footer-link { text-align: center; margin-top: 15px; font-size: 0.85rem; }
        .footer-link a { color: #38bdf8; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Iniciar Sessão</h2>

        <?php if (isset($_GET['registered'])): ?>
            <div class="success">Conta criada com sucesso! Faça o login abaixo.</div>
        <?php endif; ?>

        <?php if (!empty($error)): ?>
            <div class="error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <form action="/login" method="POST">
            <div class="input-group">
                <label>E-mail</label>
                <input type="email" name="email" required>
            </div>
            <div class="input-group">
                <label>Senha</label>
                <input type="password" name="senha" required>
            </div>
            <div class="checkbox-group">
                <input type="checkbox" name="remember_me" id="remember">
                <label for="remember" style="margin:0; cursor:pointer;">Lembrar-me por 7 dias</label>
            </div>
            <button type="submit" class="btn">Entrar</button>
        </form>
        <div class="footer-link">
            Ainda não tem conta? <a href="/register">Registar-se</a>
        </div>
    </div>
</body>
</html>