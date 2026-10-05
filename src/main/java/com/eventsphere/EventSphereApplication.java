package com.eventsphere;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Main entry point for the Spring Boot application.
 * Extends SpringBootServletInitializer to support WAR deployment
 * on an external Tomcat server if needed.
 */
@SpringBootApplication
public class EventSphereApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(EventSphereApplication.class, args);
    }
}
