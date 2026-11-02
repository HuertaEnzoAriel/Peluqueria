package com.mycompany.peluqueria.controlador;

import com.mycompany.peluqueria.Cliente;
import com.mycompany.peluqueria.Estado;
import com.mycompany.peluqueria.ReglaNegocioException;
import com.mycompany.peluqueria.Servicio;
import com.mycompany.peluqueria.Turno;
import jakarta.ejb.EJB;
import jakarta.ejb.EJBException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.Date;
import sesiones.ClienteFacade;
import sesiones.ServicioFacade;
import sesiones.TurnoFacade;

@WebServlet(name = "Manejador", loadOnStartup = 1, urlPatterns = {
    "/cliente/listar", "/cliente/nuevo", "/cliente/editar", "/cliente/guardar", "/cliente/eliminar",
    "/servicio/listar", "/servicio/nuevo", "/servicio/editar", "/servicio/guardar", "/servicio/eliminar",
    "/turno/listar", "/turno/nuevo", "/turno/editar", "/turno/guardar", "/turno/eliminar",
    "/Servicio"
})
public class Manejador extends HttpServlet {

    private static final BigDecimal MAX_IMPORTE = new BigDecimal("99999999.99");

    @EJB
    private ClienteFacade clienteFacade;
    @EJB
    private ServicioFacade servicioFacade;
    @EJB
    private TurnoFacade turnoFacade;

    @Override
    public void init() throws ServletException {
        actualizarMenu();
    }

