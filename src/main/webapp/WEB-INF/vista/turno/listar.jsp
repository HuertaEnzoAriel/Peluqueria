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
            <form class="filtro" id="form-filtro" method="get"
                  action="${pageContext.request.contextPath}/turno/listar">
                <span class="buscar">
                    <input type="text" id="q" name="q" maxlength="60" autocomplete="off"
                           placeholder="Buscar por cliente, servicio o estado"
                           aria-label="Buscar por cliente, servicio o estado"
                           value="<c:out value='${busqueda}'/>">
                    <button type="submit" class="btn gris lupa" aria-label="Buscar">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor"
                             stroke-width="2" stroke-linecap="round" aria-hidden="true">
                        <circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>
                        </svg>
                    </button>
                </span>

                <label for="fecha">Fecha</label>
                <input type="date" id="fecha" name="fecha" value="<c:out value='${fecha}'/>">

                <c:if test="${not empty busqueda or not empty fecha}">
                    <a class="btn gris" href="${pageContext.request.contextPath}/turno/listar">Quitar filtro</a>
                </c:if>
            </form>
            <br>
            <table>
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Cliente</th>
                        <th>Servicio</th>
                        <th>Estado</th>
                        <th>Cobrado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${lista}">
                        <tr>
                            <td><fmt:formatDate value="${t.fechaInicio}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${t.fechaInicio}" pattern="HH:mm"/> a <fmt:formatDate value="${t.fechaFin}" pattern="HH:mm"/></td>
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
                            <td colspan="7" class="vacio-msg">
                                <c:choose>
                                    <c:when test="${not empty busqueda or not empty fecha}">No hay turnos que coincidan con lo que buscaste.</c:when>
                                    <c:otherwise>Todavía no hay turnos. Reservá el primero con “Nuevo turno”.</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </main>
    </body>
    <script>
        (function () {
            var form = document.getElementById('form-filtro');
            var campo = document.getElementById('q');
            var fecha = document.getElementById('fecha');
            var espera;

            // Filtra solo cuando dejás de escribir
            campo.addEventListener('input', function () {
                clearTimeout(espera);
                espera = setTimeout(function () {
                    form.submit();
                }, 1300);
            });
            // Filtra apenas cambiás la fecha
            fecha.addEventListener('change', function () {
                form.submit();
            });

            // Tras recargar, vuelve el cursor al final del texto para seguir escribiendo
            if (campo.value) {
                campo.focus();
                campo.setSelectionRange(campo.value.length, campo.value.length);
            }
        })();
    </script>
</html>