<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Sistema de Salud</title>
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
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-icon {
            font-size: 64px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 20px;
            border-radius: 4px;
            margin: 20px 0;
            border: 1px solid #f5c6cb;
            text-align: left;
        }
        .error-details {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
            border-left: 4px solid #dc3545;
            text-align: left;
        }
        .btn {
            background-color: #dc3545;
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
            background-color: #c82333;
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
        .suggestions {
            background-color: #e2e3e5;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
            text-align: left;
        }
        .suggestions h4 {
            margin-top: 0;
            color: #495057;
        }
        .suggestions ul {
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-icon">⚠</div>
        <h1>Ha ocurrido un error</h1>
        
        <div class="error-message">
            <strong>Mensaje de error:</strong><br>
            <c:choose>
                <c:when test="${not empty error}">
                    ${error}
                </c:when>
                <c:otherwise>
                    Se ha producido un error inesperado en la aplicación.
                </c:otherwise>
            </c:choose>
        </div>
        
        <c:if test="${not empty pageContext.exception}">
            <div class="error-details">
                <h4>Detalles técnicos:</h4>
                <strong>Tipo de excepción:</strong> ${pageContext.exception.class.simpleName}<br>
                <strong>Mensaje:</strong> ${pageContext.exception.message}
            </div>
        </c:if>
        
        <div class="suggestions">
            <h4>Sugerencias para resolver el problema:</h4>
            <ul>
                <li>Verifique que todos los campos obligatorios estén completados correctamente</li>
                <li>Asegúrese de que los datos ingresados tengan el formato correcto</li>
                <li>Intente realizar la operación nuevamente</li>
                <li>Si el problema persiste, contacte al administrador del sistema</li>
            </ul>
        </div>
        
        <div class="actions">
            <button onclick="history.back()" class="btn">Volver Atrás</button>
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=listar" class="btn btn-secondary">Ir a Lista</a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Volver al Inicio</a>
        </div>
    </div>
</body>
</html>