    /** Guarda en el contexto del servlet la lista de servicios que muestra el menú. */
    private void actualizarMenu() {
        getServletContext().setAttribute("servicios", servicioFacade.findAll());
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        String ctx = request.getContextPath();
        String url = "/index.jsp";

        try {
            switch (path) {
                // ---------- SERVICIO (menú dinámico): turnos del servicio elegido ----------
                case "/Servicio":
                    Servicio servicioMenu = existente(servicioFacade.find(idParam(request, "codigoServ")),
                            "El servicio solicitado no existe.");
                    request.setAttribute("servicio", servicioMenu);
                    request.setAttribute("lista", turnoFacade.findByServicio(servicioMenu.getIdservicio()));
                    url = "/WEB-INF/vista/servicio/turnos.jsp";
                    break;

                // ---------- CLIENTE ----------
                case "/cliente/listar":
                    request.setAttribute("lista", clienteFacade.findAll());
                    url = "/WEB-INF/vista/cliente/listar.jsp";
                    break;

                case "/cliente/nuevo":
                    request.setAttribute("cliente", new Cliente());
                    url = "/WEB-INF/vista/cliente/form.jsp";
                    break;

                case "/cliente/editar":
                    request.setAttribute("cliente", existente(clienteFacade.find(idParam(request, "id")),
                            "El cliente solicitado no existe."));
                    url = "/WEB-INF/vista/cliente/form.jsp";
                    break;

                case "/cliente/guardar":
                    soloPost(request);
                    String idCliente = request.getParameter("idcliente");
                    Cliente cli = vacio(idCliente) ? new Cliente()
                            : existente(clienteFacade.find(Integer.valueOf(idCliente)), "El cliente solicitado no existe.");
                    cli.setNombre(requerido(request, "nombre", "El nombre del cliente es obligatorio."));
                    cli.setTelefono(opcional(request, "telefono"));
                    cli.setEmail(opcional(request, "email"));
                    if (cli.getIdcliente() == null) {
                        clienteFacade.create(cli);
                    } else {
                        clienteFacade.edit(cli);
                    }
                    response.sendRedirect(ctx + "/cliente/listar");
                    return;

                case "/cliente/eliminar":
                    soloPost(request);
                    Cliente cliBorrar = existente(clienteFacade.find(idParam(request, "id")),
                            "El cliente solicitado no existe.");
                    try {
                        clienteFacade.remove(cliBorrar);
                    } catch (EJBException ex) {
                        throw new ReglaNegocioException("No se pudo eliminar a " + cliBorrar.getNombre()
                                + ". Si tiene turnos asociados, eliminá esos turnos primero.");
                    }
                    response.sendRedirect(ctx + "/cliente/listar");
                    return;

                // ---------- SERVICIO ----------
                case "/servicio/listar":
                    request.setAttribute("lista", servicioFacade.findAll());
                    url = "/WEB-INF/vista/servicio/listar.jsp";
                    break;

                case "/servicio/nuevo":
                    request.setAttribute("servicio", new Servicio());
                    url = "/WEB-INF/vista/servicio/form.jsp";
                    break;

                case "/servicio/editar":
                    request.setAttribute("servicio", existente(servicioFacade.find(idParam(request, "id")),
                            "El servicio solicitado no existe."));
                    url = "/WEB-INF/vista/servicio/form.jsp";
                    break;

                case "/servicio/guardar":
                    soloPost(request);
                    String idServicio = request.getParameter("idservicio");
                    Servicio serv = vacio(idServicio) ? new Servicio()
                            : existente(servicioFacade.find(Integer.valueOf(idServicio)), "El servicio solicitado no existe.");
                    serv.setNombre(requerido(request, "nombre", "El nombre del servicio es obligatorio."));
                    serv.setDuracionMin(duracion(request));
                    serv.setPrecio(importe(requerido(request, "precio", "El precio es obligatorio.")));
                    if (serv.getIdservicio() == null) {
                        servicioFacade.create(serv);
                    } else {
                        servicioFacade.edit(serv);
                    }
                    actualizarMenu();
                    response.sendRedirect(ctx + "/servicio/listar");
                    return;

                case "/servicio/eliminar":
                    soloPost(request);
                    Servicio servBorrar = existente(servicioFacade.find(idParam(request, "id")),
                            "El servicio solicitado no existe.");
                    try {
                        servicioFacade.remove(servBorrar);
                    } catch (EJBException ex) {
                        throw new ReglaNegocioException("No se pudo eliminar el servicio " + servBorrar.getNombre()
                                + ". Si tiene turnos asociados, eliminá esos turnos primero.");
                    }
                    actualizarMenu();
                    response.sendRedirect(ctx + "/servicio/listar");
                    return;

                // ---------- TURNO ----------
                case "/turno/listar":
                    request.setAttribute("lista", turnoFacade.findAll());
                    url = "/WEB-INF/vista/turno/listar.jsp";
                    break;

                case "/turno/nuevo":
                    request.setAttribute("turno", new Turno());
                    cargarListasDelTurno(request);
                    url = "/WEB-INF/vista/turno/form.jsp";
                    break;

                case "/turno/editar":
                    request.setAttribute("turno", existente(turnoFacade.find(idParam(request, "id")),
                            "El turno solicitado no existe."));
                    cargarListasDelTurno(request);
                    url = "/WEB-INF/vista/turno/form.jsp";
                    break;

                case "/turno/guardar":
                    soloPost(request);
                    String idTurno = request.getParameter("idturno");
                    Turno tur = vacio(idTurno) ? new Turno()
                            : existente(turnoFacade.find(Integer.valueOf(idTurno)), "El turno solicitado no existe.");
                    Cliente cliTurno = existente(clienteFacade.find(
                            Integer.valueOf(requerido(request, "cliente", "Elegí un cliente."))),
                            "El cliente elegido no existe.");
                    Servicio servTurno = existente(servicioFacade.find(
                            Integer.valueOf(requerido(request, "servicio", "Elegí un servicio."))),
                            "El servicio elegido no existe.");
                    tur.setClienteIdcliente(cliTurno);
                    tur.setServicioIdservicio(servTurno);
                    tur.setFechaInicio(fechaHora(request, "inicio"));
                    tur.setEstado(estado(request));
                    String precioTxt = request.getParameter("precio");
                    tur.setPrecio(vacio(precioTxt) ? servTurno.getPrecio() : importe(precioTxt));
                    if (tur.getIdturno() == null) {
                        turnoFacade.guardarNuevo(tur);
                    } else {
                        turnoFacade.guardarCambios(tur);
                    }
                    response.sendRedirect(ctx + "/turno/listar");
                    return;

                case "/turno/eliminar":
                    soloPost(request);
                    turnoFacade.remove(existente(turnoFacade.find(idParam(request, "id")),
                            "El turno solicitado no existe."));
                    response.sendRedirect(ctx + "/turno/listar");
                    return;
            }
        } catch (ReglaNegocioException ex) {
            request.setAttribute("error", ex.getMessage());
            url = "/WEB-INF/vista/error.jsp";
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage() != null ? ex.getMessage() : "Parámetro inválido.");
            url = "/WEB-INF/vista/error.jsp";
        } catch (Exception ex) {
            request.setAttribute("error", "No se pudo completar la operación: " + ex.getMessage());
            url = "/WEB-INF/vista/error.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    /** Listas que necesita el formulario de turno: clientes, servicios y estados posibles. */
    private void cargarListasDelTurno(HttpServletRequest request) {
        request.setAttribute("clientes", clienteFacade.findAll());
        request.setAttribute("servicios", servicioFacade.findAll());
        request.setAttribute("estados", Estado.values());
    }

    // ---------- Utilidades de lectura y validación de parámetros ----------

    private static boolean vacio(String valor) {
        return valor == null || valor.isBlank();
    }

    /** Las acciones que modifican datos solo se aceptan por POST (desde un formulario). */
    private void soloPost(HttpServletRequest request) {
        if (!"POST".equals(request.getMethod())) {
            throw new IllegalArgumentException("Esta acción solo se puede realizar desde el formulario.");
        }
    }

    /** Lee un parámetro numérico obligatorio. NumberFormatException es una IllegalArgumentException. */
    private Integer idParam(HttpServletRequest request, String nombre) {
        String valor = request.getParameter(nombre);
        if (vacio(valor)) {
            throw new IllegalArgumentException("Falta el parámetro '" + nombre + "'.");
        }
        return Integer.valueOf(valor.trim());
    }

    private String requerido(HttpServletRequest request, String nombre, String mensaje) {
        String valor = request.getParameter(nombre);
        if (vacio(valor)) {
            throw new IllegalArgumentException(mensaje);
        }
        return valor.trim();
    }

    private String opcional(HttpServletRequest request, String nombre) {
        String valor = request.getParameter(nombre);
        return vacio(valor) ? null : valor.trim();
    }

    private <T> T existente(T entidad, String mensaje) {
        if (entidad == null) {
            throw new IllegalArgumentException(mensaje);
        }
        return entidad;
    }

    private Integer duracion(HttpServletRequest request) {
        String texto = requerido(request, "duracion", "La duración es obligatoria.");
        try {
            int minutos = Integer.parseInt(texto);
            if (minutos < 1) {
                throw new NumberFormatException();
            }
            return minutos;
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("La duración debe ser un número entero de minutos, mayor que cero.");
        }
    }

    /** Importe con hasta 2 decimales; acepta coma o punto como separador. */
    private BigDecimal importe(String texto) {
        try {
            BigDecimal valor = new BigDecimal(texto.trim().replace(',', '.'));
            if (valor.signum() < 0 || valor.compareTo(MAX_IMPORTE) > 0) {
                throw new NumberFormatException();
            }
            return valor.setScale(2, RoundingMode.HALF_UP);
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("El precio debe ser un número mayor o igual a cero, por ejemplo 8000 o 8000,50.");
        }
    }

    /** Fecha y hora de un campo datetime-local (formato 2026-11-03T10:00). */
    private Date fechaHora(HttpServletRequest request, String nombre) {
        String texto = requerido(request, nombre, "La fecha y hora de inicio son obligatorias.");
        try {
            return Date.from(LocalDateTime.parse(texto).atZone(ZoneId.systemDefault()).toInstant());
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException("La fecha y hora de inicio no tienen un formato válido.");
        }
    }

    private Estado estado(HttpServletRequest request) {
        String texto = request.getParameter("estado");
        if (vacio(texto)) {
            return Estado.PENDIENTE;
        }
        try {
            return Estado.valueOf(texto.trim());
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("El estado indicado no es válido.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}