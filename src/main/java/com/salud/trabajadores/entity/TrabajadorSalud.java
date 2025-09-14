package com.salud.trabajadores.entity;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/**
 * Entidad TrabajadorSalud
 * Representa a un profesional o técnico de la salud
 */
public class TrabajadorSalud implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String nombre;
    private String especialidad;
    private LocalDate fechaIngreso;
    private String cedula;
    
    // Formatter para fechas
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    // Constructor vacío
    public TrabajadorSalud() {
    }

    // Constructor con parámetros
    public TrabajadorSalud(String nombre, String especialidad, LocalDate fechaIngreso, String cedula) {
        this.nombre = nombre;
        this.especialidad = especialidad;
        this.fechaIngreso = fechaIngreso;
        this.cedula = cedula;
    }

    // Constructor completo
    public TrabajadorSalud(Long id, String nombre, String especialidad, LocalDate fechaIngreso, String cedula) {
        this.id = id;
        this.nombre = nombre;
        this.especialidad = especialidad;
        this.fechaIngreso = fechaIngreso;
        this.cedula = cedula;
    }

    // Getters y Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public LocalDate getFechaIngreso() {
        return fechaIngreso;
    }

    public void setFechaIngreso(LocalDate fechaIngreso) {
        this.fechaIngreso = fechaIngreso;
    }

    public String getCedula() {
        return cedula;
    }

    public void setCedula(String cedula) {
        this.cedula = cedula;
    }
    
    // ========== MÉTODOS HELPER PARA JSP ==========
    
    /**
     * Convierte LocalDate a java.util.Date para compatibilidad con JSP/JSTL
     * @return java.util.Date o null si fechaIngreso es null
     */
    public java.util.Date getFechaIngresoAsDate() {
        if (fechaIngreso == null) {
            return null;
        }
        return java.sql.Date.valueOf(fechaIngreso);
    }
    
    /**
     * Retorna la fecha formateada como String para mostrar en JSP
     * @return String con formato dd/MM/yyyy o cadena vacía si es null
     */
    public String getFechaIngresoFormatted() {
        if (fechaIngreso == null) {
            return "";
        }
        return fechaIngreso.format(DATE_FORMATTER);
    }
    
    /**
     * Retorna la fecha en formato ISO (yyyy-MM-dd) para inputs HTML date
     * @return String con formato yyyy-MM-dd o cadena vacía si es null
     */
    public String getFechaIngresoISO() {
        if (fechaIngreso == null) {
            return "";
        }
        return fechaIngreso.toString();
    }

    // equals y hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TrabajadorSalud that = (TrabajadorSalud) o;
        return Objects.equals(id, that.id) && Objects.equals(cedula, that.cedula);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, cedula);
    }

    // toString
    @Override
    public String toString() {
        return "TrabajadorSalud{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", especialidad='" + especialidad + '\'' +
                ", fechaIngreso=" + fechaIngreso +
                ", cedula='" + cedula + '\'' +
                '}';
    }
}