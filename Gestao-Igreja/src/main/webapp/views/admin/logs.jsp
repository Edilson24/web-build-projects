<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Auditoria de Logs - SIGEIGREJA</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/styleAdmin.css'/>">
    <link rel="stylesheet" href="<c:url value='/assets/css/styleTesouraria.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/includes/header.jsp" />
    <div class="app-container" style="display: flex;">

        <!-- Sidebar Expansível -->
        <jsp:include page="/includes/sidebar.jsp" />

        <main class="main-content" style="flex: 1; padding: 24px; background-color: #f7fafc;">
            <h2><i class="fa-solid fa-scroll"></i> Registros de Auditoria e Logs do Sistema</h2>
            <p style="color: #718096; margin-bottom: 20px;">Histórico centralizado de operações realizadas pelos usuários nos módulos.</p>

            <!-- Painel de Filtros -->
            <article class="chart-card" style="background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/admin/logs" method="GET" style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap;">

                    <div style="flex: 1; min-width: 180px;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 5px;">Departamento</label>
                        <select name="departamento" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #cbd5e0;">
                            <option value="">-- Todos os Departamentos --</option>
                            <option value="SECRETARIA" ${paramDepto == 'SECRETARIA' ? 'selected' : ''}>Secretaria</option>
                            <option value="TESOURARIA" ${paramDepto == 'TESOURARIA' ? 'selected' : ''}>Tesouraria</option>
                            <option value="PASTORAL" ${paramDepto == 'PASTORAL' ? 'selected' : ''}>Pastoral</option>
                            <option value="SISTEMA" ${paramDepto == 'SISTEMA' ? 'selected' : ''}>Sistema</option>
                        </select>
                    </div>

                    <div style="flex: 1; min-width: 150px;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 5px;">Data Início</label>
                        <input type="date" name="dataInicio" value="${paramDataInicio}" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #cbd5e0;">
                    </div>

                    <div style="flex: 1; min-width: 150px;">
                        <label style="display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 5px;">Data Fim</label>
                        <input type="date" name="dataFim" value="${paramDataFim}" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #cbd5e0;">
                    </div>

                    <div style="display: flex; gap: 8px;">
                        <button type="submit" class="btn-pastoral" style="width: auto; padding: 9px 16px; background: #3182ce;">
                            <i class="fa-solid fa-filter"></i> Filtrar
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/logs" style="padding: 9px 16px; background: #e2e8f0; color: #4a5568; text-decoration: none; border-radius: 4px; font-size: 0.85rem; font-weight: 600;">
                            Limpar
                        </a>
                    </div>
                </form>
            </article>

            <!-- Tabela de Logs -->
            <article class="chart-card" style="background: #fff; padding: 20px; border-radius: 8px;">
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
                        <thead>
                            <tr style="background-color: #f7fafc; border-bottom: 2px solid #e2e8f0; text-align: left;">
                                <th style="padding: 12px;">Data / Hora</th>
                                <th style="padding: 12px;">Usuário</th>
                                <th style="padding: 12px;">Departamento</th>
                                <th style="padding: 12px;">Ação Realizada</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${listaLogs}">
                                <tr style="border-bottom: 1px solid #edf2f7;">
                                    <td style="padding: 12px; color: #4a5568; white-space: nowrap;">
                                        <fmt:formatDate value="${log.dataHora}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </td>
                                    <td style="padding: 12px; font-weight: 600; color: #2d3748;">
                                        ${log.nomeUsuario}
                                    </td>
                                    <td style="padding: 12px;">
                                        <span style="padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 700;
                                            ${log.departamento == 'SECRETARIA' ? 'background: #ebf8ff; color: #2b6cb0;' : ''}
                                            ${log.departamento == 'TESOURARIA' ? 'background: #f0fff4; color: #2f855a;' : ''}
                                            ${log.departamento == 'PASTORAL' ? 'background: #faf5ff; color: #6b46c1;' : ''}
                                            ${log.departamento == 'SISTEMA' ? 'background: #fff5f5; color: #c53030;' : ''}">
                                            ${log.departamento}
                                        </span>
                                    </td>
                                    <td style="padding: 12px; color: #2d3748;">
                                        ${log.acao}
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaLogs}">
                                <tr>
                                    <td colspan="4" style="padding: 20px; text-align: center; color: #a0aec0;">
                                        Nenhum registro de auditoria encontrado para os filtros selecionados.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </article>

        </main>
    </div>
</body>
</html>