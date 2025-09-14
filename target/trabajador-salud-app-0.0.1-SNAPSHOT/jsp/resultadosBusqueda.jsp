<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados de Búsqueda - Sistema de Salud</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1000px;
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
        .search-info {
            background-color: #e8f4fd;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        .results-count {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #c3e6cb;
        }
        .no-results {
            background-color: #f8d7da;
            color: #721c24;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #f5c6cb;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e8f5e8;
        }
        .navigation {
            text-align: center;
            margin: 20px 0;
        }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            margin: 0 5px;
        }
        .btn:hover {
            background-color: #45a049;
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
        .id-column {
            width: 60px;
            text-align: center;
        }
        .cedula-column {
            width: 100px;
            text-align: center;
        }
        .fecha-column {
            width: 120px;
            text-align: center;
        }
        .highlight {
            background-color: #fff3cd;
            font-weight: bold;
        }
        .suggestions {
            text-align: left;
            display: inline-block;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Resultados de Búsqueda</h1>
        
        <!-- Información de la búsqueda -->
        <div class="search-info">
            <strong>Búsqueda realizada por: 
                <c:out value="${criterioBusqueda != null ? criterioBusqueda : 'No especificado'}" />
            </strong>
        </div>
        
        <!-- Resultados -->
        <c:choose>
            <c:when test="${not empty trabajadores}">
                <!-- Contador de resultados -->
                <div class="results-count">
                    Se encontraron <strong>${trabajadores.size()}</strong> 
                    ${trabajadores.size() == 1 ? 'trabajador' : 'trabajadores'}
                    que coinciden con la búsqueda.
                </div>
                
                <!-- Tabla de resultados -->
                <table>
                    <thead>
                        <tr>
                            <th class="id-column">ID</th>
                            <th>Nombre</th>
                            <th>Especialidad</th>
                            <th class="cedula-column">Cédula</th>
                            <th class="fecha-column">Fecha Ingreso</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="trabajador" items="${trabajadores}">
                            <tr>
                                <td class="id-column">
                                    <c:out value="${trabajador.id != null ? trabajador.id : '-'}" />
                                </td>
                                <td>
                                    <c:out value="${trabajador.nombre != null ? trabajador.nombre : '-'}" />
                                </td>
                                <td class="highlight">
                                    <c:out value="${trabajador.especialidad != null ? trabajador.especialidad : '-'}" />
                                </td>
                                <td class="cedula-column">
                                    <c:out value="${trabajador.cedula != null ? trabajador.cedula : '-'}" />
                                </td>
                                <td class="fecha-column">
                                    <!-- Uso el método helper para formatear la fecha -->
                                    <c:choose>
                                        <c:when test="${trabajador.fechaIngresoFormatted != null && trabajador.fechaIngresoFormatted != ''}">
                                            <c:out value="${trabajador.fechaIngresoFormatted}" />
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <!-- Sin resultados -->
                <div class="no-results">
                    <h3>No se encontraron resultados</h3>
                    <p>No hay trabajadores que coincidan con el criterio de búsqueda: 
                       <strong><c:out value="${criterioBusqueda != null ? criterioBusqueda : 'No especificado'}" /></strong>
                    </p>
                    <p>Sugerencias:</p>
                    <div class="suggestions">
                        <ul>
                            <li>Verifica que los datos estén escritos correctamente</li>
                            <li>Intenta con criterios de búsqueda más generales</li>
                            <li>Revisa que el trabajador esté registrado en el sistema</li>
                        </ul>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- Navegación -->
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=buscar" class="btn">Nueva Búsqueda</a>
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=listar" class="btn btn-secondary">Ver Todos</a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Inicio</a>
        </div>
        
        <!-- Información adicional -->
        <c:if test="${not empty trabajadores}">
            <div style="margin-top: 20px; text-align: center; color: #666; font-size: 12px;">
                <p>Los resultados se muestran ordenados por fecha de registro</p>
            </div>
        </c:if>
    </div>
</body>
</html>