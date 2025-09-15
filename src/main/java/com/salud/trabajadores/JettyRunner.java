package com.salud.trabajadores;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class JettyRunner {
    public static void main(String[] args) throws Exception {
        // Puerto desde variable de entorno o 8080 por defecto
        String portStr = System.getenv("PORT");
        int port = portStr != null ? Integer.parseInt(portStr) : 8080;
        
        Server server = new Server(port);
        
        WebAppContext context = new WebAppContext();
        context.setContextPath("/");
        context.setWar("target/trabajador-salud-app.war");
        context.setParentLoaderPriority(true);
        
        server.setHandler(context);
        
        System.out.println("Iniciando servidor Jetty en puerto " + port);
        server.start();
        server.join();
    }
}