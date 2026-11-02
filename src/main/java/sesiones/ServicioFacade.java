package sesiones;

import com.mycompany.peluqueria.Servicio;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;

@Stateless
public class ServicioFacade extends AbstractFacade<Servicio> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ServicioFacade() {
        super(Servicio.class);
    }

    /** Listado ordenado por nombre. */
    @Override
    public List<Servicio> findAll() {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Servicio> cq = cb.createQuery(Servicio.class);
        Root<Servicio> s = cq.from(Servicio.class);
        cq.select(s).orderBy(cb.asc(s.get("nombre")));
        return em.createQuery(cq).getResultList();
    }
}