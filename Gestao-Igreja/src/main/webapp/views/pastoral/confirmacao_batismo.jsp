<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Confirmação de Batismo - SIGEIGREJA</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/stylePastoral.css'/>">
    <style>
        .pastoral-container { padding: 20px; }
        .card { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .btn-primary { background-color: #0056b3; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary:hover { background-color: #003d80; }
        .status-badge { padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
        .badge-aguardando { background-color: #ffeba8; color: #856404; }
        .badge-batizado { background-color: #d4edda; color: #155724; }
        .alert-danger { background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .alert-success { background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
    </style>
</head>
<body class="app-layout">

    <jsp:include page="/includes/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="/includes/header.jsp" />

        <div class="dashboard-container">
            <h2>Módulo Pastoral - Confirmação de Batismo</h2>

            <c:if test="${param.sucesso == 'true'}">
                <div class="alert-success">Batismo(s) confirmado(s) com sucesso!</div>
            </c:if>
            <c:if test="${param.erro == 'nenhum_selecionado'}">
                <div class="alert-danger">Selecione ao menos um candidato para confirmar o batismo.</div>
            </c:if>

            <!-- Seleção de Cerimônia -->
            <div class="card">
                <h3>1. Selecionar Cerimônia de Batismo</h3>
                <form action="${pageContext.request.contextPath}/pastoral/confirmar-batismo" method="GET">
                    <label for="idBatismo">Cerimônias Agendadas:</label>
                    <select name="idBatismo" id="idBatismo" required onchange="this.form.submit()">
                        <option value="">-- Selecione uma Cerimônia --</option>
                        <c:forEach var="batismo" items="${batismos}">
                            <option value="${batismo.idbatismo}" ${batismo.idbatismo == idBatismoSelecionado ? 'selected' : ''}>
                                Data: ${batismo.data} | Local: ${batismo.local}
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <!-- Lista de Chamada Individual dos Candidatos -->
            <c:if test="${not empty candidatos}">
                <div class="card">
                    <h3>2. Chamada de Candidatos</h3>
                    <form action="${pageContext.request.contextPath}/pastoral/confirmar-batismo" method="POST">
                        <input type="hidden" name="idBatismo" value="${idBatismoSelecionado}" />

                        <table border="1" width="100%" style="border-collapse: collapse; text-align: left;">
                            <thead>
                                <tr style="background-color: #f2f2f2;">
                                    <th style="padding: 10px;">Presença</th>
                                    <th>Nome do Membro</th>
                                    <th>Status Atual</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cand" items="${candidatos}">
                                    <tr>
                                        <td style="padding: 10px; text-align: center;">
                                            <c:choose>
                                                <c:when test="${cand.statusBatismo == 'BATIZADO'}">
                                                    <input type="checkbox" checked disabled />
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="checkbox" name="membrosConfirmados" value="${cand.idcrente}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${cand.nome}</td>
                                        <td>
                                            <span class="status-badge ${cand.statusBatismo == 'BATIZADO' ? 'badge-batizado' : 'badge-aguardando'}">
                                                ${cand.statusBatismo}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <br>
                        <button type="submit" class="btn-primary">Concluir Batismo dos Selecionados</button>
                    </form>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>