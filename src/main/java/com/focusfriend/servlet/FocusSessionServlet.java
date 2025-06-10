package com.focusfriend.servlet;

import com.focusfriend.dao.FocusSessionDAO;
import com.focusfriend.model.FocusSession;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/api/sessions/*")
public class FocusSessionServlet extends HttpServlet {
    private FocusSessionDAO sessionDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        sessionDAO = new FocusSessionDAO();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd'T'HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        Long userId = (Long) request.getSession().getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all sessions for user
                List<FocusSession> sessions = sessionDAO.getUserSessions(userId);
                sendJsonResponse(response, sessions);
            } else if (pathInfo.equals("/active")) {
                // Get active sessions
                List<FocusSession> sessions = sessionDAO.getActiveSessions(userId);
                sendJsonResponse(response, sessions);
            } else if (pathInfo.equals("/completed")) {
                // Get completed sessions
                List<FocusSession> sessions = sessionDAO.getCompletedSessions(userId);
                sendJsonResponse(response, sessions);
            } else if (pathInfo.startsWith("/type/")) {
                // Get sessions by type
                String type = pathInfo.substring("/type/".length());
                FocusSession.SessionType sessionType = FocusSession.SessionType.valueOf(type.toUpperCase());
                List<FocusSession> sessions = sessionDAO.getSessionsByType(userId, sessionType);
                sendJsonResponse(response, sessions);
            } else if (pathInfo.startsWith("/range/")) {
                // Get sessions by date range
                String[] dates = pathInfo.substring("/range/".length()).split("/");
                if (dates.length != 2) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date range format");
                    return;
                }

                DateTimeFormatter formatter = DateTimeFormatter.ISO_DATE_TIME;
                LocalDateTime startDate = LocalDateTime.parse(dates[0], formatter);
                LocalDateTime endDate = LocalDateTime.parse(dates[1], formatter);

                List<FocusSession> sessions = sessionDAO.getSessionsByDateRange(userId, startDate, endDate);
                sendJsonResponse(response, sessions);
            } else {
                // Get specific session
                Long sessionId = Long.parseLong(pathInfo.substring(1));
                FocusSession session = sessionDAO.getSession(sessionId, userId);
                if (session != null) {
                    sendJsonResponse(response, session);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Session not found");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid session ID");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid session type");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long userId = (Long) request.getSession().getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            FocusSession session = gson.fromJson(request.getReader(), FocusSession.class);
            session.setUserId(userId);
            session.setStartTime(LocalDateTime.now());

            FocusSession createdSession = sessionDAO.createSession(session);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdSession);
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        Long userId = (Long) request.getSession().getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Session ID required");
            return;
        }

        try {
            Long sessionId = Long.parseLong(pathInfo.substring(1));
            FocusSession session = gson.fromJson(request.getReader(), FocusSession.class);
            session.setId(sessionId);
            session.setUserId(userId);

            if (session.isCompleted() && session.getEndTime() == null) {
                session.endSession();
            }

            boolean updated = sessionDAO.updateSession(session);
            if (updated) {
                sendJsonResponse(response, session);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Session not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid session ID");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
} 