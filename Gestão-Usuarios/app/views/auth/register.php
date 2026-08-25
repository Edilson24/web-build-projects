<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Cadastro - UserSystem</title>
    <style>
        body { background: #0f172a; color: #fff; font-family: sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: #1e293b; padding: 30px; border-radius: 10px; width: 350px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        h2 { text-align: center; color: #38bdf8; margin-top: 0; }
        .input-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-size: 0.9rem; color: #94a3b8; }
        input[type="text"], input[type="email"], input[type="password"] { width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #334155; background: #0f172a; color: #fff; box-sizing: border-box; }
        .btn { width: 100%; padding: 12px; border: none; border-radius: 5px; background: #38bdf8; color: #0f172a; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .btn:hover { background: #0284c7; color: #fff; }
        .error { background: #ef4444; color: #fff; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 0.85rem; }
        .footer-link { text-align: center; margin-top: 15px; font-size: 0.85rem; }
        .footer-link a { color: #38bdf8; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Criar Conta</h2>
        <?php if (!empty($error)): ?>
            <div class="error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>
        <form action="/register" method="POST">
            <div class="input-group">
                <label>Nome Completo *</label>
                <input type="text" name="nome" required>
            </div>
            <div class="input-group">
                <label>E-mail *</label>
                <input type="email" name="email" required>
            </div>
            <div class="input-group">
                <label>Nome de Utilizador (@username)</label>
                <input type="text" name="user_name">
            </div>
            <div class="input-group">
                <label>Senha *</label>
                <input type="password" name="senha" required>
            </div>
            <div class="input-group">
                <label>Confirmar Senha *</label>
                <input type="password" name="confirmar_senha" required>
            </div>
            <button type="submit" class="btn">Cadastrar</button>
        </form>
        <div class="footer-link">
            Já tem uma conta? <a href="/login">Iniciar Sessão</a>
        </div>
    </div>
</body>
</html>