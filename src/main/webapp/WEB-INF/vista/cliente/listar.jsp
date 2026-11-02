<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Clientes · Peluquería</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <%@include file="/WEB-INF/vista/_menu.jspf"%>
        <main>
            <div class="barra">
                <div>
                    <h1>Clientes</h1>
                    <p class="sub">Personas que se atienden en la peluquería.</p>
                </div>
                <a class="btn verde" href="${pageContext.request.contextPath}/cliente/nuevo">Nuevo cliente</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Nombre</th>
                        <th>WhatsApp</th>
                        <th>Email</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cli" items="${lista}">
                        <tr>
                            <td><c:out value="${cli.nombre}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty cli.telefono}">
                                        <c:set var="tel" value="${fn:replace(fn:replace(fn:replace(fn:replace(fn:replace(cli.telefono, ' ', ''), '-', ''), '(', ''), ')', ''), '+', '')}"/>
                                        <a href="https://wa.me/549<c:out value='${tel}'/>" target="_blank" rel="noopener noreferrer">
                                            <c:out value="${cli.telefono}"/>
                                        </a>
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${cli.email}" default="—"/></td>
                            <td class="acciones">
                                <a class="btn gris chico" href="${pageContext.request.contextPath}/cliente/editar?id=${cli.idcliente}">Editar</a>
                                <form method="post" action="${pageContext.request.contextPath}/cliente/eliminar"
                                      onsubmit="return confirm('¿Eliminar a este cliente?');">
                                    <input type="hidden" name="id" value="${cli.idcliente}">
                                    <button type="submit" class="btn rojo chico">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty lista}">
                        <tr>
                            <td colspan="4" class="vacio-msg">Todavía no hay clientes. Cargá el primero con “Nuevo cliente”.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </main>
    </body>
</html>