package sesiones;

import com.mycompany.peluqueria.Estado;
import com.mycompany.peluqueria.ReglaNegocioException;
import com.mycompany.peluqueria.Servicio;
import com.mycompany.peluqueria.Turno;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TemporalType;
import jakarta.persistence.TypedQuery;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@Stateless
public class TurnoFacade extends AbstractFacade<Turno> {

    /** Estados que ocupan el horario. CANCELADO y AUSENTE lo liberan. */
    private static final List<Estado> ESTADOS_QUE_OCUPAN
            = Arrays.asList(Estado.PENDIENTE, Estado.CONFIRMADO, Estado.ATENDIDO);

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public TurnoFacade() {
        super(Turno.class);
    }

    /** Todos los turnos con su cliente y servicio, ordenados por fecha de inicio. */
    @Override
    public List<Turno> findAll() {
        return em.createQuery("SELECT t FROM Turno t JOIN FETCH t.clienteIdcliente "
                + "JOIN FETCH t.servicioIdservicio ORDER BY t.fechaInicio", Turno.class)
                .getResultList();
    }
        /**
     * Turnos que coinciden con el texto (cliente, servicio o estado) y/o que empiezan
     * en el rango [desde, hasta). Todos los parámetros son opcionales.
     */
    public List<Turno> buscar(String texto, Date desde, Date hasta) {
        StringBuilder jpql = new StringBuilder(
                "SELECT t FROM Turno t JOIN FETCH t.clienteIdcliente JOIN FETCH t.servicioIdservicio WHERE 1 = 1");
        List<Estado> estados = new ArrayList<>();
        if (texto != null) {
            estados = estadosQueContienen(texto);
            jpql.append(" AND (LOWER(t.clienteIdcliente.nombre) LIKE :texto ESCAPE '!'")
                .append(" OR LOWER(t.servicioIdservicio.nombre) LIKE :texto ESCAPE '!'");
            if (!estados.isEmpty()) {
                jpql.append(" OR t.estado IN :estados");
            }
            jpql.append(")");
        }
        if (desde != null && hasta != null) {
            jpql.append(" AND t.fechaInicio >= :desde AND t.fechaInicio < :hasta");
        }
        jpql.append(" ORDER BY t.fechaInicio");

        TypedQuery<Turno> consulta = em.createQuery(jpql.toString(), Turno.class);
        if (texto != null) {
            String patron = texto.toLowerCase().replace("!", "!!").replace("%", "!%").replace("_", "!_");
            consulta.setParameter("texto", "%" + patron + "%");
            if (!estados.isEmpty()) {
                consulta.setParameter("estados", estados);
            }
        }
        if (desde != null && hasta != null) {
            consulta.setParameter("desde", desde, TemporalType.TIMESTAMP);
            consulta.setParameter("hasta", hasta, TemporalType.TIMESTAMP);
        }
        return consulta.getResultList();
    }

    /** Estados cuyo nombre contiene el texto (por ejemplo "conf" devuelve CONFIRMADO). */
    private List<Estado> estadosQueContienen(String texto) {
        List<Estado> encontrados = new ArrayList<>();
        for (Estado e : Estado.values()) {
            if (e.name().toLowerCase().contains(texto.toLowerCase())) {
                encontrados.add(e);
            }
        }
        return encontrados;
    }
    /** Turnos de un servicio, con su cliente, ordenados por fecha de inicio. */
    public List<Turno> findByServicio(Integer idservicio) {
        return em.createQuery("SELECT t FROM Turno t JOIN FETCH t.clienteIdcliente "
                + "WHERE t.servicioIdservicio.idservicio = :id ORDER BY t.fechaInicio", Turno.class)
                .setParameter("id", idservicio)
                .getResultList();
    }
    /**
     * Turnos que ocupan el horario y se superponen con [inicio, fin).
     * idExcluir (opcional): turno a ignorar, para cuando se está editando.
     */
    public List<Turno> findSolapados(Date inicio, Date fin, Integer idExcluir) {
        String jpql = "SELECT t FROM Turno t JOIN FETCH t.clienteIdcliente "
                + "WHERE t.fechaInicio < :fin AND t.fechaFin > :inicio AND t.estado IN :ocupan "
                + (idExcluir != null ? "AND t.idturno <> :idExcluir " : "")
                + "ORDER BY t.fechaInicio";
        TypedQuery<Turno> q = em.createQuery(jpql, Turno.class);
        q.setParameter("fin", fin, TemporalType.TIMESTAMP);
        q.setParameter("inicio", inicio, TemporalType.TIMESTAMP);
        q.setParameter("ocupan", ESTADOS_QUE_OCUPAN);
        if (idExcluir != null) {
            q.setParameter("idExcluir", idExcluir);
        }
        return q.getResultList();
    }

    /** Alta: calcula la hora de fin, valida que no haya superposición y guarda. */
    public void guardarNuevo(Turno t) throws ReglaNegocioException {
        prepararYValidar(t);
        create(t);
    }

    /** Edición: igual que el alta, ignorando el propio turno en la comparación. */
    public void guardarCambios(Turno t) throws ReglaNegocioException {
        prepararYValidar(t);
        edit(t);
    }

    private void prepararYValidar(Turno t) throws ReglaNegocioException {
        Servicio s = t.getServicioIdservicio();
        if (t.getFechaInicio() == null || s == null) {
            throw new ReglaNegocioException("El turno necesita fecha de inicio y servicio.");
        }
        t.setFechaFin(new Date(t.getFechaInicio().getTime() + s.getDuracionMin() * 60_000L));

        if (ESTADOS_QUE_OCUPAN.contains(t.getEstado())) {
            List<Turno> choques = findSolapados(t.getFechaInicio(), t.getFechaFin(), t.getIdturno());
            if (!choques.isEmpty()) {
                Turno otro = choques.get(0);
                SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                throw new ReglaNegocioException("El horario se superpone con el turno de "
                        + otro.getClienteIdcliente().getNombre() + " ("
                        + f.format(otro.getFechaInicio()) + " a " + f.format(otro.getFechaFin()) + ").");
            }
        }
    }
}