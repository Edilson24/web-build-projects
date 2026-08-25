<?php
if (!isset($user) || !is_array($user)) { $user = []; }
if (!isset($tickets) || !is_array($tickets)) { $tickets = []; }
?>
<!DOCTYPE html>
<html lang="pt" data-theme="<?= htmlspecialchars($user['tema_preferido'] ?? 'dark') ?>">
<head>
    <meta charset="UTF-8">
    <title>Suporte Técnico - UserSystem</title>
    <style>
        :root[data-theme="dark"] {
            --bg-body: #0f172a; --bg-card: #1e293b; --text-main: #f8fafc; --text-sub: #94a3b8; --border-color: #334155; --accent: #38bdf8;
        }
        :root[data-theme="light"] {
            --bg-body: #f8fafc; --bg-card: #ffffff; --text-main: #0f172a; --text-sub: #64748b; --border-color: #e2e8f0; --accent: #0284c7;
        }
        body { background-color: var(--bg-body); color: var(--text-main); font-family: 'Segoe UI', sans-serif; margin: 0; }
        header { background: var(--bg-card); border-bottom: 1px solid var(--border-color); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: var(--accent); text-decoration: none; font-weight: bold; margin-left: 15px; }
        .container { max-width: 900px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .card { background: var(--bg-card); padding: 25px; border-radius: 10px; border: 1px solid var(--border-color); }
        h3 { margin-top: 0; color: var(--accent); }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-size: 0.85rem; color: var(--text-sub); }
        input[type="text"], textarea { width: 100%; padding: 10px; border-radius: 6px; border: 1px solid var(--border-color); background: var(--bg-body); color: var(--text-main); box-sizing: border-box; }
        .btn { background: var(--accent); color: #000; font-weight: bold; padding: 10px 18px; border: none; border-radius: 6px; cursor: pointer; }
        .ticket-item { display: flex; justify-content: space-between; align-items: center; padding: 12px; background: var(--bg-body); border-radius: 6px; margin-bottom: 10px; border: 1px solid var(--border-color); }
        .ticket-title { font-weight: bold; text-decoration: none; color: var(--text-main); }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; text-transform: uppercase; font-weight: bold; }
        .badge-aberto { background: #eab308; color: #000; }
        .badge-respondido { background: #3b82f6; color: #fff; }
        .badge-fechado { background: #64748b; color: #fff; }
    </style>
</head>
<body>

    <header>
        <div style="font-weight:bold; color:var(--accent);">UserSystem | Suporte</div>
        <div>
            <a href="/perfil">Meu Perfil</a>
            <a href="/logout" style="color:#ef4444;">Sair</a>
        </div>
    </header>

    <div class="container">
        <!-- Formulário de Abrir Chamado -->
        <div class="card">
            <h3>Abrir Novo Chamado</h3>
            <form action="/suporte/novo" method="POST">
                <div class="form-group">
                    <label>Assunto</label>
                    <input type="text" name="assunto" placeholder="Ex: Dúvida sobre o perfil" required>
                </div>
                <div class="form-group">
                    <label>Descrição do Problema / Dúvida</label>
                    <textarea name="mensagem" rows="5" placeholder="Descreva em detalhes..." required></textarea>
                </div>
                <button type="submit" class="btn">Enviar Chamado</button>
            </form>
        </div>

        <!-- Lista de Chamados do Utilizador -->
        <div class="card">
            <h3>Meus Chamados</h3>
            <?php if (empty($tickets)): ?>
                <p style="color:var(--text-sub); font-size:0.9rem;">Nenhum chamado aberto até ao momento.</p>
            <?php else: ?>
                <?php foreach ($tickets as $t): ?>
                    <div class="ticket-item">
                        <div>
                            <a href="/suporte/ver?id=<?= $t['id'] ?>" class="ticket-title">#<?= $t['id'] ?> - <?= htmlspecialchars($t['assunto']) ?></a>
                            <div style="font-size:0.75rem; color:var(--text-sub); margin-top:3px;"><?= date('d/m/Y H:i', strtotime($t['atualizado_em'])) ?></div>
                        </div>
                        <span class="badge badge-<?= htmlspecialchars($t['status']) ?>"><?= htmlspecialchars($t['status']) ?></span>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>

</body>
</html>