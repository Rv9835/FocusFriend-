package com.focusfriend.servlet;

import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.User;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if this is an API request
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            handleApiRequest(request, response, session);
        } else {
            // Regular page request
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = userDAO.getUserById(userId);

        // Update user settings
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setDefaultDuration(Integer.parseInt(request.getParameter("defaultDuration")));
        user.setBreakDuration(Integer.parseInt(request.getParameter("breakDuration")));
        user.setAutoStartBreaks(Boolean.parseBoolean(request.getParameter("autoStartBreaks")));
        user.setShowNotifications(Boolean.parseBoolean(request.getParameter("showNotifications")));
        user.setEmailNotifications(Boolean.parseBoolean(request.getParameter("emailNotifications")));
        user.setDailyReport(Boolean.parseBoolean(request.getParameter("dailyReport")));

        userDAO.updateUser(user);

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        // Sample data for testing
        JsonObject settings = new JsonObject();
        settings.addProperty("username", "testuser");
        settings.addProperty("email", "test@example.com");
        settings.addProperty("defaultDuration", 25);
        settings.addProperty("breakDuration", 5);
        settings.addProperty("autoStartBreaks", true);
        settings.addProperty("showNotifications", true);
        settings.addProperty("emailNotifications", false);
        settings.addProperty("dailyReport", true);

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(settings));
    }
} 