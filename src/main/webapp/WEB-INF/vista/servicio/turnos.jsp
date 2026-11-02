<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><c:out value="${servicio.nombre}"/> · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <div class="barra">
                <div>
                    <h1><c:out value="${servicio.nombre}"/></h1>
                    <p class="sub">
                        <c:out value="${servicio.duracionMin}"/> min ·
                        $ <fmt:formatNumber value="${servicio.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </p>
                </div>
                <a class="btn verde" href="${pageContext.request.contextPath}/turno/nuevo">Nuevo turno</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Fecha y hora</th>
                        <th>Cliente</th>
                        <th>Estado</th>
                        <th>Cobrado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${lista}">
                        <tr>
                            <td><fmt:formatDate value="${t.fechaInicio}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td><c:out value="${t.clienteIdcliente.nombre}"/></td>
                            <td><span class="chip estado ${t.estado}"><c:out value="${t.estado}"/></span></td>
                            <td class="num">$ <fmt:formatNumber value="${t.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty lista}">
                        <tr>
                            <td colspan="4" class="vacio-msg">Este servicio todavía no tiene turnos.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </main>
    </body>
</html>