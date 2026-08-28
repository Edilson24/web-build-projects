<!DOCTYPE html>
<html lang="pt" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Gestão de Usuários</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/styleDashboard.css">
</head>
<body class="admin-layout">
    <div class="glow-bg"></div>

    <?php include __DIR__ . '/../components/sidebar.php'; ?>

    <main class="admin-main">
        <header class="admin-topbar">
            <h2>Gestão de Usuários</h2>
            <div class="topbar-actions">
                <button id="theme-toggle" class="theme-toggle-btn" type="button">
                    <svg id="sun-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
                    <svg id="moon-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:none;"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                </button>
            </div>
        </header>

        <!-- Barra Superior: Filtros à esquerda, Botão Novo Usuário à direita -->
        <div class="users-toolbar">
            <form method="GET" action="/admin/usuarios" class="filter-form">
                <input type="text" name="busca" placeholder="Buscar por nome ou e-mail..." value="<?= htmlspecialchars($_GET['busca'] ?? '') ?>" class="input-field">
                <select name="status" class="input-field select-field">
                    <option value="">Todos os Status</option>
                    <option value="ativo" <?= ($_GET['status'] ?? '') === 'ativo' ? 'selected' : '' ?>>Ativos</option>
                    <option value="inativo" <?= ($_GET['status'] ?? '') === 'inativo' ? 'selected' : '' ?>>Inativos</option>
                </select>
                <button type="submit" class="btn btn-secondary">Filtrar</button>
            </form>

            <button onclick="openModal('modal-novo')" class="btn btn-gold">+ Novo Usuário</button>
        </div>

        <!-- Tabela de Usuários -->
        <section class="table-container">
            <table class="data-table">
                <thead>
                    <tr>                        
                        <th>Foto</th>
                        <th>Nome</th>
                        <th>E-mail</th>
                        <th>Perfil</th>
                        <th>Status</th>
                        <th style="text-align: right;">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($usuarios)): ?>
                        <?php foreach ($usuarios as $u): ?>
                            <?php 
                                $idAdminLogado = $_SESSION['usuario_id'] ?? $_SESSION['user_id'] ?? 0;
                                $isSelf = ($u['id'] == $idAdminLogado);

                                $avatarUrl = !empty($u['foto_perfil']) 
                                    ? $u['foto_perfil'] 
                                    : 'https://ui-avatars.com/api/?name=' . urlencode($u['nome']) . '&background=D4AF37&color=0B0E14&bold=true';
                            ?>
                            <tr>                                
                                <td>
                                    <img src="<?= htmlspecialchars($avatarUrl) ?>" alt="Avatar" class="user-avatar-img">
                                </td>
                                <td>
                                    <strong><?= htmlspecialchars($u['nome']) ?></strong>
                                    <?php if ($isSelf): ?>
                                        <small class="self-badge">(Você)</small>
                                    <?php endif; ?>
                                </td>
                                <td><?= htmlspecialchars($u['email']) ?></td>
                                <td><span class="role-badge"><?= ucfirst($u['perfil']) ?></span></td>
                                <td>
                                    <span class="badge badge-<?= $u['status'] === 'ativo' ? 'success' : 'danger' ?>">
                                        <?= ucfirst($u['status']) ?>
                                    </span>
                                </td>
                                <td style="text-align: right;" class="actions-cell">
                                    <!-- Botão Editar -->
                                    <button class="icon-action-btn edit-btn" title="Editar Usuário" onclick='openEditModal(<?= json_encode($u) ?>)'>
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    </button>

                                    <!-- Botão Ativar/Desativar -->
                                    <?php if (!$isSelf): ?>
                                        <a href="/admin/usuarios/status?id=<?= $u['id'] ?>" class="icon-action-btn toggle-btn" title="Alternar Status (Ativo/Inativo)">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="5" width="22" height="14" rx="7" ry="7"/><circle cx="<?= $u['status'] === 'ativo' ? '16' : '8' ?>" cy="12" r="3"/></svg>
                                        </a>
                                    <?php endif; ?>

                                    <!-- Botão Excluir -->
                                    <?php if (!$isSelf): ?>
                                        <a href="/admin/usuarios/excluir?id=<?= $u['id'] ?>" class="icon-action-btn delete-btn" title="Excluir Usuário" onclick="return confirm('Tem certeza que deseja excluir este usuário?');">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                                        </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--dash-text-muted);">Nenhum usuário encontrado.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </section>
    </main>

    <!-- Modal: Cadastro de Usuário -->
    <div id="modal-novo" class="modal-backdrop" style="display: none;">
        <div class="auth-card modal-body">
            <h3>Cadastrar Novo Usuário</h3>
            <form action="/admin/usuarios/salvar" method="POST" class="modal-form">
                <input type="text" name="nome" placeholder="Nome Completo" required class="input-field">
                <input type="email" name="email" placeholder="E-mail" required class="input-field">
                <input type="password" name="senha" placeholder="Senha" required class="input-field">
                <select name="perfil" class="input-field select-field">
                    <option value="usuario">Usuário Comum</option>
                    <option value="admin">Administrador</option>
                </select>
                <div class="modal-actions">
                    <button type="button" onclick="closeModal('modal-novo')" class="btn btn-secondary">Cancelar</button>
                    <button type="submit" class="btn btn-gold">Salvar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal: Edição de Usuário -->
    <div id="modal-editar" class="modal-backdrop" style="display: none;">
        <div class="auth-card modal-body">
            <h3>Editar Usuário</h3>
            <form action="/admin/usuarios/atualizar" method="POST" class="modal-form">
                <input type="hidden" name="id" id="edit-id">
                <input type="text" name="nome" id="edit-nome" placeholder="Nome Completo" required class="input-field">
                <input type="email" name="email" id="edit-email" placeholder="E-mail" required class="input-field">
                <select name="perfil" id="edit-perfil" class="input-field select-field">
                    <option value="usuario">Usuário Comum</option>
                    <option value="admin">Administrador</option>
                </select>
                <div class="modal-actions">
                    <button type="button" onclick="closeModal('modal-editar')" class="btn btn-secondary">Cancelar</button>
                    <button type="submit" class="btn btn-gold">Atualizar</button>
                </div>
            </form>
        </div>
    </div>

    <script src="/js/theme.js"></script>
    <script>
        function openModal(id) {
            document.getElementById(id).style.display = 'flex';
        }
        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }
        function openEditModal(user) {
            document.getElementById('edit-id').value = user.id;
            document.getElementById('edit-nome').value = user.nome;
            document.getElementById('edit-email').value = user.email;
            document.getElementById('edit-perfil').value = user.perfil;
            openModal('modal-editar');
        }
    </script>
</body>
</html>