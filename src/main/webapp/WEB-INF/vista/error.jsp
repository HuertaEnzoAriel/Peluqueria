<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>No se pudo completar la operación</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>No se pudo completar la operación</h1>
    <p class="sub">Revisá el mensaje, corregí lo que haga falta y probá de nuevo.</p>
    <div class="error"><c:out value="${error}"/></div>
    <a class="btn gris" href="javascript:history.back()">Volver</a>
    <a class="btn" href="${pageContext.request.contextPath}/index.jsp">Ir al inicio</a>
</main></body></html>