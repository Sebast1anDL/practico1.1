#!/bin/bash

# Script de inicio para Railway
echo "🚀 Iniciando aplicación Jakarta EE en Railway..."

# Variables de entorno
export JAVA_OPTS="-Xmx512m -Xms256m"
export JBOSS_HOME="./target/wildfly-32.0.1.Final"
export PORT="${PORT:-8080}"

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
    echo "📦 Compilando aplicación..."
    mvn clean package -DskipTests
fi

# Copiar WAR a deployments si no existe
if [ ! -f "$JBOSS_HOME/standalone/deployments/trabajador-salud-app.war" ]; then
    echo "📋 Copiando WAR a directorio de despliegue..."
    cp "$WAR_FILE" "$JBOSS_HOME/standalone/deployments/"
fi

# Configurar Wildfly para Railway
echo "⚙️  Configurando Wildfly..."

# Crear archivo de configuración personalizado
cat > "$JBOSS_HOME/standalone/configuration/standalone-railway.xml" << 'EOF'
<?xml version='1.0' encoding='UTF-8'?>
<server xmlns="urn:jboss:domain:20.0">
    <extensions>
        <extension module="org.jboss.as.connector"/>
        <extension module="org.jboss.as.deployment-scanner"/>
        <extension module="org.jboss.as.ee"/>
        <extension module="org.jboss.as.ejb3"/>
        <extension module="org.jboss.as.jaxrs"/>
        <extension module="org.jboss.as.jpa"/>
        <extension module="org.jboss.as.jsf"/>
        <extension module="org.jboss.as.logging"/>
        <extension module="org.jboss.as.naming"/>
        <extension module="org.jboss.as.security"/>
        <extension module="org.jboss.as.transactions"/>
        <extension module="org.jboss.as.undertow"/>
        <extension module="org.jboss.as.weld"/>
    </extensions>
    <management>
        <security-realms>
            <security-realm name="ManagementRealm">
                <authentication>
                    <local default-user="$local"/>
                </authentication>
            </security-realm>
        </security-realms>
        <management-interfaces>
            <http-interface security-realm="ManagementRealm">
                <http-upgrade enabled="true"/>
                <socket-binding name="management-http"/>
            </http-interface>
        </management-interfaces>
    </management>
    <profile>
        <subsystem xmlns="urn:jboss:domain:logging:8.0">
            <console-handler name="CONSOLE">
                <level name="INFO"/>
                <formatter>
                    <named-formatter name="COLOR-PATTERN"/>
                </formatter>
            </console-handler>
            <root-logger>
                <level name="INFO"/>
                <handlers>
                    <handler name="CONSOLE"/>
                </handlers>
            </root-logger>
            <formatter name="COLOR-PATTERN" class="org.jboss.logmanager.formatters.PatternFormatter">
                <properties>
                    <property name="pattern" value="%K{level}%d{HH:mm:ss,SSS} %-5p [%c] (%t) %s%e%n"/>
                </properties>
            </formatter>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:deployment-scanner:2.0">
            <deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000"/>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:ee:6.0">
            <spec-descriptor-property-replacement>false</spec-descriptor-property-replacement>
            <concurrent>
                <context-services>
                    <context-service name="default" jndi-name="java:jboss/ee/concurrency/context/default" use-transaction-setup-provider="true"/>
                </context-services>
                <managed-thread-factories>
                    <managed-thread-factory name="default" jndi-name="java:jboss/ee/concurrency/factory/default" context-service="default"/>
                </managed-thread-factories>
                <managed-executor-services>
                    <managed-executor-service name="default" jndi-name="java:jboss/ee/concurrency/executor/default" context-service="default" hung-task-threshold="60000" keepalive-time="5000"/>
                </managed-executor-services>
                <managed-scheduled-executor-services>
                    <managed-scheduled-executor-service name="default" jndi-name="java:jboss/ee/concurrency/scheduler/default" context-service="default" hung-task-threshold="60000" keepalive-time="3000"/>
                </managed-scheduled-executor-services>
            </concurrent>
            <default-bindings context-service="java:jboss/ee/concurrency/context/default" managed-executor-service="java:jboss/ee/concurrency/executor/default" managed-scheduled-executor-service="java:jboss/ee/concurrency/scheduler/default" managed-thread-factory="java:jboss/ee/concurrency/factory/default"/>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:ejb3:10.0">
            <session-bean>
                <stateless>
                    <bean-instance-pool-ref pool-name="slsb-strict-max-pool"/>
                </stateless>
                <stateful default-access-timeout="5000" cache-ref="simple" passivation-disabled-cache-ref="simple"/>
                <singleton default-access-timeout="5000"/>
            </session-bean>
            <pools>
                <bean-instance-pools>
                    <strict-max-pool name="slsb-strict-max-pool" derive-size="from-worker-pools" instance-acquisition-timeout="5" instance-acquisition-timeout-unit="MINUTES"/>
                    <strict-max-pool name="mdb-strict-max-pool" derive-size="from-cpu-count" instance-acquisition-timeout="5" instance-acquisition-timeout-unit="MINUTES"/>
                </bean-instance-pools>
            </pools>
            <caches>
                <cache name="simple"/>
            </caches>
            <async thread-pool-name="default"/>
            <timer-service thread-pool-name="default" default-data-store="default-file-store">
                <data-stores>
                    <file-data-store name="default-file-store" path="timer-service-data" relative-to="jboss.server.data.dir"/>
                </data-stores>
            </timer-service>
            <remote cluster="ejb" connectors="http-remoting-connector" thread-pool-name="default">
                <channel-creation-options>
                    <option name="MAX_OUTBOUND_MESSAGES" value="1234" type="remoting"/>
                </channel-creation-options>
            </remote>
            <thread-pools>
                <thread-pool name="default">
                    <max-threads count="10"/>
                    <keepalive-time time="60" unit="seconds"/>
                </thread-pool>
            </thread-pools>
            <default-security-domain value="other"/>
            <default-missing-method-permissions-deny-access value="true"/>
            <log-system-exceptions value="true"/>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:undertow:12.0">
            <buffer-cache name="default"/>
            <server name="default-server">
                <http-listener name="default" socket-binding="http" redirect-socket="https" enable-http2="true"/>
                <host name="default-host" alias="localhost">
                    <location name="/" handler="welcome-content"/>
                    <http-invoker http-authentication-factory="application-http-authentication"/>
                </host>
            </server>
            <servlet-container name="default">
                <jsp-config/>
                <websockets/>
            </servlet-container>
            <handlers>
                <file name="welcome-content" path="${jboss.home.dir}/welcome-content"/>
            </handlers>
        </subsystem>
        <subsystem xmlns="urn:jboss:domain:transactions:6.0">
            <core-environment node-identifier="${jboss.tx.node.id:1}">
                <process-id>
                    <uuid/>
                </process-id>
            </core-environment>
            <recovery-environment socket-binding="txn-recovery-environment" status-socket-binding="txn-status-manager"/>
            <coordinator-environment statistics-enabled="${wildfly.transactions.statistics-enabled:${wildfly.statistics-enabled:false}}"/>
            <object-store path="tx-object-store" relative-to="jboss.server.data.dir"/>
        </subsystem>
    </profile>
    <interfaces>
        <interface name="management">
            <any-address/>
        </interface>
        <interface name="public">
            <any-address/>
        </interface>
    </interfaces>
    <socket-binding-group name="standard-sockets" default-interface="public" port-offset="${jboss.socket.binding.port-offset:0}">
        <socket-binding name="management-http" interface="management" port="${jboss.management.http.port:9990}"/>
        <socket-binding name="http" port="${jboss.http.port:8080}"/>
        <socket-binding name="https" port="${jboss.https.port:8443}"/>
        <socket-binding name="txn-recovery-environment" port="4712"/>
        <socket-binding name="txn-status-manager" port="4713"/>
        <outbound-socket-binding name="http-remoting-connector">
            <remote-destination host="localhost" port="8080"/>
        </outbound-socket-binding>
    </socket-binding-group>
</server>
EOF

# Iniciar Wildfly
echo "🚀 Iniciando Wildfly en puerto $PORT..."
cd "$JBOSS_HOME/bin"

# Usar configuración personalizada si existe, sino usar la estándar
if [ -f "../standalone/configuration/standalone-railway.xml" ]; then
    CONFIG="standalone-railway.xml"
else
    CONFIG="standalone.xml"
fi

exec ./standalone.sh \
    -b 0.0.0.0 \
    -bmanagement 0.0.0.0 \
    -Djboss.http.port="$PORT" \
    -Djboss.management.http.port="${MGMT_PORT:-9990}" \
    -c "$CONFIG" \
    --server-config="$CONFIG"