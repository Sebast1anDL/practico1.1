package com.salud.trabajadores.business;

import jakarta.ejb.Local;
import com.salud.trabajadores.entity.TrabajadorSalud;
import java.util.List;

/**
 * Interface local para la lógica de negocio de TrabajadorSalud
 */
@Local
public interface TrabajadorBusinessLocal {
    
    /**
     * Agrega un nuevo trabajador con validaciones de negocio
     * @param trabajador el trabajador a agregar
     * @return el trabajador agregado
     * @throws IllegalArgumentException si no cumple las reglas de negocio
     */
    TrabajadorSalud agregarTrabajador(TrabajadorSalud trabajador) throws IllegalArgumentException;
    
    /**
     * Obtiene todos los trabajadores
     * @return lista de todos los trabajadores
     */
    List<TrabajadorSalud> obtenerTrabajadores();
    
    /**
     * Busca trabajadores por especialidad
     * @param especialidad la especialidad a buscar
     * @return lista de trabajadores con esa especialidad
     */
    List<TrabajadorSalud> buscarTrabajadoresPorEspecialidad(String especialidad);
    
    /**
     * Obtiene un trabajador por cédula
     * @param cedula la cédula del trabajador
     * @return el trabajador encontrado o null si no existe
     */
    TrabajadorSalud obtenerTrabajadorPorCedula(String cedula);
}