package com.focusfriend.servlet;

import com.focusfriend.dao.FocusSessionDAO;
import com.focusfriend.model.FocusSession;
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
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@WebServlet("/progress")
public class ProgressServlet extends HttpServlet {
    private FocusSessionDAO sessionDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        sessionDAO = new FocusSessionDAO();
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
            request.getRequestDispatcher("progress.jsp").forward(request, response);
        }
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        // Sample data for testing
        JsonObject stats = new JsonObject();
        stats.addProperty("totalFocusTime", 120); // minutes
        stats.addProperty("completedSessions", 5);
        stats.addProperty("averageSessionLength", 24); // minutes

        // Sample focus time trend data
        JsonArray trendData = new JsonArray();
        JsonObject day1 = new JsonObject();
        day1.addProperty("date", "2024-03-15");
        day1.addProperty("focusTime", 45);
        trendData.add(day1);

        JsonObject day2 = new JsonObject();
        day2.addProperty("date", "2024-03-16");
        day2.addProperty("focusTime", 30);
        trendData.add(day2);

        JsonObject day3 = new JsonObject();
        day3.addProperty("date", "2024-03-17");
        day3.addProperty("focusTime", 60);
        trendData.add(day3);

        stats.add("focusTimeTrend", trendData);

        // Sample recent sessions
        JsonArray recentSessions = new JsonArray();
        JsonObject session1 = new JsonObject();
        session1.addProperty("id", 1);
        session1.addProperty("type", "focus");
        session1.addProperty("duration", 25);
        session1.addProperty("completed", true);
        session1.addProperty("startTime", "2024-03-17T10:00:00");
        recentSessions.add(session1);

        JsonObject session2 = new JsonObject();
        session2.addProperty("id", 2);
        session2.addProperty("type", "break");
        session2.addProperty("duration", 5);
        session2.addProperty("completed", true);
        session2.addProperty("startTime", "2024-03-17T10:25:00");
        recentSessions.add(session2);

        stats.add("recentSessions", recentSessions);

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(stats));
    }
} 