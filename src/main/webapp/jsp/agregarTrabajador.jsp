<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agregar Trabajador - Sistema de Salud</title>
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"], input[type="date"] {
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
            padding: 12px 24px;
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
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Agregar Nuevo Trabajador</h1>
        
        <!-- Errores que podria tener la pagina, se manejan aca -->
        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/TrabajadorController" method="post">
            <input type="hidden" name="action" value="guardar">
            
            <div class="form-group">
                <label for="nombre">Nombre Completo *</label>
                <input type="text" id="nombre" name="nombre" 
                       value="${param.nombre}" 
                       placeholder="Ej: Dr. Juan Pérez" 
                       required>
                <div class="help-text">Ingrese el nombre y apellido del trabajador</div>
            </div>
            
            <div class="form-group">
                <label for="especialidad">Especialidad *</label>
                <input type="text" id="especialidad" name="especialidad" 
                       value="${param.especialidad}" 
                       placeholder="Ej: Cardiología, Enfermería, Pediatría" 
                       required>
                <div class="help-text">Área de especialización del trabajador</div>
            </div>
            
            <div class="form-group">
                <label for="cedula">Cédula de Identidad *</label>
                <input type="text" id="cedula" name="cedula" 
                       value="${param.cedula}" 
                       placeholder="Ej: 12345678" 
                       pattern="[0-9]{7,8}"
                       required>
                <div class="help-text">Ingrese solo números, sin puntos ni guiones (7-8 dígitos)</div>
            </div>
            
            <div class="form-group">
                <label for="fechaIngreso">Fecha de Ingreso *</label>
                <input type="date" id="fechaIngreso" name="fechaIngreso" 
                       value="${param.fechaIngreso}" 
                       required>
                <div class="help-text">Fecha en que el trabajador comenzó a trabajar</div>
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn">Guardar Trabajador</button>
                <button type="reset" class="btn btn-secondary">Limpiar Formulario</button>
            </div>
        </form>
        
        <div class="navigation">
            <p>
                <a href="${pageContext.request.contextPath}/index.jsp">Volver al Inicio</a>
            </p>
        </div>
    </div>
</body>
</html>