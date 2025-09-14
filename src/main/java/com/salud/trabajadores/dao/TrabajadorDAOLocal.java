package com.salud.trabajadores.dao;

import jakarta.ejb.Local;
import com.salud.trabajadores.entity.TrabajadorSalud;
import java.util.List;

/**
 * Interface local para el acceso a datos de TrabajadorSalud
 */
@Local
public interface TrabajadorDAOLocal {
    
    /**
     * Agrega un nuevo trabajador
     * @param trabajador el trabajador a agregar
     * @return el trabajador con el ID asignado
     */
    TrabajadorSalud agregar(TrabajadorSalud trabajador);
    
    /**
     * Obtiene todos los trabajadores
     * @return lista de todos los trabajadores
     */
    List<TrabajadorSalud> obtenerTodos();
    
    /**
     * Busca trabajadores por especialidad
     * @param especialidad la especialidad a buscar
     * @return lista de trabajadores con esa especialidad
     */
    List<TrabajadorSalud> buscarPorEspecialidad(String especialidad);
    
    /**
     * Busca un trabajador por cédula
     * @param cedula la cédula a buscar
     * @return el trabajador encontrado o null si no existe
     */
    TrabajadorSalud buscarPorCedula(String cedula);
    
    /**
     * Obtiene un trabajador por ID
     * @param id el ID del trabajador
     * @return el trabajador encontrado o null si no existe
     */
    TrabajadorSalud obtenerPorId(Long id);
}