<?php $logs = isset($logs) && is_array($logs) ? $logs : []; ?>
<!DOCTYPE html>
<html lang="pt" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIFTER - Logs do Sistema</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/styleDashboard.css">
</head>
<body class="admin-layout">
    <div class="glow-bg"></div>

    <?php include __DIR__ . '/../components/sidebar.php'; ?>

    <main class="admin-main">
        <header class="admin-topbar">
            <h2>Registo de Logs do Sistema</h2>
            <div class="topbar-actions">
                <button id="theme-toggle" class="theme-toggle-btn" type="button">
                    <svg id="sun-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
                    <svg id="moon-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:none;"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                </button>
            </div>
        </header>

        <section style="text-align: left; max-width: 1000px; margin-top: 1rem;">
            <p class="hero-description" style="margin-bottom: 2rem;">Monitorização de ações legítimas e bloqueio de ataques em tempo real.</p>

            <div class="card" style="padding: 1.5rem; overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr style="border-bottom: 1px solid var(--border-color);">
                            <th style="padding: 0.75rem;">Utilizador</th>
                            <th style="padding: 0.75rem;">Ação</th>
                            <th style="padding: 0.75rem;">Avaliação</th>
                            <th style="padding: 0.75rem;">Data / Hora</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($logs as $log): ?>
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 0.75rem;"><?= htmlspecialchars($log['nome_usuario']) ?></td>
                                <td style="padding: 0.75rem;"><?= htmlspecialchars($log['acao']) ?></td>
                                <td style="padding: 0.75rem;">
                                    <span class="badge badge-<?= strtolower($log['avaliacao']) ?>">
                                        <?= htmlspecialchars($log['avaliacao']) ?>
                                    </span>
                                </td>
                                <td style="padding: 0.75rem;"><?= htmlspecialchars($log['data']) ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <!-- Modal Pop-up para Alertas de Invasão -->
    <div id="alert-modal" class="modal-backdrop" style="display: none;">
        <div class="auth-card modal-body">
            <div class="alert alert-security">
                <h3>⚠️ Alerta de Segurança Detectado!</h3>
                <p id="alert-modal-text"></p>
            </div>
            <button onclick="fecharModalAlerta()" class="btn btn-gold btn-block" style="margin-top: 1rem;">Ciente / Fechar</button>
        </div>
    </div>

    <script src="/js/theme.js"></script>
    <script>
        // Polling para checar invasões e disparar o Pop-up na apresentação
        let ultimoLogId = 0;

        function verificarInvasoes() {
            fetch('/admin/alertas-seguranca')
                .then(res => res.json())
                .then(alertas => {
                    if (alertas.length > 0) {
                        const ultimo = alertas[0];
                        if (ultimoLogId !== 0 && ultimo.id !== ultimoLogId) {
                            document.getElementById('alert-modal-text').innerText = 
                                `Utilizador: ${ultimo.nome_usuario}\nAção: ${ultimo.acao}\nAvaliação: ${ultimo.avaliacao}\nData: ${ultimo.data}`;
                            document.getElementById('alert-modal').style.display = 'flex';
                        }
                        ultimoLogId = ultimo.id;
                    }
                });
        }

        function fecharModalAlerta() {
            document.getElementById('alert-modal').style.display = 'none';
        }

        setInterval(verificarInvasoes, 3000); // Checa a cada 3 segundos
    </script>
</body>
</html>