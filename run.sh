#!/bin/bash
set -e

echo "=== Iniciando aplicación Jakarta EE en Railway ==="

# Variables de entorno
export JAVA_OPTS="-Xms128m -Xmx384m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=128m"
export WILDFLY_VERSION="30.0.1.Final"
export WILDFLY_DIR="/tmp/wildfly"

# Crear directorio temporal
mkdir -p $WILDFLY_DIR

# Descargar WildFly
echo "Descargando WildFly $WILDFLY_VERSION..."
cd $WILDFLY_DIR
wget -q "https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz"
tar -xzf "wildfly-$WILDFLY_VERSION.tar.gz"
mv "wildfly-$WILDFLY_VERSION" wildfly

# Compilar la aplicación (debería estar ya compilada por Nixpacks)
if [ ! -f "target/trabajador-salud-app.war" ]; then
    echo "Compilando aplicación..."
    cd /app
    mvn clean package -DskipTests
    cd $WILDFLY_DIR
fi

# Copiar WAR a WildFly
echo "Desplegando aplicación..."
cp /app/target/trabajador-salud-app.war $WILDFLY_DIR/wildfly/standalone/deployments/

# Iniciar WildFly
echo "Iniciando WildFly en puerto ${PORT:-8080}..."
cd $WILDFLY_DIR/wildfly
exec ./bin/standalone.sh -b 0.0.0.0 -Djboss.http.port=${PORT:-8080}