<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Cliente · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <h1>
                <c:choose>
                    <c:when test="${empty cliente.idcliente}">Nuevo cliente</c:when>
                    <c:otherwise>Editar cliente</c:otherwise>
                </c:choose>
            </h1>
            <p class="sub">Solo el nombre es obligatorio.</p>

            <form class="tarjeta" method="post" action="${pageContext.request.contextPath}/cliente/guardar">
                <c:if test="${not empty cliente.idcliente}">
                    <input type="hidden" name="idcliente" value="${cliente.idcliente}">
                </c:if>

                <div class="campo">
                    <label for="nombre">Nombre</label>
                    <input type="text" id="nombre" name="nombre" maxlength="60" required autofocus
                           value="<c:out value='${cliente.nombre}'/>">
                </div>

                <div class="campos-2">
                    <div class="campo">
                        <label for="telefono">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono" maxlength="20"
                               value="<c:out value='${cliente.telefono}'/>">
                    </div>
                    <div class="campo">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" maxlength="80"
                               value="<c:out value='${cliente.email}'/>">
                    </div>
                </div>

                <button type="submit" class="btn verde">Guardar</button>
                <a class="btn gris" href="${pageContext.request.contextPath}/cliente/listar">Cancelar</a>
            </form>
        </main>
    </body>
</html>