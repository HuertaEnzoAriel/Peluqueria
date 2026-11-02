<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Peluquería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <section class="portada">
        <h1>Agenda de turnos</h1>
        <p class="sub">Reservá turnos, cargá clientes y mantené al día los servicios y sus precios.</p>
        <a class="btn" href="${pageContext.request.contextPath}/turno/nuevo">Nuevo turno</a>
        <a class="btn gris" href="${pageContext.request.contextPath}/turno/listar">Ver turnos</a>
    </section>
    <div class="grid">
        <div class="tarjeta">
            <h2>Turnos</h2><p>Horarios reservados, su estado y el importe de cada uno.</p>
            <a class="btn" href="${pageContext.request.contextPath}/turno/listar">Ver listado</a>
            <a class="btn verde" href="${pageContext.request.contextPath}/turno/nuevo">Nuevo turno</a>
        </div>
        <div class="tarjeta">
            <h2>Clientes</h2><p>Datos de contacto de quienes se atienden en la peluquería.</p>
            <a class="btn" href="${pageContext.request.contextPath}/cliente/listar">Ver listado</a>
            <a class="btn verde" href="${pageContext.request.contextPath}/cliente/nuevo">Nuevo cliente</a>
        </div>
        <div class="tarjeta">
            <h2>Servicios</h2><p>Duración y precio de cada servicio que se ofrece.</p>
            <a class="btn" href="${pageContext.request.contextPath}/servicio/listar">Ver listado</a>
            <a class="btn verde" href="${pageContext.request.contextPath}/servicio/nuevo">Nuevo servicio</a>
        </div>
    </div>
</main></body></html>