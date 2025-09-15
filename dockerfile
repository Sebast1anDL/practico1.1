# Multi-stage build optimizado para Railway
FROM maven:3.9.4-eclipse-temurin-17-alpine AS build

# Crear directorio de trabajo
WORKDIR /app

# Copiar y descargar dependencias primero (mejor cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests -B

# Etapa de runtime con Wildfly
FROM quay.io/wildfly/wildfly:30.0.1.Final-jdk17

# Cambiar a usuario root temporalmente para configuraciones
USER root

# Crear usuario no-root para seguridad
RUN groupadd -r railway && useradd -r -g railway railway

# Copiar el WAR compilado
COPY --from=build /app/target/trabajador-salud-app.war /opt/jboss/wildfly/standalone/deployments/

# Configurar permisos
RUN chown -R railway:railway /opt/jboss/wildfly/standalone/

# Variables de entorno optimizadas para Railway
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV PATH=$JBOSS_HOME/bin:$PATH

# Configuración de memoria optimizada para Railway (512MB límite típico)
ENV JAVA_OPTS="-Xms128m -Xmx384m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -Djava.net.preferIPv4Stack=true"

# Script de inicio optimizado
RUN cat > /opt/jboss/start.sh << 'EOF'
#!/bin/bash
set -e

echo "=== Iniciando Wildfly en Railway ==="
echo "PORT: ${PORT:-8080}"
echo "JAVA_OPTS: $JAVA_OPTS"

# Verificar deployments
echo "=== Verificando deployments ==="
ls -la /opt/jboss/wildfly/standalone/deployments/

# Configurar logging para Railway
export JBOSS_LOG_MANAGER_ROOT_LOGGER=INFO,CONSOLE

# Iniciar Wildfly con configuración optimizada
exec /opt/jboss/wildfly/bin/standalone.sh \
    -b 0.0.0.0 \
    -bmanagement 0.0.0.0 \
    -Djboss.http.port=${PORT:-8080} \
    -Djboss.management.http.port=${MANAGEMENT_PORT:-9990} \
    -Djava.net.preferIPv4Stack=true \
    -Djboss.server.log.threshold=INFO \
    --server-config=standalone.xml
EOF

# Hacer ejecutable el script
RUN chmod +x /opt/jboss/start.sh

# Cambiar a usuario no-root
USER railway

# Exponer puerto
EXPOSE 8080

# Health check para Railway
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080}/trabajador-salud-app/ || exit 1

# Comando de inicio
CMD ["/opt/jboss/start.sh"]