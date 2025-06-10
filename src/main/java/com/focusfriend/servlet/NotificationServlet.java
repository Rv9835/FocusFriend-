package com.focusfriend.servlet;

import com.focusfriend.dao.NotificationDAO;
import com.focusfriend.model.Notification;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/api/notifications/*")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        gson = new Gson();
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
                // Get all notifications for user
                List<Notification> notifications = notificationDAO.getUserNotifications(userId);
                sendJsonResponse(response, notifications);
            } else if (pathInfo.equals("/unread")) {
                // Get unread notifications
                List<Notification> notifications = notificationDAO.getUnreadNotifications(userId);
                sendJsonResponse(response, notifications);
            } else if (pathInfo.equals("/count")) {
                // Get unread notification count
                int count = notificationDAO.getUnreadNotificationCount(userId);
                JsonObject responseJson = new JsonObject();
                responseJson.addProperty("count", count);
                sendJsonResponse(response, responseJson);
            } else {
                // Get specific notification
                Long notificationId = Long.parseLong(pathInfo.substring(1));
                Notification notification = notificationDAO.getNotification(notificationId, userId);
                if (notification != null) {
                    sendJsonResponse(response, notification);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notification not found");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
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
            Notification notification = gson.fromJson(request.getReader(), Notification.class);
            notification.setUserId(userId);
            notification.setCreatedAt(LocalDateTime.now());
            notification.setRead(false);

            Notification createdNotification = notificationDAO.createNotification(notification);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdNotification);
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Notification ID required");
            return;
        }

        try {
            Long notificationId = Long.parseLong(pathInfo.substring(1));
            Notification notification = gson.fromJson(request.getReader(), Notification.class);
            notification.setId(notificationId);
            notification.setUserId(userId);

            boolean updated = notificationDAO.updateNotification(notification);
            if (updated) {
                sendJsonResponse(response, notification);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notification not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        Long userId = (Long) request.getSession().getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Notification ID required");
            return;
        }

        try {
            Long notificationId = Long.parseLong(pathInfo.substring(1));
            boolean deleted = notificationDAO.deleteNotification(notificationId, userId);
            if (deleted) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Notification not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
} 