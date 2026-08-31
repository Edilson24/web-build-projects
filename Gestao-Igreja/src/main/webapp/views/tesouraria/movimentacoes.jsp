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

    <!-- FontAwesome Ícones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/includes/header.jsp" />

    <div class="dashboard-container">
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="main-content" style="padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2><i class="fa-solid fa-wallet"></i> Lançamentos & Movimentações Financeiras</h2>
            </div>

            <!-- Barra de Ações Rápidas -->
            <div style="display: flex; gap: 12px; margin-bottom: 20px;">
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

            <!-- Tabela de Transações -->
            <div style="background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); overflow: hidden;">
                <table class="table" style="width: 100%; border-collapse: collapse;">
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
                            <tr style="border-bottom: 1px solid #edf2f7;">
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
                            <tr>
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
    </script>
</body>
</html>