package com.eventsphere;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * EventSphere – Web-Based Event Planning System
 * SE2030 | Group 2026-Y2-S1-KU-28
 *
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
