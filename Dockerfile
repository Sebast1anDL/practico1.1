# Multi-stage build para Railway con WildFly
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /app

# Copiar y descargar dependencias
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar código fuente y compilar
COPY src ./src
RUN mvn clean package -DskipTests -B

# Etapa de runtime con WildFly
FROM quay.io/wildfly/wildfly:30.0.1.Final-jdk17

# Copiar el WAR compilado
COPY --from=build /app/target/trabajador-salud-app.war /opt/jboss/wildfly/standalone/deployments/

# Variables de entorno para Railway
ENV JAVA_OPTS="-Xms128m -Xmx384m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=128m -Djava.net.preferIPv4Stack=true"

# Exponer puerto
EXPOSE 8080

# Comando de inicio
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-Djboss.http.port=${PORT:-8080}"]