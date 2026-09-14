package com.eventsphere.exception;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

/**
 * Global exception handler – catches unhandled exceptions
 * and shows a friendly error page instead of a raw stack trace.
 */
@ControllerAdvice
public class GlobalExceptionHandler {
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler({org.springframework.validation.BindException.class,
            org.springframework.web.bind.MissingServletRequestParameterException.class,
            org.springframework.web.method.annotation.MethodArgumentTypeMismatchException.class,
            IllegalArgumentException.class})
    @org.springframework.web.bind.annotation.ResponseStatus(org.springframework.http.HttpStatus.BAD_REQUEST)
    public String invalidInput(Exception ex, Model model) {
        model.addAttribute("errorMessage", "Please check the submitted values and try again.");
        return "common/error";
    }

    @ExceptionHandler(org.springframework.dao.DataIntegrityViolationException.class)
    @org.springframework.web.bind.annotation.ResponseStatus(org.springframework.http.HttpStatus.CONFLICT)
    public String dataConflict(Exception ex, Model model) {
        model.addAttribute("errorMessage", "This record conflicts with existing data or is still in use. Check related records before changing or deleting it.");
        return "common/error";
    }

    @ExceptionHandler(org.springframework.web.servlet.resource.NoResourceFoundException.class)
    @org.springframework.web.bind.annotation.ResponseStatus(org.springframework.http.HttpStatus.NOT_FOUND)
    public String notFound(Exception ex, Model model) {
        model.addAttribute("errorMessage", "The requested page was not found.");
        return "common/error";
    }

    @ExceptionHandler(Exception.class)
    @org.springframework.web.bind.annotation.ResponseStatus(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleException(Exception ex, Model model) {
        log.error("Request failed", ex);
        model.addAttribute("errorMessage", "An unexpected error occurred. Please check the application log.");
        return "common/error";
    }
}
