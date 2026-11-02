<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Servicios · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <div class="barra">
                <div>
                    <h1>Servicios</h1>
                    <p class="sub">Duración y precio de lo que ofrece la peluquería.</p>
                </div>
                <a class="btn verde" href="${pageContext.request.contextPath}/servicio/nuevo">Nuevo servicio</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Servicio</th>
                        <th>Duración</th>
                        <th>Precio</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${lista}">
                        <tr>
                            <td><c:out value="${s.nombre}"/></td>
                            <td><c:out value="${s.duracionMin}"/> min</td>
                            <td class="num">$ <fmt:formatNumber value="${s.precio}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="acciones">
                                <a class="btn gris chico" href="${pageContext.request.contextPath}/servicio/editar?id=${s.idservicio}">Editar</a>
                                <form method="post" action="${pageContext.request.contextPath}/servicio/eliminar"
                                      onsubmit="return confirm('¿Eliminar este servicio?');">
                                    <input type="hidden" name="id" value="${s.idservicio}">
                                    <button type="submit" class="btn rojo chico">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty lista}">
                        <tr>
                            <td colspan="4" class="vacio-msg">Todavía no hay servicios. Cargá el primero con “Nuevo servicio”.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </main>
    </body>
</html>