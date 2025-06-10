package com.focusfriend.servlet;

import com.focusfriend.dao.AchievementDAO;
import com.focusfriend.model.Achievement;
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

@WebServlet("/api/achievements/*")
public class AchievementServlet extends HttpServlet {
    private AchievementDAO achievementDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        achievementDAO = new AchievementDAO();
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
                // Get all achievements for user
                List<Achievement> achievements = achievementDAO.getUserAchievements(userId);
                sendJsonResponse(response, achievements);
            } else if (pathInfo.equals("/unlocked")) {
                // Get unlocked achievements
                List<Achievement> achievements = achievementDAO.getUnlockedAchievements(userId);
                sendJsonResponse(response, achievements);
            } else if (pathInfo.equals("/locked")) {
                // Get locked achievements
                List<Achievement> achievements = achievementDAO.getLockedAchievements(userId);
                sendJsonResponse(response, achievements);
            } else if (pathInfo.equals("/progress")) {
                // Get achievement progress
                JsonObject progress = achievementDAO.getAchievementProgress(userId);
                sendJsonResponse(response, progress);
            } else {
                // Get specific achievement
                Long achievementId = Long.parseLong(pathInfo.substring(1));
                Achievement achievement = achievementDAO.getAchievement(achievementId, userId);
                if (achievement != null) {
                    sendJsonResponse(response, achievement);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Achievement not found");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid achievement ID");
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
            Achievement achievement = gson.fromJson(request.getReader(), Achievement.class);
            achievement.setUserId(userId);
            achievement.setUnlockedAt(LocalDateTime.now());

            Achievement createdAchievement = achievementDAO.createAchievement(achievement);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdAchievement);
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Achievement ID required");
            return;
        }

        try {
            Long achievementId = Long.parseLong(pathInfo.substring(1));
            Achievement achievement = gson.fromJson(request.getReader(), Achievement.class);
            achievement.setId(achievementId);
            achievement.setUserId(userId);

            if (achievement.isUnlocked() && achievement.getUnlockedAt() == null) {
                achievement.setUnlockedAt(LocalDateTime.now());
            }

            boolean updated = achievementDAO.updateAchievement(achievement);
            if (updated) {
                sendJsonResponse(response, achievement);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Achievement not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid achievement ID");
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Achievement ID required");
            return;
        }

        try {
            Long achievementId = Long.parseLong(pathInfo.substring(1));
            boolean deleted = achievementDAO.deleteAchievement(achievementId, userId);
            if (deleted) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Achievement not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid achievement ID");
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
} 