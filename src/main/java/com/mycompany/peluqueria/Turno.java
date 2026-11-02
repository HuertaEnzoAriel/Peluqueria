package com.mycompany.peluqueria;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Turno: un cliente reserva un servicio en una fecha y hora.
 * fechaFin = fechaInicio + duración del servicio; precio = importe cobrado en este turno.
 */
@Entity
@Table(name = "turno", catalog = "peluqueria", schema = "")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Turno.findAll", query = "SELECT t FROM Turno t"),
    @NamedQuery(name = "Turno.findByIdturno", query = "SELECT t FROM Turno t WHERE t.idturno = :idturno"),
    @NamedQuery(name = "Turno.findByFechaInicio", query = "SELECT t FROM Turno t WHERE t.fechaInicio = :fechaInicio"),
    @NamedQuery(name = "Turno.findByFechaFin", query = "SELECT t FROM Turno t WHERE t.fechaFin = :fechaFin"),
    @NamedQuery(name = "Turno.findByPrecio", query = "SELECT t FROM Turno t WHERE t.precio = :precio"),
    @NamedQuery(name = "Turno.findByEstado", query = "SELECT t FROM Turno t WHERE t.estado = :estado")})
public class Turno implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idturno", nullable = false)
    private Integer idturno;
    @Basic(optional = false)
    @NotNull
    @Column(name = "fecha_inicio", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaInicio;
    @Basic(optional = false)
    @NotNull
    @Column(name = "fecha_fin", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaFin;
    @Basic(optional = false)
    @NotNull
    @DecimalMin("0.00")
    @Column(name = "precio", nullable = false, precision = 10, scale = 2)
    private BigDecimal precio;
    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private Estado estado = Estado.PENDIENTE;
    @JoinColumn(name = "cliente_idcliente", referencedColumnName = "idcliente", nullable = false)
    @ManyToOne(optional = false)
    private Cliente clienteIdcliente;
    @JoinColumn(name = "servicio_idservicio", referencedColumnName = "idservicio", nullable = false)
    @ManyToOne(optional = false)
    private Servicio servicioIdservicio;

    public Turno() {
    }

    public Turno(Integer idturno) {
        this.idturno = idturno;
    }

    public Integer getIdturno() {
        return idturno;
    }

    public void setIdturno(Integer idturno) {
        this.idturno = idturno;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    public Cliente getClienteIdcliente() {
        return clienteIdcliente;
    }

    public void setClienteIdcliente(Cliente clienteIdcliente) {
        this.clienteIdcliente = clienteIdcliente;
    }

    public Servicio getServicioIdservicio() {
        return servicioIdservicio;
    }

    public void setServicioIdservicio(Servicio servicioIdservicio) {
        this.servicioIdservicio = servicioIdservicio;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idturno != null ? idturno.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Turno)) {
            return false;
        }
        Turno other = (Turno) object;
        if ((this.idturno == null && other.idturno != null) || (this.idturno != null && !this.idturno.equals(other.idturno))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mycompany.peluqueria.Turno[ idturno=" + idturno + " ]";
    }

}