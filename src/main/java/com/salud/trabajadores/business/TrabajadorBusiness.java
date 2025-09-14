package com.salud.trabajadores.business;

import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import com.salud.trabajadores.dao.TrabajadorDAOLocal;
import com.salud.trabajadores.entity.TrabajadorSalud;
import java.time.LocalDate;
import java.util.List;

/**
 * Stateless Session Bean para la lógica de negocio de TrabajadorSalud
 * Implementa las interfaces local y remota
 */
@Stateless
public class TrabajadorBusiness implements TrabajadorBusinessLocal, TrabajadorBusinessRemote {
    
    // Inyección del DAO
    @EJB
    private TrabajadorDAOLocal trabajadorDAO;
    
    @Override
    public TrabajadorSalud agregarTrabajador(TrabajadorSalud trabajador) throws IllegalArgumentException {
        System.out.println("BUSINESS: Iniciando validaciones para agregar trabajador");
        
        // Aplicar reglas de negocio
        validarTrabajador(trabajador);
        
        // Si pasa todas las validaciones, delegamos al DAO
        TrabajadorSalud trabajadorAgregado = trabajadorDAO.agregar(trabajador);
        
        System.out.println("BUSINESS: Trabajador agregado exitosamente con ID: " + trabajadorAgregado.getId());
        return trabajadorAgregado;
    }
    
    @Override
    public List<TrabajadorSalud> obtenerTrabajadores() {
        System.out.println("BUSINESS: Obteniendo todos los trabajadores");
        return trabajadorDAO.obtenerTodos();
    }
    
    @Override
    public List<TrabajadorSalud> buscarTrabajadoresPorEspecialidad(String especialidad) {
        System.out.println("BUSINESS: Buscando trabajadores por especialidad: " + especialidad);
        
        if (especialidad == null || especialidad.trim().isEmpty()) {
            throw new IllegalArgumentException("La especialidad no puede estar vacía");
        }
        
        return trabajadorDAO.buscarPorEspecialidad(especialidad.trim());
    }
    
    @Override
    public TrabajadorSalud obtenerTrabajadorPorCedula(String cedula) {
        System.out.println("BUSINESS: Buscando trabajador por cédula: " + cedula);
        
        if (cedula == null || cedula.trim().isEmpty()) {
            throw new IllegalArgumentException("La cédula no puede estar vacía");
        }
        
        return trabajadorDAO.buscarPorCedula(cedula.trim());
    }
    
    /**
     * Método privado que contiene todas las reglas de negocio para validar un trabajador
     */
    private void validarTrabajador(TrabajadorSalud trabajador) throws IllegalArgumentException {
        if (trabajador == null) {
            throw new IllegalArgumentException("El trabajador no puede ser null");
        }
        
        // Regla 1: El nombre no puede estar vacío
        if (trabajador.getNombre() == null || trabajador.getNombre().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del trabajador es obligatorio");
        }
        
        // Regla 2: El nombre debe tener al menos 2 caracteres
        if (trabajador.getNombre().trim().length() < 2) {
            throw new IllegalArgumentException("El nombre debe tener al menos 2 caracteres");
        }
        
        // Regla 3: La especialidad no puede estar vacía
        if (trabajador.getEspecialidad() == null || trabajador.getEspecialidad().trim().isEmpty()) {
            throw new IllegalArgumentException("La especialidad es obligatoria");
        }
        
        // Regla 4: La cédula no puede estar vacía
        if (trabajador.getCedula() == null || trabajador.getCedula().trim().isEmpty()) {
            throw new IllegalArgumentException("La cédula es obligatoria");
        }
        
        // Regla 5: La cédula debe tener entre 7 y 8 dígitos
        String cedulaLimpia = trabajador.getCedula().trim().replaceAll("[^0-9]", "");
        if (cedulaLimpia.length() < 7 || cedulaLimpia.length() > 8) {
            throw new IllegalArgumentException("La cédula debe tener entre 7 y 8 dígitos");
        }
        
        // Regla 6: No puede existir otro trabajador con la misma cédula
        TrabajadorSalud trabajadorExistente = trabajadorDAO.buscarPorCedula(trabajador.getCedula().trim());
        if (trabajadorExistente != null) {
            throw new IllegalArgumentException("Ya existe un trabajador con la cédula: " + trabajador.getCedula());
        }
        
        // Regla 7: La fecha de ingreso no puede ser futura
        if (trabajador.getFechaIngreso() == null) {
            throw new IllegalArgumentException("La fecha de ingreso es obligatoria");
        }
        
        if (trabajador.getFechaIngreso().isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("La fecha de ingreso no puede ser futura");
        }
        
        // Regla 8: La fecha de ingreso no puede ser muy antigua (más de 50 años)
        if (trabajador.getFechaIngreso().isBefore(LocalDate.now().minusYears(50))) {
            throw new IllegalArgumentException("La fecha de ingreso no puede ser anterior a " + 
                                             LocalDate.now().minusYears(50));
        }
        
        System.out.println("BUSINESS: Todas las validaciones pasaron correctamente");
    }
    
    /**
     * Método utilitario para validar formato de cédula uruguaya (básico)
     */
    private boolean esFormatoCedulaValido(String cedula) {
        if (cedula == null) return false;
        
        // Remover espacios y guiones
        String cedulaLimpia = cedula.trim().replaceAll("[^0-9]", "");
        
        // Debe tener 7 u 8 dígitos
        return cedulaLimpia.length() >= 7 && cedulaLimpia.length() <= 8;
    }
}