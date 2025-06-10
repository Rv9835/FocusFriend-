package com.focusfriend.servlet;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.focusfriend.dao.AdminDAO;
import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.Admin;
import com.focusfriend.model.User;
import com.focusfriend.util.ErrorHandler;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/api/admin/*")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());
    private final AdminDAO adminDAO = new AdminDAO();
    private final UserDAO userDAO = new UserDAO();
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            handleGetAllUsers(request, response);
        } else if (pathInfo.startsWith("/user/")) {
            String userId = pathInfo.substring(6);
            handleGetUser(request, response, Long.parseLong(userId));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/user/")) {
            String userId = pathInfo.substring(6);
            String action = request.getParameter("action");
            
            if ("activate".equals(action)) {
                handleActivateUser(request, response, Long.parseLong(userId));
            } else if ("deactivate".equals(action)) {
                handleDeactivateUser(request, response, Long.parseLong(userId));
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleGetAllUsers(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(users));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    private void handleGetUser(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws IOException {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(user));
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    private void handleActivateUser(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws IOException {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setActive(true);
                if (userDAO.updateUser(user)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"message\": \"User activated successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\": \"Failed to activate user\"}");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    private void handleDeactivateUser(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws IOException {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setActive(false);
                if (userDAO.updateUser(user)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"message\": \"User deactivated successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\": \"Failed to deactivate user\"}");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }
} 