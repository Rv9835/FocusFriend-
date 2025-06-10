package com.focusfriend.servlet;

import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.User;
import com.focusfriend.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/api/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(RegisterServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        logger.info("RegisterServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("Handling GET request to /api/register");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("Handling POST request to /api/register");
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        logger.info("Received registration request for username: " + username);

        // Validate input
        if (username == null || email == null || password == null || confirmPassword == null ||
            username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            logger.warning("Invalid input in registration request");
            response.sendRedirect(request.getContextPath() + "/register?error=invalid_input");
            return;
        }

        if (!password.equals(confirmPassword)) {
            logger.warning("Password mismatch in registration request");
            response.sendRedirect(request.getContextPath() + "/register?error=password_mismatch");
            return;
        }

        try {
            // Check if username or email already exists
            if (userDAO.getUserByUsername(username) != null) {
                logger.warning("Username already exists: " + username);
                response.sendRedirect(request.getContextPath() + "/register?error=username_exists");
                return;
            }
            if (userDAO.getUserByEmail(email) != null) {
                logger.warning("Email already exists: " + email);
                response.sendRedirect(request.getContextPath() + "/register?error=email_exists");
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
            logger.info("Successfully created user: " + username);

            // Redirect to login page
            response.sendRedirect(request.getContextPath() + "/login?registered=true");
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error during registration", e);
            response.sendRedirect(request.getContextPath() + "/register?error=database_error");
        }
    }
} 