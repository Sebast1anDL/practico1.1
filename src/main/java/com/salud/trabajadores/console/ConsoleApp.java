package com.salud.trabajadores.console;

import com.salud.trabajadores.business.TrabajadorBusinessLocal;
import com.salud.trabajadores.entity.TrabajadorSalud;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Scanner;

/**
 * Aplicación de consola para gestionar trabajadores de salud
 * Esta versión simula el comportamiento sin EJB para pruebas locales
 */
public class ConsoleApp {
    
    private Scanner scanner;
    private TrabajadorBusinessLocal trabajadorBusiness;
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    public ConsoleApp() {
        this.scanner = new Scanner(System.in);
        // TODO: En un entorno real, aquí inyectaríamos el EJB
        // Por ahora, para testing, crearemos una instancia simulada
    }
    
    public static void main(String[] args) {
        System.out.println("=== SISTEMA DE GESTIÓN DE TRABAJADORES DE SALUD ===");
        System.out.println("Versión: Aplicación de Consola");
        System.out.println();
        
        ConsoleApp app = new ConsoleApp();
        app.ejecutar();
    }
    
    public void ejecutar() {
        mostrarBienvenida();
        
        boolean continuar = true;
        while (continuar) {
            try {
                mostrarMenu();
                int opcion = leerOpcion();
                
                switch (opcion) {
                    case 1:
                        agregarTrabajador();
                        break;
                    case 2:
                        listarTrabajadores();
                        break;
                    case 3:
                        buscarPorEspecialidad();
                        break;
                    case 4:
                        buscarPorCedula();
                        break;
                    case 0:
                        continuar = false;
                        System.out.println("¡Gracias por usar el sistema!");
                        break;
                    default:
                        System.out.println("Opción no válida. Intente nuevamente.");
                }
                
                if (continuar) {
                    System.out.println("\nPresione ENTER para continuar...");
                    scanner.nextLine();
                }
                
            } catch (Exception e) {
                System.err.println("Error: " + e.getMessage());
                System.out.println("\nPresione ENTER para continuar...");
                scanner.nextLine();
            }
        }
        
        scanner.close();
    }
    
    private void mostrarBienvenida() {
        System.out.println("Bienvenido al Sistema de Gestión de Trabajadores de Salud");
        System.out.println("========================================================");
        System.out.println();
    }
    
    private void mostrarMenu() {
        System.out.println("\n--- MENÚ PRINCIPAL ---");
        System.out.println("1. Agregar Trabajador");
        System.out.println("2. Listar Todos los Trabajadores");
        System.out.println("3. Buscar por Especialidad");
        System.out.println("4. Buscar por Cédula");
        System.out.println("0. Salir");
        System.out.print("\nSeleccione una opción: ");
    }
    
    private int leerOpcion() {
        try {
            String input = scanner.nextLine();
            return Integer.parseInt(input);
        } catch (NumberFormatException e) {
            return -1; // Opción inválida
        }
    }
    
    private void agregarTrabajador() {
        System.out.println("\n--- AGREGAR NUEVO TRABAJADOR ---");
        
        try {
            // Leer datos del trabajador
            System.out.print("Nombre completo: ");
            String nombre = scanner.nextLine();
            
            System.out.print("Especialidad: ");
            String especialidad = scanner.nextLine();
            
            System.out.print("Cédula (sin puntos ni guiones): ");
            String cedula = scanner.nextLine();
            
            System.out.print("Fecha de ingreso (dd/MM/yyyy): ");
            String fechaStr = scanner.nextLine();
            LocalDate fechaIngreso = LocalDate.parse(fechaStr, dateFormatter);
            
            // Crear el trabajador
            TrabajadorSalud trabajador = new TrabajadorSalud(nombre, especialidad, fechaIngreso, cedula);
            
            // TODO: Aquí llamaríamos al EJB
            // TrabajadorSalud trabajadorAgregado = trabajadorBusiness.agregarTrabajador(trabajador);
            
            // Simulamos por ahora
            System.out.println("\n✓ Trabajador agregado exitosamente:");
            System.out.println("  ID: [Será asignado por el sistema]");
            System.out.println("  Nombre: " + trabajador.getNombre());
            System.out.println("  Especialidad: " + trabajador.getEspecialidad());
            System.out.println("  Cédula: " + trabajador.getCedula());
            System.out.println("  Fecha de Ingreso: " + trabajador.getFechaIngreso().format(dateFormatter));
            
        } catch (DateTimeParseException e) {
            System.err.println("Error: Formato de fecha inválido. Use dd/MM/yyyy");
        } catch (Exception e) {
            System.err.println("Error al agregar trabajador: " + e.getMessage());
        }
    }
    
    private void listarTrabajadores() {
        System.out.println("\n--- LISTA DE TRABAJADORES ---");
        
        try {
            // TODO: Aquí llamaríamos al EJB
            // List<TrabajadorSalud> trabajadores = trabajadorBusiness.obtenerTrabajadores();
            
            // Simulamos por ahora
            System.out.println("Conectando con la capa de negocio...");
            System.out.println("(En implementación real se mostrarían todos los trabajadores)");
            System.out.println();
            System.out.println("Ejemplo de salida:");
            System.out.println("ID | Nombre                | Especialidad    | Cédula   | Fecha Ingreso");
            System.out.println("---|----------------------|-----------------|----------|---------------");
            System.out.println("1  | Dr. Juan Pérez       | Cardiología     | 12345678 | 15/03/2020");
            System.out.println("2  | Dra. María González  | Pediatría       | 87654321 | 22/07/2018");
            System.out.println("3  | Enf. Carlos Rodríguez| Enfermería      | 11223344 | 10/01/2021");
            
        } catch (Exception e) {
            System.err.println("Error al obtener trabajadores: " + e.getMessage());
        }
    }
    
    private void buscarPorEspecialidad() {
        System.out.println("\n--- BUSCAR POR ESPECIALIDAD ---");
        
        try {
            System.out.print("Ingrese la especialidad a buscar: ");
            String especialidad = scanner.nextLine();
            
            // TODO: Aquí llamaríamos al EJB
            // List<TrabajadorSalud> trabajadores = trabajadorBusiness.buscarTrabajadoresPorEspecialidad(especialidad);
            
            // Simulamos por ahora
            System.out.println("Buscando trabajadores con especialidad: '" + especialidad + "'...");
            System.out.println("(En implementación real se mostrarían los resultados filtrados)");
            
        } catch (Exception e) {
            System.err.println("Error en la búsqueda: " + e.getMessage());
        }
    }
    
    private void buscarPorCedula() {
        System.out.println("\n--- BUSCAR POR CÉDULA ---");
        
        try {
            System.out.print("Ingrese la cédula a buscar: ");
            String cedula = scanner.nextLine();
            
            // TODO: Aquí llamaríamos al EJB
            // TrabajadorSalud trabajador = trabajadorBusiness.obtenerTrabajadorPorCedula(cedula);
            
            // Simulamos por ahora
            System.out.println("Buscando trabajador con cédula: '" + cedula + "'...");
            System.out.println("(En implementación real se mostraría el trabajador encontrado o mensaje de 'no encontrado')");
            
        } catch (Exception e) {
            System.err.println("Error en la búsqueda: " + e.getMessage());
        }
    }
    
    /**
     * Método para testing - permite inyectar el business bean
     */
    public void setTrabajadorBusiness(TrabajadorBusinessLocal trabajadorBusiness) {
        this.trabajadorBusiness = trabajadorBusiness;
    }
}