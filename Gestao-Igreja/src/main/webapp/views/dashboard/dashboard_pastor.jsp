<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel Pastoral - SIGEIGREJA</title>

    <!-- CSS Exclusivo Pastoral -->
    <link rel="stylesheet" href="<c:url value='/assets/css/stylePastoral.css'/>">
    <!-- FontAwesome para Ícones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js para Gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="app-layout">

    <jsp:include page="/includes/sidebar.jsp" />

    <div class="main-content">

        <jsp:include page="/includes/header.jsp" />

        <div class="dashboard-container">
            <!-- Cabeçalho de Boas-Vindas -->
            <header class="welcome-header">
                <h2><i class="fa-solid fa-church"></i> Painel Pastoral</h2>
                <p>Visão geral sobre o crescimento da igreja e administração das cerimônias espirituais.</p>
            </header>

            <!-- Grid de Cards de Resumo -->
            <section class="cards-grid">
                <div class="stat-card">
                    <div class="card-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="card-info">
                        <span class="card-title">Total de Membros</span>
                        <span class="card-value">${totalMembros != null ? totalMembros : 0}</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon success"><i class="fa-solid fa-water"></i></div>
                    <div class="card-info">
                        <span class="card-title">Batizados</span>
                        <span class="card-value">${totalBatizados != null ? totalBatizados : 0}</span>
                    </div>
                </div>

                <div class="stat-card alert">
                    <div class="card-icon danger"><i class="fa-solid fa-clock"></i></div>
                    <div class="card-info">
                        <span class="card-title">Aguardando Batismo</span>
                        <span class="card-value">${totalAguardando != null ? totalAguardando : 0}</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="card-icon info"><i class="fa-solid fa-user-plus"></i></div>
                    <div class="card-info">
                        <span class="card-title">Entradas / Mês Atual</span>
                        <span class="card-value">+${entradasMes != null ? entradasMes : 0}</span>
                    </div>
                </div>
            </section>

            <!-- Seção Principal: Gráfico e Ações Rápidas -->
            <div class="dashboard-main-grid">
                <!-- Gráfico de Crescimento -->
                <article class="chart-card">
                    <div class="card-header-title">
                        <h3><i class="fa-solid fa-chart-line"></i> Crescimento de Membros (Histórico)</h3>
                    </div>
                    <div class="chart-wrapper">
                        <canvas id="growthChart"></canvas>
                    </div>
                </article>

                <!-- Painel Lateral Pastoral -->
                <aside class="action-card">
                    <div class="card-header-title">
                        <h3><i class="fa-solid fa-list-check"></i> Ação Pastoral Rápida</h3>
                    </div>
                    <p class="action-desc">
                        Gerencie as chamadas das cerimônias e confirme os candidatos batizados.
                    </p>
                    <a href="<c:url value='/pastoral/confirmar-batismo'/>" class="btn-pastoral">
                        <i class="fa-solid fa-check-double"></i> Confirmar Batismos Pendentes
                    </a>

                    <div class="recent-section">
                        <h4><i class="fa-solid fa-user-clock"></i> Últimos Cadastrados</h4>
                        <ul class="recent-list">
                            <c:forEach var="membro" items="${ultimosMembros}">
                                <li>
                                    <span class="member-name">${membro.nome}</span>
                                    <span class="badge ${membro.statusBatismo == 'BATIZADO' ? 'badge-info' : 'badge-warning'}">
                                        ${membro.statusBatismo}
                                    </span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty ultimosMembros}">
                                <li class="empty-msg">Nenhum registro recente encontrado.</li>
                            </c:if>
                        </ul>
                    </div>
                </aside>

                <!-- Alertas de Feedback da Operação -->
                <c:if test="${param.erro == 'conflito_horario'}">
                    <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                        <i class="fa-solid fa-triangle-exclamation"></i> <strong>Atenção:</strong> O horário informado coincide com outro culto já cadastrado no mesmo dia!
                    </div>
                </c:if>
                <c:if test="${param.sucesso == 'culto_criado' || param.sucesso == 'culto_atualizado' || param.sucesso == 'culto_excluido'}">
                    <div class="alert alert-success" style="background-color: #d1e7dd; color: #0f5132; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                        <i class="fa-solid fa-circle-check"></i> Operação de horário de culto realizada com sucesso!
                    </div>
                </c:if>

                <!-- Widget Mini Tabela: Horários de Culto -->
                <article class="chart-card" style="margin-top: 24px;">
                    <div class="card-header-title" style="display: flex; justify-content: space-between; align-items: center;">
                        <h3><i class="fa-solid fa-calendar-days"></i> Horários dos Cultos da Igreja</h3>
                        <button type="button" class="btn-pastoral" style="width: auto; padding: 6px 12px; font-size: 0.85rem;" onclick="abrirModalNovoCulto()">
                            <i class="fa-solid fa-plus"></i>
                        </button>
                    </div>

                    <div style="overflow-x: auto; margin-top: 15px;">
                        <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
                            <thead>
                                <tr style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; text-align: left;">
                                    <th style="padding: 10px;">Dia da Semana</th>
                                    <th style="padding: 10px;">Período / Horário</th>
                                    <th style="padding: 10px;">Descrição</th>
                                    <th style="padding: 10px; text-align: center;">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${listaCultos}">
                                    <tr style="border-bottom: 1px solid #e9ecef;">
                                        <td style="padding: 10px; font-weight: 600; color: #0d6efd;">${c.diaSemana}</td>
                                        <td style="padding: 10px;">${c.horarioInicio} ás ${c.horarioFim}</td>
                                        <td style="padding: 10px;">${c.descricao}</td>
                                        <td style="padding: 10px; text-align: center;">
                                            <button type="button" style="background: none; border: none; color: #0d6efd; cursor: pointer; margin-right: 8px;"
                                                    onclick="abrirModalEditarCulto('${c.idculto}', '${c.diaSemana}', '${c.horarioInicio}', '${c.horarioFim}', '${c.descricao}')">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>
                                            <button type="button" style="background: none; border: none; color: #dc3545; cursor: pointer;"
                                                    onclick="abrirModalExcluirCulto('${c.idculto}', '${c.descricao}')">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listaCultos}">
                                    <tr>
                                        <td colspan="4" style="padding: 15px; text-align: center; color: #6c757d;">Nenhum horário de culto cadastrado.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </article>

                <!-- MODAL CADASTRAR / EDITAR CULTO -->
                <div id="modalCulto" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
                    <div style="background:#fff; padding:24px; border-radius:8px; width:100%; max-width:450px;">
                        <h3 id="modalCultoTitulo" style="margin-top:0; color:#0d6efd;">Cadastrar Horário de Culto</h3>

                        <form action="${pageContext.request.contextPath}/pastoral/culto" method="POST">
                            <input type="hidden" name="acao" id="cultoAcao" value="cadastrar">
                            <input type="hidden" name="idculto" id="cultoId">

                            <div style="margin-bottom:12px;">
                                <label style="display:block; font-size:0.85rem; font-weight:600;">Dia da Semana</label>
                                <select name="diaSemana" id="cultoDia" required style="width:100%; padding:8px; margin-top:4px; border-radius:4px; border:1px solid #ccc;">
                                    <option value="Domingo">Domingo</option>
                                    <option value="Segunda-feira">Segunda-feira</option>
                                    <option value="Terça-feira">Terça-feira</option>
                                    <option value="Quarta-feira">Quarta-feira</option>
                                    <option value="Quinta-feira">Quinta-feira</option>
                                    <option value="Sexta-feira">Sexta-feira</option>
                                    <option value="Sábado">Sábado</option>
                                </select>
                            </div>

                            <div style="display:flex; gap:10px; margin-bottom:12px;">
                                <div style="flex:1;">
                                    <label style="display:block; font-size:0.85rem; font-weight:600;">Início</label>
                                    <input type="time" name="horarioInicio" id="cultoInicio" required style="width:100%; padding:8px; margin-top:4px; border-radius:4px; border:1px solid #ccc;">
                                </div>
                                <div style="flex:1;">
                                    <label style="display:block; font-size:0.85rem; font-weight:600;">Fim</label>
                                    <input type="time" name="horarioFim" id="cultoFim" required style="width:100%; padding:8px; margin-top:4px; border-radius:4px; border:1px solid #ccc;">
                                </div>
                            </div>

                            <div style="margin-bottom:18px;">
                                <label style="display:block; font-size:0.85rem; font-weight:600;">Descrição / Nome do Culto</label>
                                <input type="text" name="descricao" id="cultoDescricao" placeholder="Ex: Culto de Ensino" required style="width:100%; padding:8px; margin-top:4px; border-radius:4px; border:1px solid #ccc;">
                            </div>

                            <div style="display:flex; justify-content:flex-end; gap:10px;">
                                <button type="button" onclick="fecharModalCulto()" style="padding:8px 16px; background:#6c757d; color:#fff; border:none; border-radius:4px; cursor:pointer;">Cancelar</button>
                                <button type="submit" class="btn-pastoral" style="width:auto; padding:8px 16px;">Salvar</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- MODAL CONFIRMAR EXCLUSÃO -->
                <div id="modalExcluirCulto" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
                    <div style="background:#fff; padding:24px; border-radius:8px; width:100%; max-width:400px;">
                        <h3 style="margin-top:0; color:#dc3545;"><i class="fa-solid fa-triangle-exclamation"></i> Confirmar Exclusão</h3>
                        <p style="font-size:0.9rem; color:#555;">Deseja realmente excluir o horário do <strong id="nomeCultoExcluir"></strong>?</p>

                        <form action="${pageContext.request.contextPath}/pastoral/culto" method="POST">
                            <input type="hidden" name="acao" value="excluir">
                            <input type="hidden" name="idculto" id="cultoExcluirId">

                            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                                <button type="button" onclick="fecharModalExcluirCulto()" style="padding:8px 16px; background:#6c757d; color:#fff; border:none; border-radius:4px; cursor:pointer;">Cancelar</button>
                                <button type="submit" style="padding:8px 16px; background:#dc3545; color:#fff; border:none; border-radius:4px; cursor:pointer;">Excluir</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Script de Inicialização do Chart.js -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const ctx = document.getElementById('growthChart').getContext('2d');

            const labelsMeses = ${labelsMesesJson != null ? labelsMesesJson : "['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago']"};
            const dadosMembros = ${dadosCrescimentoJson != null ? dadosCrescimentoJson : "[12, 19, 25, 32, 40, 48, 55, 60]"};

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labelsMeses,
                    datasets: [{
                        label: 'Número Total de Membros',
                        data: dadosMembros,
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.08)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.3,
                        pointBackgroundColor: '#0d6efd',
                        pointRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: '#e9ecef' }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });
        });

        function abrirModalNovoCulto() {
                document.getElementById('cultoAcao').value = 'cadastrar';
                document.getElementById('cultoId').value = '';
                document.getElementById('modalCultoTitulo').innerText = 'Cadastrar Horário de Culto';
                document.getElementById('cultoDia').value = 'Domingo';
                document.getElementById('cultoInicio').value = '';
                document.getElementById('cultoFim').value = '';
                document.getElementById('cultoDescricao').value = '';
                document.getElementById('modalCulto').style.display = 'flex';
            }

            function abrirModalEditarCulto(id, dia, inicio, fim, desc) {
                document.getElementById('cultoAcao').value = 'editar';
                document.getElementById('cultoId').value = id;
                document.getElementById('modalCultoTitulo').innerText = 'Editar Horário de Culto';
                document.getElementById('cultoDia').value = dia;
                document.getElementById('cultoInicio').value = inicio;
                document.getElementById('cultoFim').value = fim;
                document.getElementById('cultoDescricao').value = desc;
                document.getElementById('modalCulto').style.display = 'flex';
            }

            function fecharModalCulto() {
                document.getElementById('modalCulto').style.display = 'none';
            }

            function abrirModalExcluirCulto(id, desc) {
                document.getElementById('cultoExcluirId').value = id;
                document.getElementById('nomeCultoExcluir').innerText = desc;
                document.getElementById('modalExcluirCulto').style.display = 'flex';
            }

            function fecharModalExcluirCulto() {
                document.getElementById('modalExcluirCulto').style.display = 'none';
            }

    </script>
</body>
</html>