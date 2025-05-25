package com.focusfriend.servlet;

import com.focusfriend.dao.AdminDAO;
import com.focusfriend.dao.UserDAO;
import com.focusfriend.model.Admin;
import com.focusfriend.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private AdminDAO adminDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(Boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/users":
                listUsers(request, response);
                break;
            case "/admins":
                listAdmins(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !(Boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        switch (pathInfo) {
            case "/create-admin":
                createAdmin(request, response);
                break;
            case "/update-user":
                updateUser(request, response);
                break;
            case "/update-admin":
                updateAdmin(request, response);
                break;
            case "/delete-user":
                deleteUser(request, response);
                break;
            case "/delete-admin":
                deleteAdmin(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalUsers = userDAO.getAllUsers().size();
        int totalAdmins = adminDAO.getAllAdmins().size();
        // TODO: Add more statistics
        
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalAdmins", totalAdmins);
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(request, response);
    }

    private void listAdmins(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Admin> admins = adminDAO.getAllAdmins();
        request.setAttribute("admins", admins);
        request.getRequestDispatcher("/WEB-INF/admin/admins.jsp").forward(request, response);
    }

    private void createAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        boolean isSuperAdmin = Boolean.parseBoolean(request.getParameter("isSuperAdmin"));

        if (adminDAO.getAdminByUsername(username) != null) {
            response.sendRedirect(request.getContextPath() + "/admin/admins?error=username_exists");
            return;
        }

        Admin admin = new Admin(username, password, email, fullName, isSuperAdmin);
        adminDAO.createAdmin(admin);
        response.sendRedirect(request.getContextPath() + "/admin/admins?success=created");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));

        User user = userDAO.getUserById(userId);
        if (user != null) {
            user.setEmail(email);
            user.setFullName(fullName);
            user.setActive(isActive);
            userDAO.updateUser(user);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
        }
    }

    private void updateAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int adminId = Integer.parseInt(request.getParameter("adminId"));
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
        boolean isSuperAdmin = Boolean.parseBoolean(request.getParameter("isSuperAdmin"));

        Admin admin = adminDAO.getAdminById(adminId);
        if (admin != null) {
            admin.setEmail(email);
            admin.setFullName(fullName);
            admin.setActive(isActive);
            admin.setSuperAdmin(isSuperAdmin);
            adminDAO.updateAdmin(admin);
            response.sendRedirect(request.getContextPath() + "/admin/admins?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/admins?error=not_found");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        User user = userDAO.getUserById(userId);
        if (user != null) {
            user.setActive(false);
            userDAO.updateUser(user);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
        }
    }

    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int adminId = Integer.parseInt(request.getParameter("adminId"));
        Admin admin = adminDAO.getAdminById(adminId);
        if (admin != null) {
            admin.setActive(false);
            adminDAO.updateAdmin(admin);
            response.sendRedirect(request.getContextPath() + "/admin/admins?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/admins?error=not_found");
        }
    }
} 