<!DOCTYPE html>
<html lang="pt" data-theme="<?= htmlspecialchars($usuario['tema_preferido'] ?? 'dark') ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Configurações</title>
    <link rel="stylesheet" href="/css/styleDashboard.css">
    <link rel="stylesheet" href="/css/styleUsuario.css">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="admin-layout">
    <div class="glow-bg"></div>



    <main class="admin-main">
        <header class="admin-topbar">
            <h2>Configurações da Conta</h2>
                        <div class="topbar-actions">
                <a href="/perfil" class="btn btn-gold btn-edit-profile">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                    Meu Perfil
                </a>
            </div>
        </header>

        <section class="user-container">
            <?php if (isset($_SESSION['sucesso'])): ?>
                <div class="alert alert-success">
                    <?= $_SESSION['sucesso']; unset($_SESSION['sucesso']); ?>
                </div>
            <?php endif; ?>

            <?php if (isset($_SESSION['erro'])): ?>
                <div class="alert alert-danger">
                    <?= $_SESSION['erro']; unset($_SESSION['erro']); ?>
                </div>
            <?php endif; ?>

            <form action="/configuracoes/salvar" method="POST" enctype="multipart/form-data" class="card-user">
                
                <!-- Avatar / Upload de Foto -->
                <?php 
                    $avatarUrl = !empty($usuario['foto_perfil']) 
                        ? $usuario['foto_perfil'] 
                        : 'https://ui-avatars.com/api/?name=' . urlencode($usuario['nome'] ?? 'Usuario') . '&background=D4AF37&color=0B0E14&bold=true';
                ?>
                <div class="avatar-upload-container">
                    <img id="avatar-preview" src="<?= htmlspecialchars($avatarUrl) ?>" alt="Foto de Perfil" class="user-avatar-preview">
                    <div class="avatar-upload-actions">
                        <label for="foto_upload" class="btn btn-outline-gold">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            Carregar Nova Foto
                        </label>
                        <input type="file" id="foto_upload" name="foto_perfil_file" accept="image/*" class="file-input-hidden" onchange="previewImagem(event)">
                        <small class="upload-hint">Formatos: JPG, PNG ou WEBP.</small>
                    </div>
                </div>

                <h3 class="section-title">Dados Pessoais</h3>
                
                <!-- Linha 1: Nome Completo e Nome de Usuário -->
                <div class="form-row">
                    <div class="form-group flex-1">
                        <label for="nome">Nome Completo</label>
                        <input type="text" id="nome" name="nome" value="<?= htmlspecialchars($usuario['nome'] ?? '') ?>" class="input-field" required>
                    </div>

                    <div class="form-group flex-1">
                        <label for="user_name">Nome de Usuário</label>
                        <input type="text" id="user_name" name="user_name" value="<?= htmlspecialchars($usuario['user_name'] ?? '') ?>" class="input-field">
                    </div>
                </div>

                <!-- Linha 2: E-mail e Tema -->
                <div class="form-row">
                    <div class="form-group flex-2">
                        <label for="email">E-mail</label>
                        <input type="email" id="email" name="email" value="<?= htmlspecialchars($usuario['email'] ?? '') ?>" class="input-field" required>
                    </div>

                    <div class="form-group flex-1">
                        <label for="tema_preferido">Tema Preferido</label>
                        <select id="tema_preferido" name="tema_preferido" class="select-field">
                            <option value="dark" <?= ($usuario['tema_preferido'] ?? '') === 'dark' ? 'selected' : '' ?>>Escuro (Dark)</option>
                            <option value="light" <?= ($usuario['tema_preferido'] ?? '') === 'light' ? 'selected' : '' ?>>Claro (Light)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="bio">Biografia</label>
                    <textarea id="bio" name="bio" class="input-field" rows="3"><?= htmlspecialchars($usuario['bio'] ?? '') ?></textarea>
                </div>

                <hr class="form-divider">

                <h3 class="section-title">Segurança</h3>
                <div class="form-row">
                    <div class="form-group flex-1">
                        <label for="nova_senha">Nova Senha</label>
                        <input type="password" id="nova_senha" name="nova_senha" class="input-field" placeholder="Deixe em branco para manter a atual">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-gold">Guardar Alterações</button>
                </div>
            </form>
        </section>
    </main>

    <script>
        function previewImagem(event) {
            const input = event.target;
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatar-preview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>