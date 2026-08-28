<!DOCTYPE html>
<html lang="pt" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Painel Administrador</title>
    <link rel="stylesheet" href="/css/styleDashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="admin-layout">
    <div class="glow-bg"></div>

    <?php
        $totais = $totais ?? ['total' => 0, 'ativos' => 0, 'inativos' => 0, 'ataques' => 0];
        $ultimosLogs = $ultimosLogs ?? [];
        $fluxoCadastros = $fluxoCadastros ?? [];
    ?>

    <!-- Menu Lateral Reutilizável -->
    <?php include __DIR__ . '/../components/sidebar.php'; ?>

    <!-- Conteúdo Principal -->
    <main class="admin-main">
        <!-- Topbar com Notificações -->
        <header class="admin-topbar">
            <h2>Visão Geral do Sistema</h2>

            <div class="topbar-actions">
                <!-- Sininho de Notificações -->
                <div class="notification-wrapper">
                    <button id="notif-btn" class="icon-btn" aria-label="Notificações">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                        <span id="notif-badge" class="notif-badge" style="display:none;">0</span>
                    </button>
                    <div id="notif-dropdown" class="notif-dropdown" style="display:none;">
                        <div class="notif-header">
                            <strong>Alertas de Invasão</strong>
                        </div>
                        <ul id="notif-list" class="notif-list">
                            <li class="empty-notif">Nenhum alerta recente</li>
                        </ul>
                    </div>
                </div>

                <!-- Toggle Tema -->
                <button id="theme-toggle" class="theme-toggle-btn" type="button">
                    <svg id="sun-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
                    <svg id="moon-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:none;"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                </button>
            </div>
        </header>

<!-- Cards de Estatísticas -->
<section class="dashboard-cards">
    <div class="dash-card">
        <span class="card-title">Total Usuários</span>
        <span class="card-value"><?= htmlspecialchars($totais['total']) ?></span>
    </div>
    <div class="dash-card card-success">
        <span class="card-title">Usuários Ativos</span>
        <span class="card-value"><?= htmlspecialchars($totais['ativos']) ?></span>
    </div>
    <div class="dash-card card-warning">
        <span class="card-title">Usuários Inativos</span>
        <span class="card-value"><?= htmlspecialchars($totais['inativos']) ?></span>
    </div>
    <div class="dash-card card-danger">
        <span class="card-title">Ataques Rejeitados</span>
        <span class="card-value"><?= htmlspecialchars($totais['ataques']) ?></span>
    </div>
</section>

        <!-- Seção do Gráfico (70%) e Tabela de Logs (30%) -->
        <section class="dashboard-grid">
            <div class="chart-container">
                <h3>Fluxo de Novos Cadastros</h3>
                <canvas id="cadastrosChart"></canvas>
            </div>

            <div class="recent-logs-container">
                <div class="container-header">
                    <h3>Últimos Logs</h3>
                    <a href="/admin/logs" class="link-more">Ver Todos</a>
                </div>
                <table class="logs-mini-table">
                    <thead>
                        <tr>
                            <th>Usuário</th>
                            <th>Ação</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($ultimosLogs as $log): ?>
                            <tr>
                                <td><?= htmlspecialchars($log['nome_usuario']) ?></td>
                                <td><?= htmlspecialchars($log['acao']) ?></td>
                                <td><span class="badge badge-<?= strtolower($log['avaliacao']) ?>"><?= $log['avaliacao'] ?></span></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <!-- Modal Pop-up para Alerta Invasão -->
    <div id="alert-modal" class="modal-backdrop" style="display: none;">
        <div class="auth-card modal-body">
            <div class="alert alert-security">
                <h3>⚠️ Alerta de Segurança Detectado!</h3>
                <p id="alert-modal-text"></p>
            </div>
            <button onclick="document.getElementById('alert-modal').style.display='none'" class="btn btn-gold btn-block" style="margin-top: 1rem;">Ciente / Fechar</button>
        </div>
    </div>

    <script src="/js/theme.js"></script>
    <script>
        // Configuração do Gráfico de Linha (Dourado/Neon padronizado com a UI)
        const labelsMeses = <?= json_encode(array_column($fluxoCadastros, 'mes_ano')) ?>;
        const dadosCadastros = <?= json_encode(array_column($fluxoCadastros, 'total')) ?>;

        const ctx = document.getElementById('cadastrosChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labelsMeses.length ? labelsMeses : ['Atual'],
                datasets: [{
                    label: 'Novos Usuários',
                    data: dadosCadastros.length ? dadosCadastros : [<?= $totais['total'] ?>],
                    borderColor: '#D4AF37',
                    backgroundColor: 'rgba(212, 175, 55, 0.15)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 5,
                    pointBackgroundColor: '#D4AF37'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#888' } },
                    y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#888' }, beginAtZero: true }
                }
            }
        });

        // Toggle do Dropdown do Sininho
        const notifBtn = document.getElementById('notif-btn');
        const notifDropdown = document.getElementById('notif-dropdown');
        notifBtn.addEventListener('click', () => {
            notifDropdown.style.display = notifDropdown.style.display === 'none' ? 'block' : 'none';
        });

        // Polling de Segurança (Notificações e Pop-up)
        let ultimoLogId = 0;
        function checarAlertas() {
            fetch('/admin/alertas-seguranca')
                .then(res => res.json())
                .then(alertas => {
                    const list = document.getElementById('notif-list');
                    const badge = document.getElementById('notif-badge');
                    
                    if (alertas.length > 0) {
                        badge.style.display = 'inline-block';
                        badge.innerText = alertas.length;

                        list.innerHTML = alertas.map(a => `
                            <li class="notif-item">
                                <strong>${a.acao}</strong>
                                <small>${a.nome_usuario} - ${a.data}</small>
                            </li>
                        `).join('');

                        const ultimo = alertas[0];
                        if (ultimoLogId !== 0 && ultimo.id !== ultimoLogId) {
                            document.getElementById('alert-modal-text').innerText = 
                                `Usuário: ${ultimo.nome_usuario}\nAção: ${ultimo.acao}\nData: ${ultimo.data}`;
                            document.getElementById('alert-modal').style.display = 'flex';
                        }
                        ultimoLogId = ultimo.id;
                    }
                });
        }
        setInterval(checarAlertas, 3000);
        checarAlertas();
    </script>
</body>
</html>