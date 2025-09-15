#!/bin/bash

# Variables
WILDFLY_HOME="./target/wildfly-30.0.1.Final"
WAR_FILE="./target/trabajador-salud-app.war"
PORT=${PORT:-8080}

echo "Iniciando Wildfly en Railway..."
echo "WILDFLY_HOME: $WILDFLY_HOME"
echo "PORT: $PORT"
echo "WAR_FILE: $WAR_FILE"

# Verificar que Wildfly existe
if [ ! -d "$WILDFLY_HOME" ]; then
    echo "ERROR: Wildfly no encontrado en $WILDFLY_HOME"
    echo "Contenido del directorio target:"
    ls -la ./target/
    exit 1
fi

# Verificar que el WAR existe
if [ ! -f "$WAR_FILE" ]; then
    echo "ERROR: WAR file no encontrado en $WAR_FILE"
    echo "Contenido del directorio target:"
    ls -la ./target/
    exit 1
fi

# Copiar WAR al directorio deployments
echo "Copiando WAR a deployments..."
cp "$WAR_FILE" "$WILDFLY_HOME/standalone/deployments/"

# Configurar el puerto
echo "Configurando puerto $PORT..."

# Iniciar Wildfly
echo "Iniciando Wildfly..."
cd "$WILDFLY_HOME"

# Ejecutar Wildfly con configuración para Railway
exec ./bin/standalone.sh \
  -b 0.0.0.0 \
  -bmanagement 0.0.0.0 \
  -Djboss.http.port=$PORT \
  -Djboss.https.port=$((PORT + 363)) \
  -Djboss.management.http.port=$((PORT + 1000)) \
  --server-config=standalone.xml