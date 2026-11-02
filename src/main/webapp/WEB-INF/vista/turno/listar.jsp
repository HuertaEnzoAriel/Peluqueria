<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Turnos · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <div class="barra">
                <div>
                    <h1>Turnos</h1>
                    <p class="sub">Agenda ordenada por fecha y hora.</p>
                </div>
                <a class="btn verde" href="${pageContext.request.contextPath}/turno/nuevo">Nuevo turno</a>
            </div>
            <form class="filtro" method="get" action="${pageContext.request.contextPath}/turno/listar">
                <label for="estado">Estado</label>
                <select id="estado" name="estado">
                    <option value="">Todos los estados</option>
                    <c:forEach var="e" items="${estados}">
                        <option value="${e}" ${e == estadoFiltro ? 'selected' : ''}>
                            <c:out value="${e}"/>
                        </option>
                    </c:forEach>
                </select>
                <br>
                <button type="submit" class="btn">Filtrar</button>
                <c:if test="${not empty estadoFiltro}">
                    <a class="btn gris" href="${pageContext.request.contextPath}/turno/listar">Quitar filtro</a>
                </c:if>
            </form>
            <br>
            <table>
                <thead>
                    <tr>
                        <th>Fecha y hora</th>
                        <th>Cliente</th>
                        <th>Servicio</th>
                        <th>Estado</th>
                        <th>Cobrado</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${lista}">
                        <tr>
                            <td>
                                <fmt:formatDate value="${t.fechaInicio}" pattern="dd/MM/yyyy HH:mm"/>
                                a <fmt:formatDate value="${t.fechaFin}" pattern="HH:mm"/>
                            </td>
                            <td><c:out value="${t.clienteIdcliente.nombre}"/></td>
                            <td><c:out value="${t.servicioIdservicio.nombre}"/></td>
                            <td><span class="chip estado ${t.estado}"><c:out value="${t.estado}"/></span></td>
                            <td class="num">$ <fmt:formatNumber value="${t.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="acciones">
                                <a class="btn gris chico" href="${pageContext.request.contextPath}/turno/editar?id=${t.idturno}">Editar</a>
                                <form method="post" action="${pageContext.request.contextPath}/turno/eliminar"
                                      onsubmit="return confirm('¿Eliminar este turno?');">
                                    <input type="hidden" name="id" value="${t.idturno}">
                                    <button type="submit" class="btn rojo chico">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty lista}">
                        <tr>
                            <td colspan="6" class="vacio-msg">
                                <c:choose>
                                    <c:when test="${not empty estadoFiltro}">No hay turnos con ese estado.</c:when>
                                    <c:otherwise>Todavía no hay turnos. Reservá el primero con “Nuevo turno”.</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </main>
    </body>
</html>