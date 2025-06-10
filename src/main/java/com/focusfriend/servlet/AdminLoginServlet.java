package com.focusfriend.servlet;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.focusfriend.dao.AdminDAO;
import com.focusfriend.model.Admin;
import com.focusfriend.util.ErrorHandler;
import com.focusfriend.util.PasswordUtil;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminLoginServlet.class.getName());
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || password == null) {
                ErrorHandler.handleError(request, response, "Please enter both username and password", "admin/login.jsp");
                return;
            }

            Admin admin = adminDAO.getAdminByUsername(username);
            if (admin != null && PasswordUtil.verifyPassword(password, admin.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                ErrorHandler.handleError(request, response, "Invalid username or password", "admin/login.jsp");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in admin login", e);
            ErrorHandler.handleError(request, response, "Error during login", "admin/login.jsp");
        }
    }
} 