<?php
if (!isset($currentUser) || !is_array($currentUser)) { $currentUser = []; }
if (!isset($users) || !is_array($users)) { $users = []; }
if (!isset($stats) || !is_array($stats)) { $stats = []; }
?>
<!DOCTYPE html>
<html lang="pt" data-theme="<?= htmlspecialchars($currentUser['tema_preferido'] ?? 'dark') ?>">
<head>
    <meta charset="UTF-8">
    <title>Painel Administrativo - UserSystem</title>
    <style>
        :root[data-theme="dark"] {
            --bg-body: #0f172a; --bg-card: #1e293b; --text-main: #f8fafc; --text-sub: #94a3b8; --border-color: #334155; --accent: #38bdf8; --input-bg: #0f172a;
        }
        :root[data-theme="light"] {
            --bg-body: #f8fafc; --bg-card: #ffffff; --text-main: #0f172a; --text-sub: #64748b; --border-color: #e2e8f0; --accent: #0284c7; --input-bg: #ffffff;

            --bg-body: #0f172a; --bg-card: #1e293b; --text-main: #f8fafc; --text-sub: #94a3b8; --border-color: #334155; --accent: #38bdf8;
        }
        :root[data-theme="light"] {
            --bg-body: #f8fafc; --bg-card: #ffffff; --text-main: #0f172a; --text-sub: #64748b; --border-color: #e2e8f0; --accent: #0284c7;
        }
        body { background-color: var(--bg-body); color: var(--text-main); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; }
        header { background: var(--bg-card); border-bottom: 1px solid var(--border-color); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        header a { color: var(--accent); text-decoration: none; font-weight: bold; margin-left: 15px; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: var(--bg-card); border: 1px solid var(--border-color); padding: 20px; border-radius: 8px; text-align: center; }
        .stat-number { font-size: 2rem; font-weight: bold; color: var(--accent); }
        .stat-label { font-size: 0.85rem; color: var(--text-sub); margin-top: 5px; }
        .card { background: var(--bg-card); border: 1px solid var(--border-color); padding: 25px; border-radius: 8px; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid var(--border-color); font-size: 0.9rem; }
        th { color: var(--text-sub); }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; text-transform: uppercase; }
        .badge-active { background: #22c55e; color: #000; }
        .badge-inactive { background: #ef4444; color: #fff; }
        .badge-admin { background: #eab308; color: #000; }
        .badge-usuario { background: #3b82f6; color: #fff; }

        /* Botões de Ação com Ícones */
        .btn-add { background: var(--accent); color: #000; padding: 8px 16px; border-radius: 6px; font-weight: bold; text-decoration: none; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; }
        .btn-icon { background: transparent; border: 1px solid var(--border-color); border-radius: 6px; padding: 6px 10px; cursor: pointer; color: var(--text-main); font-size: 0.9rem; text-decoration: none; display: inline-flex; align-items: center; }
        .btn-icon:hover { background: var(--border-color); }
        .btn-icon-danger { color: #ef4444; }
        .btn-icon-danger:hover { background: #ef4444; color: #fff; }

        /* Modais */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background: var(--bg-card); border: 1px solid var(--border-color); padding: 25px; border-radius: 8px; width: 400px; color: var(--text-main); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-size: 0.85rem; margin-bottom: 5px; color: var(--text-sub); }
        .form-group input, .form-group select { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid var(--border-color); background: var(--input-bg); color: var(--text-main); box-sizing: border-box; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn-cancel { background: transparent; border: 1px solid var(--border-color); color: var(--text-main); padding: 8px 15px; border-radius: 4px; cursor: pointer; }
        .btn-save { background: var(--accent); color: #000; border: none; padding: 8px 15px; border-radius: 4px; font-weight: bold; cursor: pointer; }
        .btn-action { text-decoration: none; padding: 5px 10px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; color: #000; display: inline-block; margin-right: 5px; }
        .btn-toggle { background: #eab308; }
        .btn-status { background: #38bdf8; }
    </style>
</head>
<body>

    <header>
        <div style="font-weight:bold; color:var(--accent); font-size:1.2rem;">UserSystem | Administrador</div>
        <div>
            <a href="/perfil">Meu Perfil</a>
            <a href="/suporte">Suporte</a>
            <a href="/logout" style="color:#ef4444;">Sair</a>
        </div>
    </header>

    <div class="container">
        <!-- Dashboard Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><?= $stats['total_users'] ?? 0 ?></div>
                <div class="stat-label">Total de Utilizadores</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><?= $stats['active_users'] ?? 0 ?></div>
                <div class="stat-label">Contas Ativas</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><?= $stats['admin_users'] ?? 0 ?></div>
                <div class="stat-label">Administradores</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><?= $stats['total_tickets'] ?? 0 ?></div>
                <div class="stat-label">Chamados de Suporte</div>
            </div>
        </div>

        <!-- Tabela de Gestão de Utilizadores -->
        <div class="card">
            <div class="card-header">
                <h3 style="margin:0; color:var(--accent);">Gestão de Utilizadores</h3>
                <button class="btn-add" onclick="openCreateModal()">+ Adicionar Membro</button>
            </div>

            <h3 style="margin-top:0; color:var(--accent);">Gestão de Utilizadores</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>Email / Username</th>
                        <th>Nível</th>
                        <th>Status</th>
                        <th>Data Registo</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($users as $u): ?>
                        <tr>
                            <td>#<?= $u['id'] ?></td>
                            <td><strong><?= htmlspecialchars($u['nome']) ?></strong></td>
                            <td>
                                <?= htmlspecialchars($u['email']) ?>
                                <?php if (!empty($u['user_name'])): ?>
                                    <br><small style="color:var(--text-sub);">@<?= htmlspecialchars($u['user_name']) ?></small>
                                <?php endif; ?>
                            </td>
                            <td>
                                <span class="badge badge-<?= htmlspecialchars($u['tipo_perfil']) ?>"><?= htmlspecialchars($u['tipo_perfil']) ?></span>
                            </td>
                            <td>
                                <span class="badge badge-<?= $u['status'] === 'ativo' ? 'active' : 'inactive' ?>"><?= htmlspecialchars($u['status']) ?></span>
                            </td>
                            <td><?= date('d/m/Y', strtotime($u['created_at'])) ?></td>
                            <td>
                                <?php if ((int)$u['id'] !== (int)$currentUser['id']): ?>

                                    <!-- Botão Editar (Lápis) -->
                                    <button class="btn-icon" title="Editar Utilizador" onclick='openEditModal(<?= json_encode($u) ?>)'>
                                        ✏️
                                    </button>
                                    
                                    <!-- Botão Eliminar (Lixeira) -->
                                    <a href="/admin/usuario/eliminar?id=<?= $u['id'] ?>" class="btn-icon btn-icon-danger" title="Eliminar Utilizador" onclick="return confirm('Tem certeza de que deseja eliminar permanentemente este utilizador?');">
                                        🗑️

                                    <a href="/admin/status?id=<?= $u['id'] ?>" class="btn-action btn-status" onclick="return confirm('Deseja alterar o status deste utilizador?');">
                                        <?= $u['status'] === 'ativo' ? 'Bloquear' : 'Ativar' ?>
                                    </a>
                                    <a href="/admin/role?id=<?= $u['id'] ?>" class="btn-action btn-toggle" onclick="return confirm('Deseja alterar o nível de acesso deste utilizador?');">
                                        Mudar Nível

                                    </a>
                                <?php else: ?>
                                    <span style="font-size:0.8rem; color:var(--text-sub);">(Sua conta)</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>


    <!-- Modal Adicionar Utilizador -->
    <div id="createModal" class="modal">
        <div class="modal-content">
            <h3 style="margin-top:0; color:var(--accent);">Adicionar Novo Membro</h3>
            <form action="/admin/usuario/criar" method="POST">
                <div class="form-group">
                    <label>Nome Completo</label>
                    <input type="text" name="nome" required>
                </div>
                <div class="form-group">
                    <label>E-mail</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Senha Inicial</label>
                    <input type="password" name="senha" required>
                </div>
                <div class="form-group">
                    <label>Nível de Acesso</label>
                    <select name="tipo_perfil">
                        <option value="usuario">Utilizador</option>
                        <option value="admin">Administrador</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select name="status">
                        <option value="ativo">Ativo</option>
                        <option value="inativo">Inativo</option>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('createModal')">Cancelar</button>
                    <button type="submit" class="btn-save">Salvar Utilizador</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Editar Utilizador -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h3 style="margin-top:0; color:var(--accent);">Editar Utilizador</h3>
            <form action="/admin/usuario/editar" method="POST">
                <input type="hidden" name="id" id="edit_id">
                <div class="form-group">
                    <label>Nome Completo</label>
                    <input type="text" name="nome" id="edit_nome" required>
                </div>
                <div class="form-group">
                    <label>E-mail</label>
                    <input type="email" name="email" id="edit_email" required>
                </div>
                <div class="form-group">
                    <label>Nova Senha (Deixe em branco para não alterar)</label>
                    <input type="password" name="senha" placeholder="Opicional">
                </div>
                <div class="form-group">
                    <label>Nível de Acesso</label>
                    <select name="tipo_perfil" id="edit_tipo_perfil">
                        <option value="usuario">Utilizador</option>
                        <option value="admin">Administrador</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select name="status" id="edit_status">
                        <option value="ativo">Ativo</option>
                        <option value="inativo">Inativo</option>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('editModal')">Cancelar</button>
                    <button type="submit" class="btn-save">Atualizar Dados</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openCreateModal() {
            document.getElementById('createModal').style.display = 'flex';
        }

        function openEditModal(user) {
            document.getElementById('edit_id').value = user.id;
            document.getElementById('edit_nome').value = user.nome;
            document.getElementById('edit_email').value = user.email;
            document.getElementById('edit_tipo_perfil').value = user.tipo_perfil;
            document.getElementById('edit_status').value = user.status;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Fechar modal ao clicar fora da caixa
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }
    </script>


</body>
</html>