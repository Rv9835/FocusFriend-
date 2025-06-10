package com.focusfriend.servlet;

import com.focusfriend.dao.FocusSessionDAO;
import com.focusfriend.dao.TaskDAO;
import com.focusfriend.model.FocusSession;
import com.focusfriend.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FocusSessionDAO focusSessionDAO;
    private TaskDAO taskDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        focusSessionDAO = new FocusSessionDAO();
        taskDAO = new TaskDAO();
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
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
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

        // Handle focus session start
        String action = request.getParameter("action");
        if ("startSession".equals(action)) {
            handleStartSession(request, response, session);
        } else if ("endSession".equals(action)) {
            handleEndSession(request, response, session);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        // Sample data for testing
        JsonObject jsonResponse = new JsonObject();
        
        // Statistics
        jsonResponse.addProperty("totalFocusTime", 120); // 2 hours
        jsonResponse.addProperty("completedSessions", 5);
        jsonResponse.addProperty("averageSessionLength", 24); // 24 minutes

        // Recent Tasks
        JsonArray recentTasks = new JsonArray();
        JsonObject task1 = new JsonObject();
        task1.addProperty("title", "Complete Project Report");
        task1.addProperty("completed", false);
        recentTasks.add(task1);

        JsonObject task2 = new JsonObject();
        task2.addProperty("title", "Review Code Changes");
        task2.addProperty("completed", true);
        recentTasks.add(task2);

        JsonObject task3 = new JsonObject();
        task3.addProperty("title", "Update Documentation");
        task3.addProperty("completed", false);
        recentTasks.add(task3);

        jsonResponse.add("recentTasks", recentTasks);

        // Recent Sessions
        JsonArray recentSessions = new JsonArray();
        JsonObject session1 = new JsonObject();
        session1.addProperty("type", "Focus");
        session1.addProperty("duration", 25);
        session1.addProperty("completed", true);
        recentSessions.add(session1);

        JsonObject session2 = new JsonObject();
        session2.addProperty("type", "Break");
        session2.addProperty("duration", 5);
        session2.addProperty("completed", true);
        recentSessions.add(session2);

        JsonObject session3 = new JsonObject();
        session3.addProperty("type", "Focus");
        session3.addProperty("duration", 45);
        session3.addProperty("completed", false);
        recentSessions.add(session3);

        jsonResponse.add("recentSessions", recentSessions);

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void handleStartSession(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        int duration = Integer.parseInt(request.getParameter("duration"));
        
        // Create a new session ID (in a real app, this would come from the database)
        int sessionId = (int) (System.currentTimeMillis() % 10000);
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);
        jsonResponse.addProperty("sessionId", sessionId);
        
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void handleEndSession(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);
        
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(jsonResponse));
    }
} 