package com.salud.trabajadores.web;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.salud.trabajadores.business.TrabajadorBusinessLocal;
import com.salud.trabajadores.entity.TrabajadorSalud;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Servlet Controller para manejar las peticiones relacionadas con trabajadores
 */
@WebServlet(name = "TrabajadorController", urlPatterns = {"/TrabajadorController"})
public class TrabajadorController extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Inyección del EJB de negocio
    @EJB
    private TrabajadorBusinessLocal trabajadorBusiness;
    
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if (action == null || action.isEmpty()) {
                // Redirigir al inicio si no hay acción
                response.sendRedirect("index.jsp");
                return;
            }
            
            switch (action) {
                case "agregar":
                    mostrarFormularioAgregar(request, response);
                    break;
                case "listar":
                    listarTrabajadores(request, response);
                    break;
                case "buscar":
                    mostrarFormularioBuscar(request, response);
                    break;
                case "buscarPorEspecialidad":
                    buscarPorEspecialidad(request, response);
                    break;
                case "buscarPorCedula":
                    buscarPorCedula(request, response);
                    break;
                default:
                    response.sendRedirect("index.jsp");
            }
            
        } catch (Exception e) {
            log("Error en doGet", e);
            request.setAttribute("error", "Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("jsp/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("guardar".equals(action)) {
                guardarTrabajador(request, response);
            } else {
                response.sendRedirect("index.jsp");
            }
            
        } catch (Exception e) {
            log("Error en doPost", e);
            request.setAttribute("error", "Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("jsp/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Muestra el formulario para agregar un trabajador
     */
    private void mostrarFormularioAgregar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("jsp/agregarTrabajador.jsp").forward(request, response);
    }
    
    /**
     * Lista todos los trabajadores
     */
    private void listarTrabajadores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<TrabajadorSalud> trabajadores = trabajadorBusiness.obtenerTrabajadores();
        request.setAttribute("trabajadores", trabajadores);
        request.getRequestDispatcher("jsp/listarTrabajadores.jsp").forward(request, response);
    }
    
    /**
     * Muestra el formulario de búsqueda
     */
    private void mostrarFormularioBuscar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("jsp/buscarTrabajador.jsp").forward(request, response);
    }
    
    /**
     * Busca trabajadores por especialidad
     */
    private void buscarPorEspecialidad(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String especialidad = request.getParameter("especialidad");
        
        if (especialidad == null || especialidad.trim().isEmpty()) {
            request.setAttribute("error", "Debe especificar una especialidad para buscar");
            request.getRequestDispatcher("jsp/buscarTrabajador.jsp").forward(request, response);
            return;
        }
        
        List<TrabajadorSalud> trabajadores = trabajadorBusiness.buscarTrabajadoresPorEspecialidad(especialidad);
        request.setAttribute("trabajadores", trabajadores);
        request.setAttribute("criterioBusqueda", "especialidad: " + especialidad);
        request.getRequestDispatcher("jsp/resultadosBusqueda.jsp").forward(request, response);
    }
    
    /**
     * Busca un trabajador por cédula
     */
    private void buscarPorCedula(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String cedula = request.getParameter("cedula");
        
        if (cedula == null || cedula.trim().isEmpty()) {
            request.setAttribute("error", "Debe especificar una cédula para buscar");
            request.getRequestDispatcher("jsp/buscarTrabajador.jsp").forward(request, response);
            return;
        }
        
        TrabajadorSalud trabajador = trabajadorBusiness.obtenerTrabajadorPorCedula(cedula);
        
        if (trabajador != null) {
            // Crear lista con un solo elemento para reutilizar la JSP de resultados
            List<TrabajadorSalud> trabajadores = List.of(trabajador);
            request.setAttribute("trabajadores", trabajadores);
        } else {
            request.setAttribute("trabajadores", List.of());
        }
        
        request.setAttribute("criterioBusqueda", "cédula: " + cedula);
        request.getRequestDispatcher("jsp/resultadosBusqueda.jsp").forward(request, response);
    }
    
    /**
     * Guarda un nuevo trabajador
     */
    private void guardarTrabajador(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            String nombre = request.getParameter("nombre");
            String especialidad = request.getParameter("especialidad");
            String cedula = request.getParameter("cedula");
            String fechaIngresoStr = request.getParameter("fechaIngreso");
            
            // Validaciones básicas
            if (nombre == null || nombre.trim().isEmpty()) {
                throw new IllegalArgumentException("El nombre es obligatorio");
            }
            if (especialidad == null || especialidad.trim().isEmpty()) {
                throw new IllegalArgumentException("La especialidad es obligatoria");
            }
            if (cedula == null || cedula.trim().isEmpty()) {
                throw new IllegalArgumentException("La cédula es obligatoria");
            }
            if (fechaIngresoStr == null || fechaIngresoStr.trim().isEmpty()) {
                throw new IllegalArgumentException("La fecha de ingreso es obligatoria");
            }
            
            // Parsear fecha
            LocalDate fechaIngreso;
            try {
                fechaIngreso = LocalDate.parse(fechaIngresoStr, dateFormatter);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Formato de fecha inválido");
            }
            
            // Crear el trabajador
            TrabajadorSalud trabajador = new TrabajadorSalud(
                nombre.trim(), 
                especialidad.trim(), 
                fechaIngreso, 
                cedula.trim()
            );
            
            // Guardar mediante el EJB de negocio
            TrabajadorSalud trabajadorGuardado = trabajadorBusiness.agregarTrabajador(trabajador);
            
            // Mensaje de éxito
            request.setAttribute("mensaje", 
                "Trabajador agregado exitosamente con ID: " + trabajadorGuardado.getId());
            request.setAttribute("trabajador", trabajadorGuardado);
            request.getRequestDispatcher("jsp/exito.jsp").forward(request, response);
            
        } catch (IllegalArgumentException e) {
            // Error de validación
            request.setAttribute("error", e.getMessage());
            request.setAttribute("nombre", request.getParameter("nombre"));
            request.setAttribute("especialidad", request.getParameter("especialidad"));
            request.setAttribute("cedula", request.getParameter("cedula"));
            request.setAttribute("fechaIngreso", request.getParameter("fechaIngreso"));
            request.getRequestDispatcher("jsp/agregarTrabajador.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Error del sistema
            log("Error al guardar trabajador", e);
            request.setAttribute("error", "Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("jsp/error.jsp").forward(request, response);
        }
    }
}