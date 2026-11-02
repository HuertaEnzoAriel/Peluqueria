
# Peluquería: gestión de turnos

Aplicación web para administrar la agenda de una peluquería: clientes, servicios y turnos, con control de superposición de horarios.

Trabajo Práctico Integrador de Desarrollo Backend III (Tecnicatura Universitaria en Programación Web, UNSJ).

Autor: Enzo Huerta

## Funcionalidades

- **Clientes:** alta, edición, baja y listado (nombre, teléfono, email).
- **Servicios:** alta, edición, baja y listado (nombre, duración en minutos, precio).
- **Turnos:** alta, edición, baja y agenda ordenada por fecha. Cada turno tiene un cliente, un servicio, un estado y el precio cobrado.
- **Menú dinámico:** el desplegable *Servicios* se arma con los servicios de la base y lleva a los turnos de cada uno.
- **Validaciones:** campos obligatorios, formato de importes y fechas, y mensajes de error claros.

## Reglas de negocio

- Hay un solo puesto de atención: **dos turnos no pueden superponerse**.
- La hora de fin se calcula como `inicio + duración del servicio`.
- Un turno ocupa el horario si está en estado `PENDIENTE`, `CONFIRMADO` o `ATENDIDO`. Si está `CANCELADO` o `AUSENTE`, libera el horario.
- Dos turnos pegados (uno termina cuando empieza el otro) no se consideran superpuestos.
- Al editar un turno, este no se compara contra sí mismo.
- Si el precio se deja vacío, el turno toma el precio actual del servicio. Después queda fijo, aunque el servicio cambie de precio.
- No se puede eliminar un cliente o un servicio que tenga turnos: primero hay que eliminar esos turnos.

## Tecnologías

| Capa | Tecnología |
|---|---|
| Plataforma | Jakarta EE 10 |
| Persistencia | JPA 3.0 con EclipseLink |
| Lógica de negocio | EJB Stateless (patrón Session Facade) |
| Controlador | Un servlet (`Manejador`) |
| Vistas | JSP + JSTL |
| Servidor de aplicaciones | GlassFish 7 |
| Base de datos | MySQL 8 |
| Compilación | Maven (empaquetado `war`), JDK 11 |

## Arquitectura

Patrón MVC con tres capas:

- **Modelo:** entidades JPA `Cliente`, `Servicio`, `Turno` y el enum `Estado`.
- **Lógica:** facades EJB (`ClienteFacade`, `ServicioFacade`, `TurnoFacade`) sobre un `AbstractFacade<T>` genérico. La validación de superposición está en `TurnoFacade`.
- **Controlador y vistas:** el servlet `Manejador` recibe todas las rutas y reenvía a las JSP de `WEB-INF/vista`. Después de cada alta, edición o baja redirige al listado (redirect-after-POST).

## Estructura del proyecto

```
Peluqueria/
├── pom.xml
└── src/main/
    ├── java/
    │   ├── com/mycompany/peluqueria/        entidades, enum Estado, ReglaNegocioException
    │   │   └── controlador/Manejador.java   servlet controlador
    │   └── sesiones/                        facades EJB
    ├── resources/META-INF/persistence.xml   unidad de persistencia
    ├── setup/peluqueria.sql                 script de la base de datos
    └── webapp/
        ├── index.jsp
        ├── css/estilo.css
        └── WEB-INF/
            ├── web.xml, beans.xml, glassfish-web.xml
            └── vista/                       menú, error y vistas de cliente, servicio y turno
```

## Requisitos previos

- JDK 11
- GlassFish 7
- MySQL 8
- Conector `mysql-connector-j` 8.x copiado en `<glassfish>/glassfish/domains/domain1/lib/` (reiniciar el dominio después de copiarlo)
- NetBeans (opcional): el proyecto se abre y se ejecuta directamente desde ahí

## Puesta en marcha

### 1. Crear la base de datos

Ejecutar el script `src/main/setup/peluqueria.sql` en MySQL. Crea el esquema `peluqueria`, las tablas y datos de ejemplo. No borra datos existentes.

```bash
mysql -u root -p < src/main/setup/peluqueria.sql
```

### 2. Crear el pool y el recurso JDBC en GlassFish

Con GlassFish iniciado, desde `<glassfish>/glassfish/bin`:

```bash
./asadmin create-jdbc-connection-pool \
  --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
  --restype javax.sql.DataSource \
  --property user=USUARIO:password=CLAVE:serverName=localhost:portNumber=3306:databaseName=peluqueria:useSSL=false:allowPublicKeyRetrieval=true \
  peluqueriaPool

./asadmin create-jdbc-resource --connectionpoolid peluqueriaPool jdbc/peluqueria

./asadmin ping-connection-pool peluqueriaPool
```

Reemplazar `USUARIO` y `CLAVE` por las credenciales de MySQL. El último comando tiene que responder que el ping fue exitoso.

La unidad de persistencia (`my_persistence_unit`) usa el recurso JNDI `jdbc/peluqueria`.

### 3. Compilar y ejecutar

Desde NetBeans: clic derecho sobre el proyecto, **Clean and Build** y luego **Run**.

Por línea de comandos:

```bash
mvn clean package
./asadmin deploy --force target/Peluqueria-1.0-SNAPSHOT.war
```

La aplicación queda en `http://localhost:8080/Peluqueria-1.0-SNAPSHOT/`.

## Rutas principales

| Ruta | Acción |
|---|---|
| `/cliente/listar` | Listado de clientes |
| `/servicio/listar` | Listado de servicios |
| `/turno/listar` | Agenda de turnos |
| `/Servicio?codigoServ=ID` | Turnos de un servicio (desde el menú) |

Cada módulo tiene además `nuevo`, `editar`, `guardar` y `eliminar`. Guardar y eliminar solo aceptan POST.