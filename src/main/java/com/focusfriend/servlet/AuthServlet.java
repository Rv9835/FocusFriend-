package com.focusfriend.servlet;

import com.focusfriend.dao.AdminDAO;
import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.Admin;
import com.focusfriend.model.User;
import com.focusfriend.util.PasswordUtil;
import com.focusfriend.util.DatabaseUtil;
import com.focusfriend.util.ValidationUtil;
import com.focusfriend.util.ErrorHandler;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private AdminDAO adminDAO;
    private PasswordUtil passwordUtil;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        adminDAO = new AdminDAO();
        passwordUtil = new PasswordUtil();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else if (pathInfo.equals("/register")) {
            request.getRequestDispatcher("/WEB-INF/register.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            handleLogin(request, response);
        } else if (pathInfo.equals("/register")) {
            handleRegister(request, response);
        } else if (pathInfo.equals("/logout")) {
            handleLogout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // If parameters are null, try to read JSON
        if (username == null || password == null) {
            JsonObject requestData = gson.fromJson(request.getReader(), JsonObject.class);
            username = requestData.get("username").getAsString();
            password = requestData.get("password").getAsString();
        }

        try {
            User user = userDAO.getUserByUsername(username);
            
            if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
                if (!user.isActive()) {
                    if (isJsonRequest(request)) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        response.getWriter().write("{\"error\": \"Account is deactivated\"}");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/auth?error=deactivated");
                    }
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());

                user.setLastLogin(LocalDateTime.now());
                userDAO.updateUser(user);

                if (isJsonRequest(request)) {
                    Map<String, Object> responseData = new HashMap<>();
                    responseData.put("userId", user.getId());
                    responseData.put("username", user.getUsername());
                    responseData.put("email", user.getEmail());

                    response.setContentType("application/json");
                    response.getWriter().write(gson.toJson(responseData));
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
            } else {
                if (isJsonRequest(request)) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("{\"error\": \"Invalid username or password\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/auth?error=invalid");
                }
            }
        } catch (SQLException e) {
            if (isJsonRequest(request)) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Database error\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/auth?error=database");
            }
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // If parameters are null, try to read JSON
        if (username == null || email == null || password == null) {
            JsonObject requestData = gson.fromJson(request.getReader(), JsonObject.class);
            username = requestData.get("username").getAsString();
            email = requestData.get("email").getAsString();
            password = requestData.get("password").getAsString();
        }

        try {
            // Validate input
            if (username == null || email == null || password == null ||
                username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                if (isJsonRequest(request)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid input\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/register?error=invalid_input");
                }
                return;
            }

            if (confirmPassword != null && !password.equals(confirmPassword)) {
                if (isJsonRequest(request)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Passwords do not match\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/register?error=password_mismatch");
                }
                return;
            }

            // Check if username or email already exists
            if (userDAO.getUserByUsername(username) != null) {
                if (isJsonRequest(request)) {
                    response.setStatus(HttpServletResponse.SC_CONFLICT);
                    response.getWriter().write("{\"error\": \"Username already exists\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/register?error=username_exists");
                }
                return;
            }

            if (userDAO.getUserByEmail(email) != null) {
                if (isJsonRequest(request)) {
                    response.setStatus(HttpServletResponse.SC_CONFLICT);
                    response.getWriter().write("{\"error\": \"Email already exists\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/register?error=email_exists");
                }
                return;
            }

            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setFullName(username);
            user.setCreatedAt(LocalDateTime.now());
            user.setLastLogin(LocalDateTime.now());
            user.setActive(true);

            userDAO.createUser(user);

            if (isJsonRequest(request)) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write("{\"message\": \"User registered successfully\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?registered=true");
            }
        } catch (SQLException e) {
            if (isJsonRequest(request)) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Database error\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/register?error=database_error");
            }
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        if (isJsonRequest(request)) {
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"message\": \"Logged out successfully\"}");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private boolean isJsonRequest(HttpServletRequest request) {
        String contentType = request.getContentType();
        return contentType != null && contentType.contains("application/json");
    }
} 