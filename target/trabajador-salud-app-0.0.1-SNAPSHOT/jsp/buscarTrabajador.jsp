<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscar Trabajadores - Sistema de Salud</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c5aa0;
            text-align: center;
            margin-bottom: 30px;
        }
        .search-option {
            background-color: #f8f9fa;
            padding: 20px;
            margin: 15px 0;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
        }
        .search-option h3 {
            color: #2c5aa0;
            margin-top: 0;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        input:focus {
            border-color: #4CAF50;
            outline: none;
        }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover {
            background-color: #45a049;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #545b62;
            color: white;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .help-text {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        .navigation {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Buscar Trabajadores</h1>
        
        <!-- Veo el error si es que hay -->
        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>
        
        <!-- Búsqueda por Especialidad -->
        <div class="search-option">
            <h3>Buscar por Especialidad</h3>
            <p>Encuentra todos los trabajadores que pertenecen a una especialidad específica.</p>
            
            <form action="${pageContext.request.contextPath}/TrabajadorController" method="get">
                <input type="hidden" name="action" value="buscarPorEspecialidad">
                
                <div class="form-group">
                    <label for="especialidad">Especialidad:</label>
                    <input type="text" id="especialidad" name="especialidad" 
                           placeholder="Ej: Cardiología, Enfermería, Pediatría" 
                           required>
                    <div class="help-text">Ingrese parte o el nombre completo de la especialidad</div>
                </div>
                
                <button type="submit" class="btn">Buscar por Especialidad</button>
            </form>
        </div>
        
        <!-- Búsqueda por Cédula -->
        <div class="search-option">
            <h3>Buscar por Cédula</h3>
            <p>Encuentra un trabajador específico usando su cédula de identidad.</p>
            
            <form action="${pageContext.request.contextPath}/TrabajadorController" method="get">
                <input type="hidden" name="action" value="buscarPorCedula">
                
                <div class="form-group">
                    <label for="cedula">Cédula de Identidad:</label>
                    <input type="text" id="cedula" name="cedula" 
                           placeholder="Ej: 12345678" 
                           pattern="[0-9]{7,8}"
                           required>
                    <div class="help-text">Ingrese solo números, sin puntos ni guiones (7-8 dígitos)</div>
                </div>
                
                <button type="submit" class="btn">Buscar por Cédula</button>
            </form>
        </div>
        
        <!-- Navegación -->
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Volver al Inicio</a>
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=listar" class="btn btn-secondary">Ver Todos los Trabajadores</a>
        </div>
        
        <!-- Información adicional -->
        <div style="margin-top: 30px; padding: 15px; background-color: #e8f4fd; border-radius: 4px;">
            <h4>Consejos de búsqueda:</h4>
            <ul>
                <li><strong>Especialidad:</strong> No necesitas escribir el nombre completo. Por ejemplo, "cardio" encontrará "Cardiología".</li>
                <li><strong>Cédula:</strong> Debe ser exacta y sin puntos ni guiones.</li>
                <li>Las búsquedas no distinguen entre mayúsculas y minúsculas.</li>
            </ul>
        </div>
    </div>
</body>
</html>