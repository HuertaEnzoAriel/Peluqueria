package com.mycompany.peluqueria;

/**
 * Error de regla de negocio (por ejemplo, turnos superpuestos).
 * Es checked: el contenedor EJB no la envuelve en EJBException y el controlador puede mostrar su mensaje.
 */
public class ReglaNegocioException extends Exception {

    public ReglaNegocioException(String message) {
        super(message);
    }
}