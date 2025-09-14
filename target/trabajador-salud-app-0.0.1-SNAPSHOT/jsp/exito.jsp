<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Operación Exitosa - Sistema de Salud</title>
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
            text-align: center;
        }
        h1 {
            color: #28a745;
            margin-bottom: 20px;
        }
        .success-icon {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 20px;
            border-radius: 4px;
            margin: 20px 0;
            border: 1px solid #c3e6cb;
        }
        .trabajador-info {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
            margin: 20px 0;
            border-left: 4px solid #28a745;
            text-align: left;
        }
        .info-row {
            margin: 10px 0;
            display: flex;
            justify-content: space-between;
        }
        .info-label {
            font-weight: bold;
            color: #333;
        }
        .info-value {
            color: #666;
        }
        .btn {
            background-color: #28a745;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #218838;
            color: white;
            text-decoration: none;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #545b62;
            color: white;
        }
        .actions {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">✓</div>
        <h1>¡Operación Exitosamente exitosa!</h1>
        
        <div class="success-message">
            <strong><c:out value="${mensaje}" /></strong>
        </div>
        
        <c:if test="${not empty trabajador}">
            <div class="trabajador-info">
                <h3>Datos del Trabajador Registrado:</h3>
                
                <div class="info-row">
                    <span class="info-label">Nombre:</span>
                    <span class="info-value"><c:out value="${trabajador.nombre}" /></span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Especialidad:</span>
                    <span class="info-value"><c:out value="${trabajador.especialidad}" /></span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Cédula:</span>
                    <span class="info-value"><c:out value="${trabajador.cedula}" /></span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Fecha de Ingreso:</span>
                    <span class="info-value">
                        <!-- Usar el método helper para formatear la fecha -->
                        <c:out value="${trabajador.fechaIngresoFormatted}" />
                    </span>
                </div>
                
                <c:if test="${not empty trabajador.id}">
                    <div class="info-row">
                        <span class="info-label">ID Asignado:</span>
                        <span class="info-value"><c:out value="${trabajador.id}" /></span>
                    </div>
                </c:if>
            </div>
        </c:if>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=agregar" class="btn">Agregar Otro Trabajador</a>
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=listar" class="btn btn-secondary">Ver Lista Completa</a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Volver al Inicio</a>
        </div>
    </div>
</body>
</html>