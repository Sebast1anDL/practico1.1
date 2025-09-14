<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Trabajadores - Sistema de Salud</title>
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
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .stats {
            background-color: #e8f4fd;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>Lista de Trabajadores de Salud</h1>
        <div class="stats">
            <strong>Total de trabajadores registrados: 
                <c:choose>
                    <c:when test="${not empty trabajadores}">
                        ${trabajadores.size()}
                    </c:when>
                    <c:otherwise>
                        0
                    </c:otherwise>
                </c:choose>
            </strong>
        </div>
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=agregar" class="btn">Agregar Trabajador</a>
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=buscar" class="btn btn-secondary">Buscar Trabajadores</a>
        </div>
        <c:choose>
            <c:when test="${not empty trabajadores}">
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
                                <td>
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
                <div class="no-data">
                    <h3>No hay trabajadores registrados</h3>
                    <p>Aún no se han registrado trabajadores en el sistema.</p>
                    <p>
                        <a href="${pageContext.request.contextPath}/TrabajadorController?action=agregar" class="btn">
                            Registrar el primer trabajador
                        </a>
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Volver al Inicio</a>
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=buscar" class="btn btn-secondary">Buscar Trabajadores</a>
        </div>
        
        <!-- Información adicional -->
        <div style="margin-top: 20px; text-align: center; color: #666; font-size: 12px;">
            <p>Los trabajadores se muestran en el orden de registro</p>
        </div>
    </div>
</body>
</html>