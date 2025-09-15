FROM maven:3.9.4-eclipse-temurin-17 AS build

COPY pom.xml /app/
COPY src /app/src/
WORKDIR /app

RUN mvn clean package -DskipTests

FROM quay.io/wildfly/wildfly:30.0.1.Final-jdk17

# Copiar el WAR compilado
COPY --from=build /app/target/trabajador-salud-app.war /opt/jboss/wildfly/standalone/deployments/

# Variables de entorno
ENV JBOSS_HOME=/opt/jboss/wildfly
ENV PATH=$JBOSS_HOME/bin:$PATH

# Configurar memoria limitada para Railway
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=256m"

# Script de inicio personalizado
COPY --chmod=755 <<EOF /opt/jboss/start.sh
#!/bin/bash
echo "=== Iniciando Wildfly en Railway con Docker ==="
echo "PORT: \$PORT"
echo "JAVA_OPTS: \$JAVA_OPTS"

echo "=== Archivos en deployments ==="
ls -la /opt/jboss/wildfly/standalone/deployments/

exec /opt/jboss/wildfly/bin/standalone.sh \\
  -b 0.0.0.0 \\
  -bmanagement 0.0.0.0 \\
  -Djboss.http.port=\${PORT:-8080} \\
  -Djava.net.preferIPv4Stack=true
EOF

USER jboss

EXPOSE 8080

CMD ["/opt/jboss/start.sh"]