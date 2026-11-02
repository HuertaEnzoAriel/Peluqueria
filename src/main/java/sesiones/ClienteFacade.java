package sesiones;

import com.mycompany.peluqueria.Cliente;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;

@Stateless
public class ClienteFacade extends AbstractFacade<Cliente> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ClienteFacade() {
        super(Cliente.class);
    }

    /** Listado ordenado por nombre. */
    @Override
    public List<Cliente> findAll() {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Cliente> cq = cb.createQuery(Cliente.class);
        Root<Cliente> c = cq.from(Cliente.class);
        cq.select(c).orderBy(cb.asc(c.get("nombre")));
        return em.createQuery(cq).getResultList();
    }
}