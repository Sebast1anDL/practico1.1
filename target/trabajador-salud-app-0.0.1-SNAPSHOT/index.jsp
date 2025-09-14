<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Trabajadores de Salud</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
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
        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .menu-item {
            background: #4CAF50;
            color: white;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .menu-item:hover {
            background: #45a049;
            color: white;
            text-decoration: none;
        }
        .description {
            text-align: center;
            margin: 20px 0;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Sistema de Gestión de Trabajadores de Salud</h1>
        
        <div class="description">
            <p>Bienvenido al sistema de gestión de trabajadores de salud.</p>
            <p>Seleccione una opción del menú para comenzar.</p>
        </div>
        
        <div class="menu">
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=agregar" class="menu-item">
                <h3>Agregar Trabajador</h3>
                <p>Registrar un nuevo trabajador de salud</p>
            </a>
            
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=listar" class="menu-item">
                <h3>Listar Trabajadores</h3>
                <p>Ver todos los trabajadores registrados</p>
            </a>
            
            <a href="${pageContext.request.contextPath}/TrabajadorController?action=buscar" class="menu-item">
                <h3>Buscar Trabajadores</h3>
                <p>Buscar por especialidad o cédula</p>
            </a>
        </div>
        
        <div style="margin-top: 30px; text-align: center; color: #888; font-size: 12px;">
            <p>Sistema desarrollado por Sebastián Di Loreto - Práctico 1</p>
        </div>
    </div>
</body>
</html>