<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lançamentos Financeiros - SIGEIGREJA</title>

    <!-- CSS Geral e da Tesouraria -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styleTesouraria.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styleSecretaria.css">

    <!-- FontAwesome Ícones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Painel de Filtros */
        .filter-card {
            background: white;
            border-radius: 8px;
            padding: 16px 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            align-items: end;
        }

        .summary-card {
            display: flex;
            gap: 16px;
            margin-bottom: 16px;
        }

        .summary-box {
            flex: 1;
            padding: 12px 16px;
            border-radius: 8px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .summary-box small {
            font-weight: 600;
            color: #718096;
            text-transform: uppercase;
            font-size: 0.75rem;
        }

        .summary-box h3 {
            margin: 4px 0 0 0;
            font-size: 1.25rem;
        }

        /* Cabeçalho de Impressão Exclusivo (Oculto na tela) */
        .print-only-header {
            display: none;
        }

        /* ==========================================
           REGRAS CSS PARA IMPRESSÃO (PRINT MEDIA)
           ========================================== */
        @media print {
            /* Ocultar elementos de navegação e controles */
            header,
            .dashboard-container > aside,
            .sidebar,
            .no-print,
            .filter-card,
            .modal-overlay,
            .btn-close {
                display: none !important;
            }

            body {
                background: white !important;
                color: black !important;
                margin: 0;
                padding: 0;
            }

            .dashboard-container {
                display: block !important;
            }

            .main-content {
                padding: 0 !important;
                margin: 0 !important;
                width: 100% !important;
            }

            /* Mostrar cabeçalho do relatório oficial */
            .print-only-header {
                display: block !important;
                margin-bottom: 20px;
                border-bottom: 2px solid #2d3748;
                padding-bottom: 10px;
            }

            .print-only-header h1 {
                margin: 0 0 4px 0;
                font-size: 1.5rem;
                color: #1a202c;
            }

            .print-only-header p {
                margin: 0;
                font-size: 0.875rem;
                color: #4a5568;
            }

            /* Ocultar linhas filtradas (escondidas) durante a impressão */
            tr[style*="display: none"] {
                display: none !important;
            }

            /* Estilização da Tabela para Impressão */
            .table-container {
                box-shadow: none !important;
                border: 1px solid #cbd5e0 !important;
            }

            table.table {
                width: 100% !important;
                border-collapse: collapse !important;
                font-size: 11pt;
            }

            table.table th, table.table td {
                padding: 8px 10px !important;
                border-bottom: 1px solid #e2e8f0 !important;
            }

            table.table th {
                background-color: #f7fafc !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .summary-card {
                margin-top: 15px;
            }

            .summary-box {
                border: 1px solid #cbd5e0 !important;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="dashboard-container">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="main-content" style="padding: 20px;">

            <!-- Cabeçalho visível somente na impressão -->
            <div class="print-only-header">
                <h1>SIGEIGREJA - RELATÓRIO EXTRATO FINANCEIRO</h1>
                <p><strong>Emissão:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/></p>
            </div>

            <div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2><i class="fa-solid fa-wallet"></i> Lançamentos & Movimentações Financeiras</h2>
            </div>

            <!-- Barra de Ações Rápidas -->
            <div class="no-print" style="display: flex; gap: 12px; margin-bottom: 20px;">
                <button class="btn-primary" style="background: #2f855a; color: white; border: none; padding: 10px 16px; border-radius: 5px; cursor: pointer;" onclick="openModal('modalEntrada')">
                    <i class="fa-solid fa-plus-circle"></i> Nova Entrada
                </button>
                <button class="btn-danger" style="background: #c53030; color: white; border: none; padding: 10px 16px; border-radius: 5px; cursor: pointer;" onclick="openModal('modalSaida')">
                    <i class="fa-solid fa-minus-circle"></i> Registrar Saída
                </button>
                <button class="btn-secondary" style="padding: 10px 16px; border-radius: 5px; cursor: pointer;" onclick="window.print()">
                    <i class="fa-solid fa-print"></i> Imprimir Extrato
                </button>
            </div>

            <!-- PAINEL DE FILTROS (Não aparece na impressão) -->
            <div class="filter-card no-print" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px;">
                <div class="filter-grid">
                    <div class="form-group">
                        <label><i class="fa-solid fa-magnifying-glass"></i> Pesquisar</label>
                        <input type="text" id="filterBusca" class="form-control" placeholder="Contribuidor, nota..." oninput="filtrarTabela()">
                    </div>

                    <div class="form-group">
                        <label>Tipo</label>
                        <select id="filterTipo" class="form-control" onchange="filtrarTabela()">
                            <option value="">Todos</option>
                            <option value="ENTRADA">Entrada</option>
                            <option value="SAIDA">Saída</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Categoria</label>
                        <select id="filterCategoria" class="form-control" onchange="filtrarTabela()">
                            <option value="">Todas</option>
                            <option value="DIZIMO">Dízimo</option>
                            <option value="ACAO_DE_GRACA">Ação de Graças</option>
                            <option value="OFERTORIO_COLETIVO">Ofertório Coletivo</option>
                            <option value="DESPESA">Despesa</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Data Inicial</label>
                        <input type="date" id="filterDataInicio" class="form-control" onchange="filtrarTabela()">
                    </div>

                    <div class="form-group">
                        <label>Data Final</label>
                        <input type="date" id="filterDataFim" class="form-control" onchange="filtrarTabela()">
                    </div>

                    <div class="form-group">
                        <button type="button" class="btn-secondary" style="width: 100%;" onclick="limparFiltros()">
                            <i class="fa-solid fa-eraser"></i> Limpar
                        </button>
                    </div>
                </div>
            </div>

            <!-- Resumo Financeiro Dinâmico -->
            <div class="summary-card">
                <div class="summary-box" style="border-left: 4px solid #2f855a;">
                    <small>Total Entradas (Filtradas)</small>
                    <h3 id="totalEntradasDisplay" style="color: #2f855a;">MT 0.00</h3>
                </div>
                <div class="summary-box" style="border-left: 4px solid #c53030;">
                    <small>Total Saídas (Filtradas)</small>
                    <h3 id="totalSaidasDisplay" style="color: #c53030;">MT 0.00</h3>
                </div>
                <div class="summary-box" style="border-left: 4px solid #3182ce;">
                    <small>Saldo do Período</small>
                    <h3 id="saldoDisplay" style="color: #2b6cb0;">MT 0.00</h3>
                </div>
            </div>

            <!-- Tabela de Transações -->
            <div class="table-container" style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); overflow: hidden;">
                <table class="table" style="width: 100%; border-collapse: collapse;" id="tabelaMovimentacoes">
                    <thead style="background: #f7fafc; border-bottom: 2px solid #e2e8f0; text-align: left;">
                        <tr>
                            <th style="padding: 12px;">Data</th>
                            <th style="padding: 12px;">Tipo</th>
                            <th style="padding: 12px;">Categoria</th>
                            <th style="padding: 12px;">Contribuidor / Origem</th>
                            <th style="padding: 12px;">Valor</th>
                            <th style="padding: 12px;">Nota / Observação</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="mov" items="${listaMovimentacoes}">
                            <tr style="border-bottom: 1px solid #edf2f7;"
                                data-tipo="${mov.tipoMovimentacao}"
                                data-categoria="${mov.categoria}"
                                data-data="<fmt:formatDate value='${mov.data}' pattern='yyyy-MM-dd'/>"
                                data-valor="${mov.valor}">
                                <td style="padding: 12px;"><fmt:formatDate value="${mov.data}" pattern="dd/MM/yyyy"/></td>
                                <td style="padding: 12px;">
                                    <span style="padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; color: white; background: ${mov.tipoMovimentacao == 'ENTRADA' ? '#2f855a' : '#c53030'};">
                                        ${mov.tipoMovimentacao}
                                    </span>
                                </td>
                                <td style="padding: 12px;">${mov.categoria}</td>
                                <td style="padding: 12px;">${mov.nomeContribuidor}</td>
                                <td style="padding: 12px; font-weight: bold;">
                                    <fmt:formatNumber value="${mov.valor}" type="currency" currencySymbol="MT " />
                                </td>
                                <td style="padding: 12px;">${mov.observacaoNota != null ? mov.observacaoNota : '-'}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaMovimentacoes}">
                            <tr id="rowEmpty">
                                <td colspan="6" style="text-align: center; padding: 20px; color: #718096;">Nenhuma movimentação registrada.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- MODAL 1: REGISTRAR ENTRADA -->
    <div id="modalEntrada" class="modal-overlay" style="display: none;">
        <div class="modal-box">
            <div class="modal-header">
                <h3><i class="fa-solid fa-plus-circle"></i> Registrar Entrada Financeira</h3>
                <button type="button" class="btn-close" onclick="closeModal('modalEntrada')">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/tesouraria/movimentacoes" method="POST">
                <input type="hidden" name="acao" value="cadastrarEntrada">

                <div class="modal-body grid-form">

                    <div class="form-group full-width">
                        <label>Categoria *</label>
                        <select name="categoria" id="selectCategoria" class="form-control" onchange="alternarCamposEntrada()" required>
                            <option value="DIZIMO">Dízimo Individual</option>
                            <option value="ACAO_DE_GRACA">Ação de Graças</option>
                            <option value="OFERTORIO_COLETIVO">Ofertório Coletivo (Culto)</option>
                        </select>
                    </div>

                    <div class="form-group full-width" id="secaoTipoContribuidor">
                        <label>Tipo de Contribuidor *</label>
                        <select name="tipoContribuidor" id="selectTipoContribuidor" class="form-control" onchange="alternarContribuidor()">
                            <option value="MEMBRO">Membro da Igreja</option>
                            <option value="VISITANTE_INDIVIDUAL">Visitante Individual</option>
                            <option value="VISITANTE_GRUPO">Grupo Visitante</option>
                            <option value="ANONIMO">Anônimo</option>
                        </select>
                    </div>

                    <div class="form-group full-width" id="campoMembro">
                        <label>Selecione o Membro *</label>
                        <select name="idcrente" class="form-control">
                            <c:forEach var="membro" items="${listaMembros}">
                                <option value="${membro.idcrente}">${membro.nome}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full-width" id="campoExterno" style="display: none;">
                        <label>Nome do Visitante / Grupo *</label>
                        <input type="text" name="nomeContribuidorExterno" class="form-control" placeholder="Ex: João Visitante / Coro de Nacala">
                    </div>

                    <div class="form-group">
                        <label>Valor (MT) *</label>
                        <input type="number" step="0.01" name="valor" class="form-control" required placeholder="0.00">
                    </div>

                    <div class="form-group">
                        <label>Data *</label>
                        <input type="date" name="data" class="form-control" required>
                    </div>

                    <div class="form-group full-width" id="campoNotaAcaoGraca" style="display: none;">
                        <label>Ocasião / Motivo da Ação de Graça</label>
                        <input type="text" name="observacaoNota" class="form-control" placeholder="Ex: Aniversário, Conquista">
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalEntrada')">Cancelar</button>
                    <button type="submit" class="btn-primary" style="background: #2f855a; border-color: #2f855a;">Salvar Entrada</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL 2: REGISTRAR SAÍDA -->
    <div id="modalSaida" class="modal-overlay" style="display: none;">
        <div class="modal-box">
            <div class="modal-header">
                <h3 style="color: #c53030;"><i class="fa-solid fa-minus-circle"></i> Registrar Saída (Despesa)</h3>
                <button type="button" class="btn-close" onclick="closeModal('modalSaida')">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/tesouraria/movimentacoes" method="POST">
                <input type="hidden" name="acao" value="cadastrarSaida">

                <div class="modal-body grid-form">

                    <div class="form-group">
                        <label>Valor (MT) *</label>
                        <input type="number" step="0.01" name="valor" class="form-control" required placeholder="0.00">
                    </div>

                    <div class="form-group">
                        <label>Data *</label>
                        <input type="date" name="data" class="form-control" required>
                    </div>

                    <div class="form-group full-width">
                        <label>Nota / Finalidade Obrigatória *</label>
                        <textarea name="observacaoNota" class="form-control" rows="3" required placeholder="Explicar a finalidade da retirada..."></textarea>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal('modalSaida')">Cancelar</button>
                    <button type="submit" class="btn-danger" style="background: #c53030; border-color: #c53030; color: white;">Confirmar Saída</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    function openModal(id) {
        const modal = document.getElementById(id);
        if (modal) {
            modal.style.display = 'flex';
            modal.classList.add('active', 'show');
        }
    }

    function closeModal(id) {
        const modal = document.getElementById(id);
        if (modal) {
            modal.style.display = 'none';
            modal.classList.remove('active', 'show');
        }
    }

    function alternarCamposEntrada() {
        const cat = document.getElementById('selectCategoria').value;
        const secaoTipo = document.getElementById('secaoTipoContribuidor');
        const campoNota = document.getElementById('campoNotaAcaoGraca');

        if (cat === 'OFERTORIO_COLETIVO') {
            secaoTipo.style.display = 'none';
            document.getElementById('campoMembro').style.display = 'none';
            document.getElementById('campoExterno').style.display = 'none';
        } else {
            secaoTipo.style.display = 'block';
            alternarContribuidor();
        }

        campoNota.style.display = (cat === 'ACAO_DE_GRACA') ? 'block' : 'none';
    }

    function alternarContribuidor() {
        const tipo = document.getElementById('selectTipoContribuidor').value;
        document.getElementById('campoMembro').style.display = (tipo === 'MEMBRO') ? 'block' : 'none';
        document.getElementById('campoExterno').style.display = (tipo === 'VISITANTE_INDIVIDUAL' || tipo === 'VISITANTE_GRUPO') ? 'block' : 'none';
    }

    /* ==========================================
       LÓGICA DE FILTRAGEM DE DADOS EM TEMPO REAL
       ========================================== */
    function filtrarTabela() {
        const termoBusca = document.getElementById('filterBusca').value.toLowerCase();
        const tipoFiltro = document.getElementById('filterTipo').value;
        const categoriaFiltro = document.getElementById('filterCategoria').value;
        const dataInicio = document.getElementById('filterDataInicio').value;
        const dataFim = document.getElementById('filterDataFim').value;

        const linhas = document.querySelectorAll('#tabelaMovimentacoes tbody tr:not(#rowEmpty)');

        let totalEntradas = 0;
        let totalSaidas = 0;

        linhas.forEach(linha => {
            const tipo = linha.getAttribute('data-tipo');
            const categoria = linha.getAttribute('data-categoria');
            const dataRow = linha.getAttribute('data-data');
            const valorRow = parseFloat(linha.getAttribute('data-valor')) || 0;
            const conteudoTexto = linha.innerText.toLowerCase();

            let exibe = true;

            // Filtro por termo de busca
            if (termoBusca && !conteudoTexto.includes(termoBusca)) {
                exibe = false;
            }

            // Filtro por tipo (ENTRADA / SAIDA)
            if (tipoFiltro && tipo !== tipoFiltro) {
                exibe = false;
            }

            // Filtro por categoria
            if (categoriaFiltro && categoria !== categoriaFiltro) {
                exibe = false;
            }

            // Filtro por intervalo de datas
            if (dataInicio && dataRow < dataInicio) {
                exibe = false;
            }
            if (dataFim && dataRow > dataFim) {
                exibe = false;
            }

            // Aplica a visibilidade
            if (exibe) {
                linha.style.display = '';
                if (tipo === 'ENTRADA') {
                    totalEntradas += valorRow;
                } else if (tipo === 'SAIDA') {
                    totalSaidas += valorRow;
                }
            } else {
                linha.style.display = 'none';
            }
        });

        // Atualiza os resumos em tela
        const saldo = totalEntradas - totalSaidas;
        document.getElementById('totalEntradasDisplay').innerText = formatarMoeda(totalEntradas);
        document.getElementById('totalSaidasDisplay').innerText = formatarMoeda(totalSaidas);
        document.getElementById('saldoDisplay').innerText = formatarMoeda(saldo);
    }

    function limparFiltros() {
        document.getElementById('filterBusca').value = '';
        document.getElementById('filterTipo').value = '';
        document.getElementById('filterCategoria').value = '';
        document.getElementById('filterDataInicio').value = '';
        document.getElementById('filterDataFim').value = '';
        filtrarTabela();
    }

    function formatarMoeda(valor) {
        return 'MT ' + valor.toLocaleString('pt-MZ', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    // Executa a filtragem inicial ao carregar a página para calcular totais
    document.addEventListener('DOMContentLoaded', filtrarTabela);
    </script>
</body>
</html>