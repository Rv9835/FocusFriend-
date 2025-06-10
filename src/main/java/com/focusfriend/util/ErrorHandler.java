package com.focusfriend.util;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ErrorHandler {
    private static final Logger logger = Logger.getLogger(ErrorHandler.class.getName());

    public static void handleError(HttpServletRequest request, HttpServletResponse response, 
            String errorMessage, String redirectPage) throws ServletException, IOException {
        logger.log(Level.WARNING, "Error: " + errorMessage);
        request.setAttribute("error", errorMessage);
        RequestDispatcher dispatcher = request.getRequestDispatcher(redirectPage);
        dispatcher.forward(request, response);
    }

    public static void handleError(HttpServletRequest request, HttpServletResponse response, 
            Exception e, String redirectPage) throws ServletException, IOException {
        logger.log(Level.SEVERE, "Error occurred", e);
        request.setAttribute("error", e.getMessage());
        RequestDispatcher dispatcher = request.getRequestDispatcher(redirectPage);
        dispatcher.forward(request, response);
    }

    public static void handleValidationError(HttpServletRequest request, HttpServletResponse response, 
                                          String field, String message) throws IOException {
        request.setAttribute("validationError", true);
        request.setAttribute("errorField", field);
        request.setAttribute("errorMessage", message);
        
        try {
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error forwarding to error page", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, message);
        }
    }
} 