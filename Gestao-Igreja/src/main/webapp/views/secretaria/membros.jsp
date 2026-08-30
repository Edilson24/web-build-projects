<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Crente" %>
<%
    model.Usuario usuario = (model.Usuario) session.getAttribute("usuarioLogado");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGEIGREJA - Gestão de Membros</title>
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
                <a href="<%= request.getContextPath() %>/secretaria/membros" class="nav-item active">
                    <i class="fa-solid fa-users"></i> Gestão de Membros
                </a>
                <a href="<%= request.getContextPath() %>/secretaria/batismos" class="nav-item">
                    <i class="fa-solid fa-water"></i> Batismos
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header flex-header">
                <div>
                    <h2>Gestão de Membros</h2>
                    <p>Gerencie registros de crentes, batismos e relacionamentos familiares.</p>
                </div>
                <button class="btn-primary" onclick="openModal('modalCadastro')">
                    <i class="fa-solid fa-user-plus"></i> Novo Membro
                </button>
            </div>

            <!-- BARRA DE FILTROS -->
            <div class="filter-card">
                <div class="filter-group flex-2">
                    <i class="fa-solid fa-magnifying-glass filter-icon"></i>
                    <input type="text" id="filterSearch" class="form-control" placeholder="Buscar por nome ou telefone..." onkeyup="filtrarTabela()">
                </div>
                <div class="filter-group flex-1">
                    <select id="filterBatismo" class="form-control" onchange="filtrarTabela()">
                        <option value="">Status Batismo (Todos)</option>
                        <option value="BATIZADO">Batizado</option>
                        <option value="AGUARDANDO_BATISMO">Aguardando Batismo</option>
                    </select>
                </div>
                <div class="filter-group flex-1">
                    <select id="filterEstadoCivil" class="form-control" onchange="filtrarTabela()">
                        <option value="">Estado Civil (Todos)</option>
                        <option value="Solteiro(a)">Solteiro(a)</option>
                        <option value="Casado(a)">Casado(a)</option>
                        <option value="Divorciado(a)">Divorciado(a)</option>
                        <option value="Viúvo(a)">Viúvo(a)</option>
                    </select>
                </div>
            </div>

            <!-- TABELA DE DADOS (SEM COLUNA DE ID EXIBIDA) -->
            <div class="table-card">
                <table class="data-table" id="membersTable">
                    <thead>
                        <tr>
                            <th>Nome Completo</th>
                            <th>Telefone</th>
                            <th>Estado Civil</th>
                            <th>Status Batismo</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Crente> membros = (List<Crente>) request.getAttribute("membros");
                            if (membros != null && !membros.isEmpty()) {
                                for (Crente m : membros) {
                        %>
                            <tr>
                                <td><strong><%= m.getNome() %></strong></td>
                                <td><%= m.getTelefone() != null ? m.getTelefone() : "-" %></td>
                                <td><%= m.getEstadoCivil() %></td>
                                <td>
                                    <% if ("BATIZADO".equals(m.getStatusBatismo())) { %>
                                        <span class="badge badge-success"><i class="fa-solid fa-water"></i> Batizado</span>
                                    <% } else { %>
                                        <span class="badge badge-warning"><i class="fa-solid fa-clock"></i> Aguardando</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <button class="btn-icon" title="Ver Detalhes e Parentes" onclick="abrirDetalhes(<%= m.getIdcrente() %>, '<%= m.getNome() %>', '<%= m.getTelefone() %>', '<%= m.getEstadoCivil() %>', '<%= m.getStatusBatismo() %>')">
                                        <i class="fa-solid fa-eye"></i>
                                    </button>
                                    <button class="btn-icon" title="Editar Membro" onclick="abrirEdicao(<%= m.getIdcrente() %>, '<%= m.getNome() %>', '<%= m.getDataNascimento() %>', '<%= m.getTelefone() != null ? m.getTelefone() : "" %>', '<%= m.getEstadoCivil() %>', '<%= m.getStatusBatismo() %>', '<%= m.getEndereco() != null ? m.getEndereco() : "" %>', <%= m.getIdgrupo() %>)">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <button class="btn-icon" title="Vincular Parentesco" onclick="abrirParentesco(<%= m.getIdcrente() %>, '<%= m.getNome() %>')">
                                        <i class="fa-solid fa-people-arrows"></i>
                                    </button>
                                </td>
                            </tr>
                        <%      }
                            } else {
                        %>
                            <tr>
                                <td colspan="5" class="text-center">Nenhum crente cadastrado no sistema.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- MODAL 1: CADASTRO DE MEMBRO -->
    <div id="modalCadastro" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-user-plus"></i> Cadastrar Novo Membro</h3>
                <button class="btn-close" onclick="closeModal('modalCadastro')">&times;</button>
            </div>
            <!-- Action ajustado para a rota padrão do Servlet de membros -->
            <form action="<%= request.getContextPath() %>/secretaria/membros" method="POST">
                <!-- Nome do parâmetro alterado de "action" para "acao" e valor para "cadastrar" -->
                <input type="hidden" name="acao" value="cadastrar">

                <div class="modal-body grid-form">
                    <div class="form-group full-width">
                        <label>Nome Completo *</label>
                        <input type="text" name="nome" class="form-control" required placeholder="Ex: João da Silva">
                    </div>
                    <div class="form-group">
                        <label>Data de Nascimento *</label>
                        <input type="date" name="dataNascimento" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Telefone</label>
                        <input type="text" name="telefone" class="form-control" placeholder="+258 8X XXX XXXX">
                    </div>
                    <div class="form-group">
                        <label>Estado Civil *</label>
                        <select name="estadoCivil" class="form-control" required>
                            <option value="Solteiro(a)">Solteiro(a)</option>
                            <option value="Casado(a)">Casado(a)</option>
                            <option value="Divorciado(a)">Divorciado(a)</option>
                            <option value="Viúvo(a)">Viúvo(a)</option>
                        </select>
                    </div>



                    <div class="form-group full-width">
                        <label>Endereço / Bairro</label>
                        <input type="text" name="endereco" class="form-control" placeholder="Ex: Bairro Central, Nacala-Porto">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalCadastro')">Cancelar</button>
                    <button type="submit" class="btn-primary">Salvar Cadastramento</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: PARENTESCO N:N -->
    <div id="modalParentesco" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-people-arrows"></i> Vincular Parentesco</h3>
                <button class="btn-close" onclick="closeModal('modalParentesco')">&times;</button>
            </div>
            <!-- Action ajustado com campo oculta action=parentesco -->
            <form action="<%= request.getContextPath() %>/secretaria/membros" method="POST">
                <!-- Parâmetros alinhados: acao, idcrente1, idcrente2, tipoParentesco -->
                <input type="hidden" name="acao" value="vincularParentesco">
                <input type="hidden" id="parentescoCrenteId" name="idcrente1">

                <div class="modal-body">
                    <p class="target-member-info">Membro: <strong id="parentescoCrenteNome">-</strong></p>

                    <div class="form-group" style="margin-top: 1rem;">
                        <label>Selecione o Parente (Crente) *</label>
                        <select name="idcrente2" class="form-control" required>
                            <option value="">Selecione um crente da lista...</option>
                            <% if (membros != null) {
                                for (Crente p : membros) { %>
                                    <option value="<%= p.getIdcrente() %>"><%= p.getNome() %></option>
                            <%  }
                               } %>
                        </select>
                    </div>

                    <div class="form-group" style="margin-top: 1rem;">
                        <label>Grau de Parentesco *</label>
                        <select name="tipoParentesco" class="form-control" required>
                            <option value="PAI_MAE">Pai / Mãe</option>
                            <option value="FILHO_A">Filho(a)</option>
                            <option value="CONJUGE">Cônjuge</option>
                            <option value="IRMAO_A">Irmão / Irmã</option>
                            <option value="TUTO_R">Tutor(a) / Encarregado(a)</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalParentesco')">Cancelar</button>
                    <button type="submit" class="btn-primary">Vincular Parentesco</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 3: DETALHES DO MEMBRO E LISTA DE PARENTES -->
    <div id="modalDetalhes" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-id-card"></i> Detalhes do Membro</h3>
                <button class="btn-close" onclick="closeModal('modalDetalhes')">&times;</button>
            </div>
            <div class="modal-body">
                <div class="details-summary">
                    <h4 id="detalheNome" style="color: var(--primary-blue); margin-bottom: 5px;">-</h4>
                    <p><strong>Telefone:</strong> <span id="detalheTelefone">-</span></p>
                    <p><strong>Estado Civil:</strong> <span id="detalheEstadoCivil">-</span></p>
                    <p><strong>Batismo:</strong> <span id="detalheBatismo">-</span></p>
                </div>

                <hr style="margin: 1rem 0; border: none; border-top: 1px solid var(--gray-border);">

                <h4 style="font-size: 0.95rem; margin-bottom: 0.8rem; color: var(--primary-blue);">
                    <i class="fa-solid fa-users-between-lines"></i> Parentes Vinculados
                </h4>
                <ul class="parent-list" id="detalheListaParentes">
                    <li class="empty-list">Selecione para carregar os parentes...</li>
                </ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('modalDetalhes')">Fechar</button>
            </div>
        </div>
    </div>

    <!-- MODAL 4: EDIÇÃO DE MEMBRO -->
    <div id="modalEdicao" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-pen-to-square"></i> Editar Membro</h3>
                <button class="btn-close" onclick="closeModal('modalEdicao')">&times;</button>
            </div>
            <form action="<%= request.getContextPath() %>/secretaria/membros" method="POST">
                <input type="hidden" name="acao" value="atualizar">
                <input type="hidden" id="editIdCrente" name="idcrente">

                <div class="modal-body grid-form">
                    <div class="form-group full-width">
                        <label>Nome Completo *</label>
                        <input type="text" id="editNome" name="nome" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Data de Nascimento *</label>
                        <input type="date" id="editDataNascimento" name="dataNascimento" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Telefone</label>
                        <input type="text" id="editTelefone" name="telefone" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Estado Civil *</label>
                        <select id="editEstadoCivil" name="estadoCivil" class="form-control" required>
                            <option value="Solteiro(a)">Solteiro(a)</option>
                            <option value="Casado(a)">Casado(a)</option>
                            <option value="Divorciado(a)">Divorciado(a)</option>
                            <option value="Viúvo(a)">Viúvo(a)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Status Batismo *</label>
                        <select id="editStatusBatismo" name="statusBatismo" class="form-control" required>
                            <option value="NÃO_BATIZADO">NÃO BATIZADO</option>
                            <option value="AGUARDANDO_BATISMO">AGUARDANDO BATISMO</option>
                            <option value="BATIZADO">BATIZADO</option>
                        </select>
                    </div>


                    <div class="form-group full-width">
                        <label>Endereço / Bairro</label>
                        <input type="text" id="editEndereco" name="endereco" class="form-control">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalEdicao')">Cancelar</button>
                    <button type="submit" class="btn-primary">Atualizar Dados</button>
                </div>
            </form>
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

        function abrirParentesco(id, nome) {
            document.getElementById('parentescoCrenteId').value = id;
            document.getElementById('parentescoCrenteNome').innerText = nome;
            openModal('modalParentesco');
        }

        function abrirEdicao(id, nome, dataNascimento, telefone, estadoCivil, statusBatismo, endereco, idGrupo) {
            // Verificação de segurança para garantir que os elementos existem no DOM
            const elId = document.getElementById('editIdCrente');
            const elNome = document.getElementById('editNome');
            const elData = document.getElementById('editDataNascimento');
            const elTel = document.getElementById('editTelefone');
            const elEstado = document.getElementById('editEstadoCivil');
            const elStatus = document.getElementById('editStatusBatismo');
            const elEnd = document.getElementById('editEndereco');
            const elGrupo = document.getElementById('editIdGrupo');

            if (elId) elId.value = id;
            if (elNome) elNome.value = nome;
            if (elData) elData.value = dataNascimento;
            if (elTel) elTel.value = telefone;
            if (elEstado) elEstado.value = estadoCivil;
            if (elStatus) elStatus.value = statusBatismo;
            if (elEnd) elEnd.value = endereco;
            if (elGrupo) elGrupo.value = (idGrupo && idGrupo !== 'null') ? idGrupo : '';

            openModal('modalEdicao');
        }

        function abrirDetalhes(id, nome, telefone, estadoCivil, statusBatismo) {
            document.getElementById('detalheNome').innerText = nome;
            document.getElementById('detalheTelefone').innerText = telefone;
            document.getElementById('detalheEstadoCivil').innerText = estadoCivil;
            document.getElementById('detalheBatismo').innerText = statusBatismo === 'BATIZADO' ? 'Batizado' : 'Aguardando Batismo';

            // Busca dinâmica via fetch dos parentes vinculados
            const parentesUl = document.getElementById('detalheListaParentes');
            parentesUl.innerHTML = '<li class="empty-list">Buscando parentes...</li>';

            fetch('<%= request.getContextPath() %>/secretaria/membros/parentes?id=' + id)
                .then(res => res.json())
                .then(data => {
                    parentesUl.innerHTML = '';
                    if (data && data.length > 0) {
                        data.forEach(p => {
                            parentesUl.innerHTML += `<li><i class="fa-solid fa-user-tag"></i> <strong>${p.nome}</strong> - <small>${p.grau}</small></li>`;
                        });
                    } else {
                        parentesUl.innerHTML = '<li class="empty-list">Nenhum parente vinculado a este membro.</li>';
                    }
                })
                .catch(() => {
                    parentesUl.innerHTML = '<li class="empty-list">Sem registros de parentesco no momento.</li>';
                });

            openModal('modalDetalhes');
        }

        // CORREÇÃO DOS FILTROS: Tabela de 5 colunas sem a exibição do ID
        // Coluna 0: Nome Completo | Coluna 1: Telefone | Coluna 2: Estado Civil | Coluna 3: Status Batismo
        function filtrarTabela() {
            const search = document.getElementById('filterSearch').value.toLowerCase().trim();
            const batismo = document.getElementById('filterBatismo').value.trim();
            const estadoCivil = document.getElementById('filterEstadoCivil').value.trim();
            const rows = document.querySelectorAll('#membersTable tbody tr');

            rows.forEach(row => {
                // Se for a linha informativa de "nenhum crente cadastrado", pula
                if (row.cells.length < 5) return;

                const textNome = row.cells[0].innerText.toLowerCase();
                const textTelefone = row.cells[1].innerText.toLowerCase();
                const textEstadoCivil = row.cells[2].innerText.trim();
                const textStatusBatismo = row.cells[3].innerText.trim();

                const matchSearch = search === "" || textNome.includes(search) || textTelefone.includes(search);
                const matchBatismo = batismo === "" ||
                    (batismo === "BATIZADO" && textStatusBatismo.includes("Batizado")) ||
                    (batismo === "AGUARDANDO_BATISMO" && textStatusBatismo.includes("Aguardando"));
                const matchEstadoCivil = estadoCivil === "" || textEstadoCivil === estadoCivil;

                if (matchSearch && matchBatismo && matchEstadoCivil) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>
</body>
</html>