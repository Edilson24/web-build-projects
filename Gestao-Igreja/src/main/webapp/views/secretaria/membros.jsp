<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Crente" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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
    <link rel="stylesheet" href="<c:url value='/assets/css/styleAdmin.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/styleSecretaria.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/styleTesouraria.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body class="dashboard-body">
    <jsp:include page="/includes/header.jsp" />
    <div class="dashboard-container">
        <jsp:include page="/includes/sidebar.jsp" />

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

    <!-- MODAL 1: CADASTRO DE MEMBRO / PASTOR -->
    <div id="modalCadastro" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h3 id="modalCadastroTitulo"><i class="fa-solid fa-user-plus"></i> Cadastrar Novo Membro</h3>
                <button class="btn-close" onclick="closeModal('modalCadastro')">&times;</button>
            </div>

            <form action="<%= request.getContextPath() %>/secretaria/membros" method="POST" id="formCadastroMembro">
                <input type="hidden" name="acao" id="inputAcao" value="cadastrar">
                <input type="hidden" name="tipoCadastro" id="tipoCadastro" value="MEMBRO">

                <div class="modal-body grid-form">

                    <!-- Toggle Button to Switch between Membro and Pastor -->
                    <div class="form-group full-width" style="display: flex; gap: 10px; align-items: center; background: #f8f9fa; padding: 10px; border-radius: 6px;">
                        <label style="margin: 0; font-weight: bold;">Tipo de Cadastro:</label>
                        <button type="button" id="btnTipoMembro" class="btn-primary" style="padding: 5px 15px;" onclick="selecionarTipoCadastro('MEMBRO')">Membro Comum</button>
                        <button type="button" id="btnTipoPastor" class="btn-secondary" style="padding: 5px 15px;" onclick="selecionarTipoCadastro('PASTOR')"><i class="fa-solid fa-user-tie"></i> Pastor</button>
                    </div>

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
                        <label>Data de Entrada *</label>
                        <input type="date" name="dataEntrada" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Grupo *</label>
                        <select name="idGrupo" class="form-control" required>
                            <option value="1">Jovens</option>
                            <option value="2">Mulheres</option>
                            <option value="3">Homens</option>
                            <option value="4">Geral</option>
                        </select>
                    </div>

                    <div class="form-group full-width">
                        <label>Endereço / Bairro</label>
                        <input type="text" name="endereco" class="form-control" placeholder="Ex: Bairro Central, Nacala-Porto">
                    </div>

                    <!-- Campos Exclusivos para Pastor (Ocultos por Padrão) -->
                    <div id="secaoContaPastor" class="full-width" style="display: none; border-top: 1px solid #ddd; padding-top: 10px; margin-top: 10px;">
                        <h4 style="margin-bottom: 10px; color: #1a365d;"><i class="fa-solid fa-key"></i> Conta de Acesso ao Sistema (Pastor)</h4>
                        <div class="grid-form">
                            <div class="form-group">
                                <label>E-mail (Login) *</label>
                                <input type="email" name="email" id="inputEmailPastor" class="form-control" placeholder="pastor@sigeigreja.org">
                            </div>
                            <div class="form-group">
                                <label>Senha Inicial *</label>
                                <input type="password" name="senha" id="inputSenhaPastor" class="form-control" placeholder="******">
                            </div>
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalCadastro')">Cancelar</button>
                    <button type="submit" class="btn-primary">Salvar Cadastramento</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    function selecionarTipoCadastro(tipo) {
        const btnMembro = document.getElementById('btnTipoMembro');
        const btnPastor = document.getElementById('btnTipoPastor');
        const secaoPastor = document.getElementById('secaoContaPastor');
        const tipoCadastro = document.getElementById('tipoCadastro');
        const inputEmail = document.getElementById('inputEmailPastor');
        const inputSenha = document.getElementById('inputSenhaPastor');
        const titulo = document.getElementById('modalCadastroTitulo');

        tipoCadastro.value = tipo;

        if (tipo === 'PASTOR') {
            btnMembro.className = 'btn-secondary';
            btnPastor.className = 'btn-primary';
            secaoPastor.style.display = 'block';
            inputEmail.required = true;
            inputSenha.required = true;
            titulo.innerHTML = '<i class="fa-solid fa-user-tie"></i> Cadastrar Novo Pastor';
        } else {
            btnMembro.className = 'btn-primary';
            btnPastor.className = 'btn-secondary';
            secaoPastor.style.display = 'none';
            inputEmail.required = false;
            inputSenha.required = false;
            titulo.innerHTML = '<i class="fa-solid fa-user-plus"></i> Cadastrar Novo Membro';
        }
    }
    </script>

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

    <!-- MODAL 5: CADASTRO DE PASTOR -->
    <div id="modalCadastroPastor" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fa-solid fa-user-tie"></i> Cadastrar Novo Pastor</h3>
                <span class="close-modal" onclick="fecharModal('modalCadastroPastor')">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/secretaria/pastores/cadastrar" method="POST">
                <div class="modal-body">
                    <h4>Dados Pessoais</h4>
                    <div class="form-group">
                        <label>Nome Completo *</label>
                        <input type="text" name="nome" required class="form-control">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Data de Nascimento *</label>
                            <input type="date" name="dataNascimento" required class="form-control">
                        </div>
                        <div class="form-group">
                            <label>Telefone</label>
                            <input type="text" name="telefone" class="form-control">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Estado Civil *</label>
                            <select name="estadoCivil" required class="form-control">
                                <option value="Casado(a)">Casado(a)</option>
                                <option value="Solteiro(a)">Solteiro(a)</option>
                                <option value="Divorciado(a)">Divorciado(a)</option>
                                <option value="Viúvo(a)">Viúvo(a)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Data de Entrada *</label>
                            <input type="date" name="dataEntrada" required class="form-control">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Grupo Padrão *</label>
                        <select name="idGrupo" required class="form-control">
                            <!-- Iterar grupos disponíveis ou colocar o id do grupo Geral/Homens -->
                            <option value="4">Geral</option>
                            <option value="3">Homens</option>
                        </select>
                    </div>

                    <hr style="margin: 1.5rem 0; border: 0; border-top: 1px solid #eee;">
                    <h4>Conta de Acesso ao Sistema</h4>

                    <div class="form-group">
                        <label>E-mail (Login) *</label>
                        <input type="email" name="email" required class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Senha Inicial *</label>
                        <input type="password" name="senha" required class="form-control">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="fecharModal('modalCadastroPastor')">Cancelar</button>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Salvar Pastor</button>
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