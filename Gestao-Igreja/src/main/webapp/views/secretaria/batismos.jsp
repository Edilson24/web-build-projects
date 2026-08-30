<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Batismo, model.Usuario, model.Crente" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGEIGREJA - Gestão de Batismos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styleSecretaria.css">
</head>
<body class="dashboard-body">

    <!-- Topbar -->
    <header class="top-bar">
        <div class="brand">
            <i class="fa-solid fa-church"></i>
            <span>SIGEIGREJA</span>
        </div>
        <div class="user-info">
            <span><i class="fa-solid fa-user-circle"></i> <%= usuario != null ? usuario.getNome() : "Secretaria" %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <i class="fa-solid fa-right-from-bracket"></i> Sair
            </a>
        </div>
    </header>

    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/dashboard" class="nav-item">
                    <i class="fa-solid fa-chart-line"></i> Visão Geral
                </a>
                <a href="<%= request.getContextPath() %>/secretaria/membros" class="nav-item">
                    <i class="fa-solid fa-users"></i> Gestão de Membros
                </a>
                <a href="<%= request.getContextPath() %>/secretaria/batismos" class="nav-item active">
                    <i class="fa-solid fa-water"></i> Batismos
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header flex-header">
                <div>
                    <h2>Gestão de Batismos</h2>
                    <p>Agende cerimônias de batismo, vincule candidatos elegíveis e gere listas para impressão.</p>
                </div>
                <button class="btn-primary" onclick="openModal('modalNovoBatismo')">
                    <i class="fa-solid fa-calendar-plus"></i> Agendar Cerimônia
                </button>
            </div>

            <!-- FEEDBACK DE ERRO OU SUCESSO -->
            <% if (request.getParameter("erro") != null) { %>
                <div class="alert alert-danger" style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 6px; margin-bottom: 1.5rem; border: 1px solid #fca5a5;">
                    <i class="fa-solid fa-triangle-exclamation"></i> <%= request.getParameter("erro") %>
                </div>
            <% } %>

            <% if (request.getParameter("sucesso") != null) { %>
                <div class="alert alert-success" style="background: #dcfce7; color: #166534; padding: 12px 16px; border-radius: 6px; margin-bottom: 1.5rem; border: 1px solid #86efac;">
                    <i class="fa-solid fa-circle-check"></i> Operação realizada com sucesso!
                </div>
            <% } %>

            <!-- TABELA DE DADOS -->
            <div class="table-card">
                <table class="data-table" id="batismosTable">
                    <thead>
                        <tr>
                            <th>Data</th>
                            <th>Local</th>
                            <th>Pastor Responsável</th>
                            <th>Candidatos (Máx 10)</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Batismo> batismos = (List<Batismo>) request.getAttribute("batismos");
                            if (batismos != null && !batismos.isEmpty()) {
                                for (Batismo b : batismos) {
                        %>
                            <tr>
                                <td><strong><%= b.getData() %></strong></td>
                                <td><%= b.getLocal() %></td>
                                <td><%= b.getNomePastor() %></td>
                                <td>
                                    <% if (b.getTotalCandidatos() >= 10) { %>
                                        <span class="badge badge-warning" style="background: #fee2e2; color: #991b1b;"><%= b.getTotalCandidatos() %> / 10 (Lotado)</span>
                                    <% } else { %>
                                        <span class="badge badge-success"><%= b.getTotalCandidatos() %> / 10</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <button class="btn-icon" title="Ver Candidatos / Imprimir Lista" onclick="abrirCandidatos(<%= b.getIdbatismo() %>, '<%= b.getData() %>', '<%= b.getLocal() %>', '<%= b.getNomePastor() %>')">
                                        <i class="fa-solid fa-list-check"></i>
                                    </button>
                                    <% if (b.getTotalCandidatos() < 10) { %>
                                        <button class="btn-icon" title="Vincular Membro" onclick="abrirVincular(<%= b.getIdbatismo() %>)">
                                            <i class="fa-solid fa-user-plus"></i>
                                        </button>
                                    <% } %>
                                </td>
                            </tr>
                        <%      }
                            } else {
                        %>
                            <tr>
                                <td colspan="5" class="text-center">Nenhuma cerimônia de batismo agendada.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- MODAL 1: NOVO BATISMO -->
    <div id="modalNovoBatismo" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-calendar-plus"></i> Agendar Cerimônia</h3>
                <button class="btn-close" onclick="closeModal('modalNovoBatismo')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/secretaria/batismos" method="POST">
                <input type="hidden" name="acao" value="cadastrarBatismo">

                <div class="modal-body grid-form">
                    <div class="form-group">
                        <label>Data da Cerimônia *</label>
                        <input type="date" name="data" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Pastor Responsável *</label>
                        <select name="idpastor" class="form-control" required>
                            <option value="">Selecione um pastor...</option>
                            <%
                                List<Usuario> pastores = (List<Usuario>) request.getAttribute("pastores");
                                if (pastores != null) {
                                    for (Usuario p : pastores) {
                            %>
                                <option value="<%= p.getIdusuario() %>"><%= p.getNome() %></option>
                            <%      }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label>Local da Cerimônia *</label>
                        <input type="text" name="local" class="form-control" placeholder="Ex: Praia de Nacala / Tanque da Igreja Central" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalNovoBatismo')">Cancelar</button>
                    <button type="submit" class="btn-primary">Salvar Agendamento</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: VINCULAR MEMBRO (ELEGÍVEIS: NÃO_BATIZADO) -->
    <div id="modalVincular" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-user-plus"></i> Inscrever Membro (Não Batizado)</h3>
                <button class="btn-close" onclick="closeModal('modalVincular')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/secretaria/batismos" method="POST">
                <input type="hidden" name="acao" value="vincularCandidato">
                <input type="hidden" id="vincularIdBatismo" name="idbatismo">

                <div class="modal-body grid-form">
                    <div class="form-group full-width">
                        <label>Membro Elegível *</label>
                        <select name="idcrente" class="form-control" required>
                            <option value="">Selecione um membro não batizado...</option>
                            <%
                                List<Crente> elegiveis = (List<Crente>) request.getAttribute("crentesElegiveis");
                                if (elegiveis != null) {
                                    for (Crente c : elegiveis) {
                            %>
                                <option value="<%= c.getIdcrente() %>"><%= c.getNome() %></option>
                            <%      }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Padrinho (Opcional)</label>
                        <input type="text" name="padrinho" class="form-control" placeholder="Nome do padrinho">
                    </div>
                    <div class="form-group">
                        <label>Madrinha (Opcional)</label>
                        <input type="text" name="madrinha" class="form-control" placeholder="Nome da madrinha">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalVincular')">Cancelar</button>
                    <button type="submit" class="btn-primary">Vincular Candidato</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 3: LISTA DE CANDIDATOS E IMPRESSÃO -->
    <div id="modalCandidatos" class="modal-overlay">
        <div class="modal-box" style="max-width: 700px;">
            <div class="modal-header">
                <h3><i class="fa-solid fa-print"></i> Lista de Candidatos ao Batismo</h3>
                <button class="btn-close" onclick="closeModal('modalCandidatos')">&times;</button>
            </div>
            <div class="modal-body" id="printArea">
                <div style="margin-bottom: 1rem;">
                    <h4 id="lblDataLocal" style="color: var(--primary-blue); margin-bottom: 4px;">-</h4>
                    <p id="lblPastor" style="font-size: 0.9rem; color: #555;">-</p>
                </div>
                <table class="data-table" style="font-size: 0.9rem;">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nome do Candidato</th>
                            <th>Padrinho / Madrinha</th>
                            <th>Status Batismo</th>
                        </tr>
                    </thead>
                    <tbody id="tbCandidatosBody">
                        <tr><td colspan="4" class="text-center">Carregando...</td></tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('modalCandidatos')">Fechar</button>
                <button type="button" class="btn-primary" onclick="imprimirLista()"><i class="fa-solid fa-print"></i> Imprimir Lista</button>
            </div>
        </div>
    </div>

    <!-- SCRIPTS DE INTERAÇÃO -->
    <script>
        function openModal(id) {
            document.getElementById(id).classList.add('active');
        }

        function closeModal(id) {
            document.getElementById(id).classList.remove('active');
        }

        function abrirVincular(idBatismo) {
            document.getElementById('vincularIdBatismo').value = idBatismo;
            openModal('modalVincular');
        }

        function abrirCandidatos(idBatismo, data, local, pastor) {
            document.getElementById('lblDataLocal').innerText = 'Cerimônia: ' + data + ' - Local: ' + local;
            document.getElementById('lblPastor').innerText = 'Pastor Responsável: ' + pastor;

            const tbody = document.getElementById('tbCandidatosBody');
            tbody.innerHTML = '<tr><td colspan="4" class="text-center">Buscando candidatos...</td></tr>';

            fetch('<%= request.getContextPath() %>/secretaria/batismos/candidatos?id=' + idBatismo)
                .then(res => res.json())
                .then(data => {
                    tbody.innerHTML = '';
                    if (data && data.length > 0) {
                        data.forEach((c, index) => {
                            let padrinhar = [c.padrinho, c.madrinha].filter(Boolean).join(' / ') || '-';
                            let status = c.confirmado ?
                                '<span class="badge badge-success"><i class="fa-solid fa-check"></i> Batizado</span>' :
                                '<span class="badge badge-warning"><i class="fa-solid fa-clock"></i> Aguardando</span>';
                            tbody.innerHTML += `
                                <tr>
                                    <td>${index + 1}</td>
                                    <td><strong>${c.nome}</strong></td>
                                    <td>${padrinhar}</td>
                                    <td>${status}</td>
                                </tr>`;
                        });
                    } else {
                        tbody.innerHTML = '<tr><td colspan="4" class="text-center">Nenhum candidato vinculado a esta cerimônia.</td></tr>';
                    }
                })
                .catch(() => {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center">Erro ao carregar candidatos.</td></tr>';
                });

            openModal('modalCandidatos');
        }

        function imprimirLista() {
            const printContent = document.getElementById('printArea').innerHTML;
            const originalContent = document.body.innerHTML;
            document.body.innerHTML = '<div style="padding: 20px;"><h2>SIGEIGREJA - Relatório de Cerimônia de Batismo</h2><hr style="margin-bottom: 20px;">' + printContent + '</div>';
            window.print();
            document.body.innerHTML = originalContent;
            window.location.reload();
        }
    </script>
</body>
</html>