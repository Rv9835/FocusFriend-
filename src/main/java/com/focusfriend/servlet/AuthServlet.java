package com.focusfriend.servlet;

import com.focusfriend.dao.AdminDAO;
import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.Admin;
import com.focusfriend.model.User;
import com.focusfriend.util.PasswordUtil;
import com.focusfriend.util.DBUtil;

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

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;
    private AdminDAO adminDAO;
    private PasswordUtil passwordUtil;

    @Override
    public void init() throws ServletException {
        DBUtil.initializeDatabase();
        userDAO = new UserDAO();
        adminDAO = new AdminDAO();
        passwordUtil = new PasswordUtil();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/check".equals(pathInfo)) {
            checkSession(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/login.jsp".equals(pathInfo)) {
            handleLogin(request, response);
        } else if ("/logout".equals(pathInfo)) {
            handleLogout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void checkSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("userId") != null;
        
        response.setContentType("application/json");
        response.getWriter().write("{\"loggedIn\": " + loggedIn + "}");
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            User user = userDAO.validateUser(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\": \"Invalid username or password\"}");
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true}");
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        if (userDAO.getUserByUsername(username) != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=username_exists");
            return;
        }

        if (userDAO.getUserByEmail(email) != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=email_exists");
            return;
        }

        User user = new User(username, password, email, fullName);
        try {
            userDAO.createUser(user);
            response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=database");
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String userType = request.getParameter("userType");

        if (userType.equals("admin")) {
            Admin admin = adminDAO.getAdminByUsername(email);
            if (admin != null) {
                String token = PasswordUtil.generateResetToken();
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.HOUR, 24);
                Timestamp expiry = new Timestamp(cal.getTimeInMillis());
                adminDAO.setResetToken(admin.getId(), token, expiry);
                // TODO: Send reset email with token
                response.sendRedirect(request.getContextPath() + "/login.jsp?reset=email_sent");
            } else {
                response.sendRedirect(request.getContextPath() + "/reset-password.jsp?error=not_found");
            }
        } else {
            User user = userDAO.getUserByEmail(email);
            if (user != null) {
                String token = PasswordUtil.generateResetToken();
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.HOUR, 24);
                Timestamp expiry = new Timestamp(cal.getTimeInMillis());
                userDAO.setResetToken(user.getId(), token, expiry);
                // TODO: Send reset email with token
                response.sendRedirect(request.getContextPath() + "/login.jsp?reset=email_sent");
            } else {
                response.sendRedirect(request.getContextPath() + "/reset-password.jsp?error=not_found");
            }
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String userType = request.getParameter("userType");

        if (userType.equals("admin")) {
            Admin admin = adminDAO.getAdminByResetToken(token);
            if (admin != null) {
                adminDAO.updatePassword(admin.getId(), newPassword);
                response.sendRedirect(request.getContextPath() + "/login.jsp?reset=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/reset-password.jsp?error=invalid_token");
            }
        } else {
            User user = userDAO.getUserByResetToken(token);
            if (user != null) {
                try {
                    userDAO.updatePassword(user.getId(), newPassword);
                    response.sendRedirect(request.getContextPath() + "/login.jsp?reset=success");
                } catch (SQLException e) {
                    response.sendRedirect(request.getContextPath() + "/reset-password.jsp?error=database");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/reset-password.jsp?error=invalid_token");
            }
        }
    }
} 