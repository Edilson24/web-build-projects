<!DOCTYPE html>
<html lang="pt" data-theme="<?= htmlspecialchars($usuario['tema_preferido'] ?? 'dark') ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Meu Perfil</title>
    <link rel="stylesheet" href="/css/styleDashboard.css">
    <link rel="stylesheet" href="/css/styleUsuario.css">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="admin-layout">
    <?php $usuario = $usuario ?? []; ?>
    <div class="glow-bg"></div>

    <main class="admin-main">
        <header class="admin-topbar">
            <h2>Meu Perfil</h2>
            <div class="topbar-actions">
                <a href="/configuracoes" class="btn btn-gold btn-edit-profile">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                    Editar Dados
                </a>
            </div>
        </header>

        <section class="user-container">
            <div class="card-user">
                <?php 
                    $avatarUrl = !empty($usuario['foto_perfil']) 
                        ? $usuario['foto_perfil'] 
                        : 'https://ui-avatars.com/api/?name=' . urlencode($usuario['nome'] ?? 'Usuario') . '&background=D4AF37&color=0B0E14&bold=true';
                ?>
                <div class="user-profile-header">
                    <img src="<?= htmlspecialchars($avatarUrl) ?>" alt="Foto de Perfil" class="user-avatar">
                    <div class="user-info-main">
                        <h2><?= htmlspecialchars($usuario['nome'] ?? 'Usuário') ?></h2>
                        <p class="user-username">@<?= htmlspecialchars($usuario['user_name'] ?? 'usuario') ?></p>
                        <span class="badge badge-success"><?= ucfirst(htmlspecialchars($usuario['status'] ?? 'ativo')) ?></span>
                    </div>
                </div>

                <div class="user-info-grid">
                    <div class="user-info-item">
                        <strong>E-mail</strong>
                        <p><?= htmlspecialchars($usuario['email'] ?? 'N/A') ?></p>
                    </div>
                    <div class="user-info-item">
                        <strong>Perfil / Permissão</strong>
                        <p><?= ucfirst(htmlspecialchars($usuario['tipo_perfil'] ?? $usuario['perfil'] ?? 'Membro')) ?></p>
                    </div>
                    <div class="user-info-item">
                        <strong>Tema Preferido</strong>
                        <p><?= ucfirst(htmlspecialchars($usuario['tema_preferido'] ?? 'Dark')) ?></p>
                    </div>
                </div>

                <?php if (!empty($usuario['bio'])): ?>
                    <div class="user-bio-section">
                        <strong>Biografia</strong>
                        <p><?= nl2br(htmlspecialchars($usuario['bio'])) ?></p>
                    </div>
                <?php endif; ?>
            </div>
        </section>
    </main>
</body>
</html>