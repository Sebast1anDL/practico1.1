#!/bin/bash

# Script de inicio para Railway
echo "🚀 Iniciando aplicación Jakarta EE en Railway..."

# Variables de entorno
export JAVA_OPTS="-Xmx512m -Xms256m -Djava.net.preferIPv4Stack=true"
export PORT="${PORT:-8080}"

# Buscar el bootable JAR (creado por el perfil production)
BOOTABLE_JAR=$(find ./target -name "*-bootable.jar" -type f | head -n 1)

if [ -n "$BOOTABLE_JAR" ] && [ -f "$BOOTABLE_JAR" ]; then
    echo "✅ Usando bootable JAR: $BOOTABLE_JAR"
    echo "🚀 Iniciando aplicación en puerto $PORT..."
    exec java $JAVA_OPTS \
        -Djboss.http.port="$PORT" \
        -Djboss.bind.address=0.0.0.0 \
        -jar "$BOOTABLE_JAR"
else
    echo "⚠️  Bootable JAR no encontrado, usando Wildfly tradicional..."
    
    # Fallback al método tradicional
    export JBOSS_HOME="./target/wildfly-32.0.1.Final"
    
    # Verificar que Wildfly esté disponible
    if [ ! -d "$JBOSS_HOME" ]; then
        echo "❌ Wildfly no encontrado en $JBOSS_HOME"
        echo "📦 Ejecutando maven para descargar Wildfly..."
        mvn clean package -DskipTests
    fi

    # Verificar que el WAR existe
    WAR_FILE="./target/trabajador-salud-app.war"
    if [ ! -f "$WAR_FILE" ]; then
        echo "❌ Archivo WAR no encontrado: $WAR_FILE"
        exit 1
    fi

    # Copiar WAR a deployments si no existe
    if [ ! -f "$JBOSS_HOME/standalone/deployments/trabajador-salud-app.war" ]; then
        echo "📋 Copiando WAR a directorio de despliegue..."
        cp "$WAR_FILE" "$JBOSS_HOME/standalone/deployments/"
    fi

    # Iniciar Wildfly tradicional
    echo "🚀 Iniciando Wildfly en puerto $PORT..."
    cd "$JBOSS_HOME/bin"
    
    exec ./standalone.sh \
        -b 0.0.0.0 \
        -bmanagement 0.0.0.0 \
        -Djboss.http.port="$PORT" \
        -Djboss.management.http.port="${MGMT_PORT:-9990}"
fi