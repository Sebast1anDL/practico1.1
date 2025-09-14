package com.salud.trabajadores.dao;

import jakarta.ejb.Singleton;
import com.salud.trabajadores.entity.TrabajadorSalud;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

/**
 * Singleton Session Bean para el acceso a datos de TrabajadorSalud
 * Implementa las interfaces local y remota
 */
@Singleton
public class TrabajadorDAO implements TrabajadorDAOLocal, TrabajadorDAORemote {
    
    // Simulamos una base de datos en memoria
    private final ConcurrentHashMap<Long, TrabajadorSalud> trabajadores = new ConcurrentHashMap<>();
    private final AtomicLong contadorId = new AtomicLong(1L);
    
    /**
     * Constructor - inicializa algunos datos de ejemplo
     */
    public TrabajadorDAO() {
        inicializarDatos();
    }
    
    @Override
    public TrabajadorSalud agregar(TrabajadorSalud trabajador) {
        if (trabajador == null) {
            throw new IllegalArgumentException("El trabajador no puede ser null");
        }
        
        // Asignamos un ID único
        Long nuevoId = contadorId.getAndIncrement();
        trabajador.setId(nuevoId);
        
        // Guardamos en nuestro "almacén"
        trabajadores.put(nuevoId, trabajador);
        
        System.out.println("DAO: Trabajador agregado con ID: " + nuevoId);
        return trabajador;
    }
    
    @Override
    public List<TrabajadorSalud> obtenerTodos() {
        System.out.println("DAO: Obteniendo todos los trabajadores. Total: " + trabajadores.size());
        return new ArrayList<>(trabajadores.values());
    }
    
    @Override
    public List<TrabajadorSalud> buscarPorEspecialidad(String especialidad) {
        if (especialidad == null || especialidad.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        List<TrabajadorSalud> resultado = trabajadores.values().stream()
                .filter(t -> t.getEspecialidad() != null && 
                           t.getEspecialidad().toLowerCase().contains(especialidad.toLowerCase()))
                .collect(Collectors.toList());
        
        System.out.println("DAO: Encontrados " + resultado.size() + " trabajadores con especialidad: " + especialidad);
        return resultado;
    }
    
    @Override
    public TrabajadorSalud buscarPorCedula(String cedula) {
        if (cedula == null || cedula.trim().isEmpty()) {
            return null;
        }
        
        TrabajadorSalud resultado = trabajadores.values().stream()
                .filter(t -> cedula.equals(t.getCedula()))
                .findFirst()
                .orElse(null);
        
        System.out.println("DAO: Búsqueda por cédula " + cedula + ": " + 
                          (resultado != null ? "Encontrado" : "No encontrado"));
        return resultado;
    }
    
    @Override
    public TrabajadorSalud obtenerPorId(Long id) {
        if (id == null) {
            return null;
        }
        
        TrabajadorSalud resultado = trabajadores.get(id);
        System.out.println("DAO: Búsqueda por ID " + id + ": " + 
                          (resultado != null ? "Encontrado" : "No encontrado"));
        return resultado;
    }
    
    /**
     * Método privado para inicializar algunos datos de ejemplo
     */
    private void inicializarDatos() {
        // Agregamos algunos trabajadores de ejemplo
        TrabajadorSalud trabajador1 = new TrabajadorSalud(
                "Dr. Juan Pérez", 
                "Cardiología", 
                java.time.LocalDate.of(2020, 3, 15), 
                "12345678"
        );
        
        TrabajadorSalud trabajador2 = new TrabajadorSalud(
                "Dra. María González", 
                "Pediatría", 
                java.time.LocalDate.of(2018, 7, 22), 
                "87654321"
        );
        
        TrabajadorSalud trabajador3 = new TrabajadorSalud(
                "Enf. Carlos Rodríguez", 
                "Enfermería", 
                java.time.LocalDate.of(2021, 1, 10), 
                "11223344"
        );
        
        // Los agregamos usando nuestro método agregar
        agregar(trabajador1);
        agregar(trabajador2);
        agregar(trabajador3);
        
        System.out.println("DAO: Datos de ejemplo inicializados");
    }
    
    /**
     * Método utilitario para obtener el número total de trabajadores
     */
    public int getTotal() {
        return trabajadores.size();
    }
}