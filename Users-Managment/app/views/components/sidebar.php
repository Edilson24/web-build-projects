<?php
if (session_status() === PHP_SESSION_NONE) session_start();
$tipoPerfil = $_SESSION['tipo_perfil'] ?? 'usuario';
$nomeUsuario = $_SESSION['usuario_nome'] ?? 'Utilizador';
$uriAtual = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
?>
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="/" class="logo">
            <div class="logo-icon">L</div>
            <span class="logo-text">LIFTER</span>
        </a>
    </div>

    <nav class="sidebar-menu">
        <span class="menu-label">Navegação Principal</span>
        
        <?php if ($tipoPerfil === 'admin'): ?>
            <a href="/admin/dashboard" class="menu-item <?= $uriAtual === '/admin/dashboard' ? 'active' : '' ?>">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                <span>Dashboard</span>
            </a>
            <a href="/admin/usuarios" class="menu-item <?= $uriAtual === '/admin/usuarios' ? 'active' : '' ?>">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                <span>Gestão de Usuários</span>
            </a>
            <a href="/admin/logs" class="menu-item <?= $uriAtual === '/admin/logs' ? 'active' : '' ?>">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                <span>Logs do Sistema</span>
            </a>
            <a href="/admin/suporte" class="menu-item <?= $uriAtual === '/admin/suporte' ? 'active' : '' ?>">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                <span></span>
            </a>
        <?php else: ?>
            <a href="/user/perfil" class="menu-item <?= $uriAtual === '/user/perfil' ? 'active' : '' ?>">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                <span>Meu Perfil</span>
            </a>
        <?php endif; ?>
    </nav>

    <div class="sidebar-footer">
        <div class="user-info">
            <span class="user-name"><?= htmlspecialchars($nomeUsuario) ?></span>
            <span class="user-role"><?= strtoupper(htmlspecialchars($tipoPerfil)) ?></span>
        </div>
        <a href="/logout" class="btn-logout" title="Encerrar Sessão">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        </a>
    </div>
</aside>