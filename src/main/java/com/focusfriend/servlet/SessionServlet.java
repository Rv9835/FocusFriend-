package com.focusfriend.servlet;

import com.focusfriend.dao.SessionDAO;
import com.focusfriend.model.Session;
import com.focusfriend.util.ProductivityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/session/*")
public class SessionServlet extends HttpServlet {
    private SessionDAO sessionDAO;

    @Override
    public void init() throws ServletException {
        sessionDAO = new SessionDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        try {
            switch (action) {
                case "/start":
                    startSession(request, response);
                    break;
                case "/end":
                    endSession(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        try {
            switch (action) {
                case "/list":
                    listSessions(request, response);
                    break;
                case "/active":
                    getActiveSession(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void startSession(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String description = request.getParameter("description");
        
        Session session = new Session(userId, LocalDateTime.now(), description);
        sessionDAO.createSession(session);
        
        response.setContentType("application/json");
        response.getWriter().write("{\"sessionId\": " + session.getId() + "}");
    }

    private void endSession(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        Session session = sessionDAO.getActiveSession(Integer.parseInt(request.getParameter("userId")));
        
        if (session != null && session.getId() == sessionId) {
            session.setEndTime(LocalDateTime.now());
            session.setDuration(ProductivityUtil.calculateSessionDuration(
                session.getStartTime(), session.getEndTime()));
            session.setStatus("COMPLETED");
            sessionDAO.updateSession(session);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"duration\": " + session.getDuration() + "}");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Active session not found");
        }
    }

    private void listSessions(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        List<Session> sessions = sessionDAO.getSessionsByUserId(userId);
        
        response.setContentType("application/json");
        response.getWriter().write(sessionsToJson(sessions));
    }

    private void getActiveSession(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Session session = sessionDAO.getActiveSession(userId);
        
        response.setContentType("application/json");
        if (session != null) {
            response.getWriter().write(sessionToJson(session));
        } else {
            response.getWriter().write("null");
        }
    }

    private String sessionsToJson(List<Session> sessions) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < sessions.size(); i++) {
            if (i > 0) json.append(",");
            json.append(sessionToJson(sessions.get(i)));
        }
        json.append("]");
        return json.toString();
    }

    private String sessionToJson(Session session) {
        return String.format(
            "{\"id\": %d, \"userId\": %d, \"startTime\": \"%s\", \"endTime\": %s, " +
            "\"description\": \"%s\", \"duration\": %d, \"status\": \"%s\"}",
            session.getId(),
            session.getUserId(),
            session.getStartTime(),
            session.getEndTime() != null ? "\"" + session.getEndTime() + "\"" : "null",
            session.getDescription(),
            session.getDuration(),
            session.getStatus()
        );
    }
} 