package com.focusfriend.servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.focusfriend.dao.GoalDAO;
import com.focusfriend.model.Goal;
import com.focusfriend.util.ErrorHandler;

@WebServlet("/goal/*")
public class GoalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(GoalServlet.class.getName());
    private final GoalDAO goalDAO = new GoalDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String action = request.getPathInfo();
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                ErrorHandler.handleError(request, response, "User not logged in", "login.jsp");
                return;
            }

            if ("/add".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String deadline = request.getParameter("deadline");

                Goal goal = new Goal();
                goal.setUserId(userId);
                goal.setTitle(title);
                goal.setDescription(description);
                goal.setDeadline(Date.valueOf(deadline));
                goal.setStatus("PENDING");

                goalDAO.addGoal(goal);
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in goal processing", e);
            ErrorHandler.handleError(request, response, "Error processing goal", "dashboard.jsp");
        }
    }
} 