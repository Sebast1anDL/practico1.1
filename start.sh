#!/bin/bash
set -e

echo "==== Iniciando aplicación Trabajador Salud ===="

# Buscar bootable jar generado por WildFly
BOOTABLE_JAR=$(find ./target -name "*-bootable.jar" -type f | head -n 1)

if [ -n "$BOOTABLE_JAR" ]; then
  echo "Bootable JAR encontrado: $BOOTABLE_JAR"
  exec java -jar "$BOOTABLE_JAR"
else
  echo "Bootable JAR no encontrado. Usando WildFly normal..."
  # Desplegar el .war en WildFly standalone
  WAR_FILE=$(find ./target -name "*.war" -type f | head -n 1)
  if [ -n "$WAR_FILE" ]; then
    echo "WAR encontrado: $WAR_FILE"
    cp "$WAR_FILE" ./wildfly-37.0.1.Final/standalone/deployments/
  fi
  exec ./wildfly-37.0.1.Final/bin/standalone.sh -b 0.0.0.0
fi
