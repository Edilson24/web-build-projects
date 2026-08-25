<?php
// Proteção defensiva para evitar erros de variáveis indefinidas
if (!isset($user) || !is_array($user)) {
    $user = [];
}
if (!isset($socialLinks) || !is_array($socialLinks)) {
    $socialLinks = [];
}

// Definição do Avatar Padrão com iniciais dinâmicas caso não tenha foto enviada
$avatarDisplay = $avatarUrl ?? ($user['foto_perfil'] ?? null 
    ? '/uploads/' . $user['foto_perfil'] 
    : 'https://ui-avatars.com/api/?name=' . urlencode($user['nome'] ?? 'User') . '&background=38bdf8&color=0f172a&size=128');
?>
<!DOCTYPE html>
<html lang="pt" data-theme="<?= htmlspecialchars($user['tema_preferido'] ?? 'dark') ?>">
<head>
    <meta charset="UTF-8">
    <title>Perfil - <?= htmlspecialchars($user['nome'] ?? 'Utilizador') ?></title>
    <style>
        :root[data-theme="dark"] {
            --bg-body: #0f172a;
            --bg-card: #1e293b;
            --text-main: #f8fafc;
            --text-sub: #94a3b8;
            --border-color: #334155;
            --accent: #38bdf8;
        }
        :root[data-theme="light"] {
            --bg-body: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-sub: #64748b;
            --border-color: #e2e8f0;
            --accent: #0284c7;
        }
        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }
        header {
            background: var(--bg-card);
            border-bottom: 1px solid var(--border-color);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-title { font-weight: bold; font-size: 1.2rem; color: var(--accent); }
        .nav-right a { color: var(--text-main); text-decoration: none; margin-left: 15px; font-weight: 500; }
        .container { max-width: 900px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 280px 1fr; gap: 30px; }
        .sidebar { background: var(--bg-card); padding: 20px; border-radius: 10px; border: 1px solid var(--border-color); text-align: center; }
        .avatar { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid var(--accent); margin-bottom: 15px; }
        .main-content { background: var(--bg-card); padding: 25px; border-radius: 10px; border: 1px solid var(--border-color); }
        h3 { margin-top: 0; color: var(--accent); }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-size: 0.85rem; color: var(--text-sub); }
        input[type="text"], input[type="url"], textarea, select {
            width: 100%; padding: 10px; border-radius: 6px; border: 1px solid var(--border-color);
            background: var(--bg-body); color: var(--text-main); box-sizing: border-box;
        }
        .btn { background: var(--accent); color: #000; font-weight: bold; padding: 10px 18px; border: none; border-radius: 6px; cursor: pointer; }
        .social-item { display: flex; justify-content: space-between; align-items: center; padding: 8px; background: var(--bg-body); border-radius: 5px; margin-bottom: 8px; }
        .social-item a { color: var(--accent); text-decoration: none; font-weight: 500; }
        .social-item .btn-del { color: #ef4444; text-decoration: none; font-size: 0.85rem; }
    </style>
</head>
<body>

    <header>
        <div class="header-title">UserSystem</div>
        <div class="nav-right">
            <span>Olá, <?= htmlspecialchars($user['nome'] ?? 'Visitante') ?></span>
            <?php if (($user['tipo_perfil'] ?? '') === 'admin'): ?>
                <a href="/admin" style="color:#eab308;">Painel Admin</a>
            <?php endif; ?>
            <a href="/logout" style="color:#ef4444;">Sair</a>
        </div>
    </header>

    <div class="container">
        <!-- Sidebar de Informações Rápidas -->
        <div class="sidebar">
            <img src="<?= htmlspecialchars($avatarDisplay) ?>" alt="Avatar" class="avatar">
            <h2 style="margin:5px 0; font-size:1.3rem;"><?= htmlspecialchars($user['nome'] ?? '') ?></h2>
            <p style="color:var(--text-sub); font-size:0.9rem; margin-bottom:15px;">
                <?= htmlspecialchars(!empty($user['user_name']) ? '@' . $user['user_name'] : ($user['email'] ?? '')) ?>
            </p>
            <p style="font-size:0.85rem; color:var(--text-sub);"><?= htmlspecialchars($user['bio'] ?? 'Sem bio adicionada.') ?></p>
        </div>

        <!-- Conteúdo Principal de Edição -->
        <div class="main-content">
            <h3>Configurações do Perfil</h3>
            
            <form action="/perfil/atualizar" method="POST" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Fotografia de Perfil</label>
                    <input type="file" name="foto" accept="image/*">
                </div>
                <div class="form-group">
                    <label>Nome Completo</label>
                    <input type="text" name="nome" value="<?= htmlspecialchars($user['nome'] ?? '') ?>" required>
                </div>
                <div class="form-group">
                    <label>Nome de Utilizador (@username)</label>
                    <input type="text" name="user_name" value="<?= htmlspecialchars($user['user_name'] ?? '') ?>">
                </div>
                <div class="form-group">
                    <label>Bio / Descrição Pessoal</label>
                    <textarea name="bio" rows="3"><?= htmlspecialchars($user['bio'] ?? '') ?></textarea>
                </div>
                <div class="form-group">
                    <label>Tema de Preferência Visual</label>
                    <select name="tema_preferido">
                        <option value="dark" <?= ($user['tema_preferido'] ?? 'dark') === 'dark' ? 'selected' : '' ?>>Escuro (Dark)</option>
                        <option value="light" <?= ($user['tema_preferido'] ?? 'dark') === 'light' ? 'selected' : '' ?>>Claro (Light)</option>
                    </select>
                </div>
                <button type="submit" class="btn">Guardar Alterações</button>
            </form>

            <hr style="border:0; border-top:1px solid var(--border-color); margin: 30px 0;">

            <h3>Redes Sociais</h3>
            <form action="/perfil/social/adicionar" method="POST" style="display:flex; gap:10px; margin-bottom:15px;">
                <input type="url" name="url_link" placeholder="Ex: https://github.com/seuusuario" required>
                <button type="submit" class="btn" style="white-space:nowrap;">Adicionar Link</button>
            </form>

            <div>
                <?php foreach ($socialLinks as $link): ?>
                    <?php 
                        $urlLower = strtolower($link['url_link'] ?? '');
                        $platform = 'Link Externo';
                        if (str_contains($urlLower, 'github.com')) $platform = 'GitHub';
                        elseif (str_contains($urlLower, 'linkedin.com')) $platform = 'LinkedIn';
                        elseif (str_contains($urlLower, 'instagram.com')) $platform = 'Instagram';
                        elseif (str_contains($urlLower, 'facebook.com')) $platform = 'Facebook';
                    ?>
                    <div class="social-item">
                        <span><strong>[<?= $platform ?>]</strong> <a href="<?= htmlspecialchars($link['url_link'] ?? '#') ?>" target="_blank"><?= htmlspecialchars($link['url_link'] ?? '') ?></a></span>
                        <a href="/perfil/social/remover?id=<?= $link['id'] ?? 0 ?>" class="btn-del">Remover</a>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>

</body>
</html>