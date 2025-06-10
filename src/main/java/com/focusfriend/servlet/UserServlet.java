package com.focusfriend.servlet;

import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/api/users/*")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd'T'HH:mm:ss")
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all users (admin only)
                if (userId == null || !isAdmin(userId)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
                    return;
                }
                List<User> users = userDAO.getAllUsers();
                sendJsonResponse(response, users);
            } else if (pathInfo.equals("/profile")) {
                // Get current user's profile
                if (userId == null) {
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
                    return;
                }
                User user = userDAO.getUser(userId);
                if (user != null) {
                    sendJsonResponse(response, user);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                }
            } else {
                // Get specific user (admin only)
                if (userId == null || !isAdmin(userId)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
                    return;
                }
                Long targetUserId = Long.parseLong(pathInfo.substring(1));
                User user = userDAO.getUser(targetUserId);
                if (user != null) {
                    sendJsonResponse(response, user);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                }
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = gson.fromJson(request.getReader(), User.class);
            user.setCreatedAt(LocalDateTime.now());
            user.setLastLogin(LocalDateTime.now());

            // Check if username or email already exists
            if (userDAO.getUserByUsername(user.getUsername()) != null) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Username already exists");
                return;
            }
            if (userDAO.getUserByEmail(user.getEmail()) != null) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Email already exists");
                return;
            }

            User createdUser = userDAO.createUser(user);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdUser);
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID required");
                return;
            }

            Long targetUserId = Long.parseLong(pathInfo.substring(1));
            
            // Check if user is updating their own profile or is an admin
            if (!userId.equals(targetUserId) && !isAdmin(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot update other user's profile");
                return;
            }

            User user = gson.fromJson(request.getReader(), User.class);
            user.setId(targetUserId);
            user.setLastLogin(LocalDateTime.now());

            boolean updated = userDAO.updateUser(user);
            if (updated) {
                sendJsonResponse(response, user);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID required");
                return;
            }

            Long targetUserId = Long.parseLong(pathInfo.substring(1));
            
            // Check if user is deleting their own account or is an admin
            if (!userId.equals(targetUserId) && !isAdmin(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot delete other user's account");
                return;
            }

            boolean deleted = userDAO.deleteUser(targetUserId);
            if (deleted) {
                if (userId.equals(targetUserId)) {
                    // If user deleted their own account, invalidate their session
                    session.invalidate();
                }
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        }
    }

    private boolean isAdmin(Long userId) {
        // TODO: Implement admin check logic
        return false;
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
} 