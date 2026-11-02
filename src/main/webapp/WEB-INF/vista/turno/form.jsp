<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Turno · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <h1>
                <c:choose>
                    <c:when test="${empty turno.idturno}">Nuevo turno</c:when>
                    <c:otherwise>Editar turno</c:otherwise>
                </c:choose>
            </h1>
            <p class="sub">La hora de fin se calcula con la duración del servicio. No se aceptan turnos que se superpongan.</p>

            <form class="tarjeta" method="post" action="${pageContext.request.contextPath}/turno/guardar">
                <c:if test="${not empty turno.idturno}">
                    <input type="hidden" name="idturno" value="${turno.idturno}">
                </c:if>

                <div class="campos-2">
                    <div class="campo">
                        <label for="cliente">Cliente</label>
                        <select id="cliente" name="cliente" required>
                            <option value="">Elegí un cliente</option>
                            <c:forEach var="cli" items="${clientes}">
                                <option value="${cli.idcliente}"
                                        ${cli.idcliente == turno.clienteIdcliente.idcliente ? 'selected' : ''}>
                                    <c:out value="${cli.nombre}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="campo">
                        <label for="servicio">Servicio</label>
                        <select id="servicio" name="servicio" required>
                            <option value="">Elegí un servicio</option>
                            <c:forEach var="s" items="${servicios}">
                                <option value="${s.idservicio}"
                                        ${s.idservicio == turno.servicioIdservicio.idservicio ? 'selected' : ''}>
                                    <c:out value="${s.nombre}"/> (<c:out value="${s.duracionMin}"/> min)
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="campos-2">
                    <div class="campo">
                        <label for="inicio">Fecha y hora de inicio</label>
                        <input type="datetime-local" id="inicio" name="inicio" required
                               value="<fmt:formatDate value='${turno.fechaInicio}' pattern="yyyy-MM-dd'T'HH:mm"/>">
                    </div>
                    <div class="campo">
                        <label for="estado">Estado</label>
                        <select id="estado" name="estado">
                            <c:forEach var="e" items="${estados}">
                                <option value="${e}" ${e == turno.estado ? 'selected' : ''}>
                                    <c:out value="${e}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="campo">
                    <label for="precio">Precio cobrado ($)</label>
                    <input type="text" id="precio" name="precio" inputmode="decimal"
                           placeholder="Vacío = precio del servicio"
                           value="<c:out value='${turno.precio}'/>">
                </div>

                <button type="submit" class="btn verde">Guardar</button>
                <a class="btn gris" href="${pageContext.request.contextPath}/turno/listar">Cancelar</a>
            </form>
        </main>
    </body>
</html>