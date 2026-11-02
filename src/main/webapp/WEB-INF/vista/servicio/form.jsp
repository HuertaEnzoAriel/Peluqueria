<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Servicio · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <h1>
                <c:choose>
                    <c:when test="${empty servicio.idservicio}">Nuevo servicio</c:when>
                    <c:otherwise>Editar servicio</c:otherwise>
                </c:choose>
            </h1>
            <p class="sub">La duración define cuánto tiempo ocupa cada turno en la agenda.</p>

            <form class="tarjeta" method="post" action="${pageContext.request.contextPath}/servicio/guardar">
                <c:if test="${not empty servicio.idservicio}">
                    <input type="hidden" name="idservicio" value="${servicio.idservicio}">
                </c:if>

                <div class="campo">
                    <label for="nombre">Nombre</label>
                    <input type="text" id="nombre" name="nombre" maxlength="60" required autofocus
                           value="<c:out value='${servicio.nombre}'/>">
                </div>

                <div class="campos-2">
                    <div class="campo">
                        <label for="duracion">Duración (minutos)</label>
                        <input type="number" id="duracion" name="duracion" min="1" step="1" required
                               value="<c:out value='${servicio.duracionMin}'/>">
                    </div>
                    <div class="campo">
                        <label for="precio">Precio ($)</label>
                        <input type="text" id="precio" name="precio" inputmode="decimal" required
                               placeholder="8000"
                               value="<c:out value='${servicio.precio}'/>">
                    </div>
                </div>

                <button type="submit" class="btn verde">Guardar</button>
                <a class="btn gris" href="${pageContext.request.contextPath}/ser