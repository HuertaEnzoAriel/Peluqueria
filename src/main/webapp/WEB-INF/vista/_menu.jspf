<nav class="menu">
    <a class="marca" href="${pageContext.request.contextPath}/index.jsp">Peluquería</a>
    <div class="drop">
        <span tabindex="0">Servicios &#9662;</span>
        <ul>
            <c:forEach var="s" items="${applicationScope.servicios}">
                <li><a href="${pageContext.request.contextPath}/Servicio?codigoServ=${s.idservicio}"><c:out value="${s.nombre}"/></a></li>
            </c:forEach>
            <c:if test="${empty applicationScope.servicios}"><li class="vacio">Todavía no hay servicios</li></c:if>
            <li><a href="${pageContext.request.contextPath}/servicio/listar">Administrar servicios</a></li>
        </ul>
    </div>
    <a href="${pageContext.request.contextPath}/turno/listar">Turnos</a>
    <a href="${pageContext.request.contextPath}/cliente/listar">Clientes</a>
</nav>