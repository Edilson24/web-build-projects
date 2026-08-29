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
                        <option value="NÃO_BATIZADO">Não Batizado</option>
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

            <!-- TABELA DE DADOS -->
            <div class="table-card">
                <table class="data-table" id="membersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
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
                                <td>#<%= m.getIdcrente() %></td>
                                <td><strong><%= m.getNome() %></strong></td>
                                <td><%= m.getTelefone() != null ? m.getTelefone() : "-" %></td>
                                <td><%= m.getEstadoCivil() %></td>
                                <td>
                                    <% if ("BATIZADO".equals(m.getStatusBatismo())) { %>
                                        <span class="badge badge-success"><i class="fa-solid fa-water"></i> Batizado</span>
                                    <% } else if ("AGUARDANDO_BATISMO".equals(m.getStatusBatismo())) { %>
                                        <span class="badge badge-warning"><i class="fa-solid fa-clock"></i> Aguardando</span>
                                    <% } else { %>
                                        <span class="badge badge-danger"><i class="fa-solid fa-circle-xmark"></i> Não Batizado</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <button class="btn-icon" title="Vincular Parentesco" onclick="abrirParentesco(<%= m.getIdcrente() %>, '<%= m.getNome() %>')">
                                        <i class="fa-solid fa-people-arrows"></i>
                                    </button>
                                </td>
                            </tr>
                        <%      }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" class="text-center">Nenhum crente cadastrado no sistema.</td>
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
            <form action="<%= request.getContextPath() %>/secretaria/membros/salvar" method="POST">
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
                    <div class="form-group">
                        <label>Status Batismo *</label>
                        <select name="statusBatismo" class="form-control" required>
                            <option value="NÃO_BATIZADO">NÃO BATIZADO</option>
                            <option value="AGUARDANDO_BATISMO">AGUARDANDO BATISMO</option>
                            <option value="BATIZADO">BATIZADO</option>
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
            <form action="<%= request.getContextPath() %>/secretaria/membros/parentesco" method="POST">
                <input type="hidden" id="parentescoCrenteId" name="idCrentePrincipal">
                <div class="modal-body">
                    <p class="target-member-info">Membro: <strong id="parentescoCrenteNome">-</strong></p>
                    <div class="form-group" style="margin-top: 1rem;">
                        <label>Selecione o Parente (Crente) *</label>
                        <select name="idParente" class="form-control" required>
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
                        <select name="grauParentesco" class="form-control" required>
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

        // Filtro em tempo real na tabela por Javascript
        function filtrarTabela() {
            const search = document.getElementById('filterSearch').value.toLowerCase();
            const batismo = document.getElementById('filterBatismo').value;
            const estadoCivil = document.getElementById('filterEstadoCivil').value;
            const rows = document.querySelectorAll('#membersTable tbody tr');

            rows.forEach(row => {
                if (row.cells.length < 5) return; // Ignora linha de "nenhum registro"
                const nomeTel = row.cells[1].innerText.toLowerCase() + " " + row.cells[2].innerText.toLowerCase();
                const textEstadoCivil = row.cells[3].innerText.trim();
                const textBatismo = row.cells[4].innerText.trim();

                const matchSearch = nomeTel.includes(search);
                const matchBatismo = batismo === "" || textBatismo.toUpperCase().includes(batismo.replace('_', ' '));
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