<?php
if (!isset($user) || !is_array($user)) { $user = []; }
if (!isset($ticket) || !is_array($ticket)) { $ticket = []; }
if (!isset($messages) || !is_array($messages)) { $messages = []; }
?>
<!DOCTYPE html>
<html lang="pt" data-theme="<?= htmlspecialchars($user['tema_preferido'] ?? 'dark') ?>">
<head>
    <meta charset="UTF-8">
    <title>Chamado #<?= htmlspecialchars($ticket['id'] ?? '') ?> - Suporte</title>
    <style>
        :root[data-theme="dark"] {
            --bg-body: #0f172a; --bg-card: #1e293b; --text-main: #f8fafc; --text-sub: #94a3b8; --border-color: #334155; --accent: #38bdf8;
        }
        :root[data-theme="light"] {
            --bg-body: #f8fafc; --bg-card: #ffffff; --text-main: #0f172a; --text-sub: #64748b; --border-color: #e2e8f0; --accent: #0284c7;
        }
        body { background-color: var(--bg-body); color: var(--text-main); font-family: 'Segoe UI', sans-serif; margin: 0; }
        header { background: var(--bg-card); border-bottom: 1px solid var(--border-color); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: var(--accent); text-decoration: none; font-weight: bold; }
        .container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .card { background: var(--bg-card); padding: 25px; border-radius: 10px; border: 1px solid var(--border-color); }
        .msg-box { padding: 12px 15px; border-radius: 8px; margin-bottom: 15px; max-width: 80%; }
        .msg-user { background: #0284c7; color: #fff; margin-left: auto; }
        .msg-admin { background: #334155; color: #fff; margin-right: auto; }
        .msg-info { font-size: 0.75rem; opacity: 0.8; margin-bottom: 5px; display: flex; justify-content: space-between; gap: 10px; }
        textarea { width: 100%; padding: 10px; border-radius: 6px; border: 1px solid var(--border-color); background: var(--bg-body); color: var(--text-main); box-sizing: border-box; }
        .btn { background: var(--accent); color: #000; font-weight: bold; padding: 10px 18px; border: none; border-radius: 6px; cursor: pointer; margin-top: 10px; }
    </style>
</head>
<body>

    <header>
        <div style="font-weight:bold; color:var(--accent);">Chamado #<?= htmlspecialchars($ticket['id'] ?? '') ?></div>
        <a href="/suporte">← Voltar para Chamados</a>
    </header>

    <div class="container">
        <div class="card">
            <h2 style="margin-top:0; color:var(--accent);"><?= htmlspecialchars($ticket['assunto'] ?? '') ?></h2>
            <hr style="border:0; border-top:1px solid var(--border-color); margin-bottom:20px;">

            <!-- Histórico de Mensagens -->
            <div style="display:flex; flex-direction:column;">
                <?php foreach ($messages as $m): ?>
                    <?php $isAdmin = ($m['tipo_perfil'] ?? '') === 'admin'; ?>
                    <div class="msg-box <?= $isAdmin ? 'msg-admin' : 'msg-user' ?>">
                        <div class="msg-info">
                            <strong><?= htmlspecialchars($m['remetente_nome'] ?? '') ?> <?= $isAdmin ? '(Suporte)' : '' ?></strong>
                            <span><?= date('d/m/Y H:i', strtotime($m['criado_em'])) ?></span>
                        </div>
                        <div><?= nl2br(htmlspecialchars($m['mensagem'] ?? '')) ?></div>
                    </div>
                <?php endforeach; ?>
            </div>

            <!-- Formulário de Responder -->
            <form action="/suporte/responder" method="POST" style="margin-top:20px;">
                <input type="hidden" name="chamado_id" value="<?= htmlspecialchars($ticket['id'] ?? 0) ?>">
                <textarea name="mensagem" rows="3" placeholder="Escreva a sua resposta..." required></textarea>
                <button type="submit" class="btn">Enviar Resposta</button>
            </form>
        </div>
    </div>

</body>
</html>