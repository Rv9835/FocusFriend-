package com.focusfriend.servlet;

import com.focusfriend.dao.GoalDAO;
import com.focusfriend.model.Goal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/goal/*")
public class GoalServlet extends HttpServlet {
    private GoalDAO goalDAO;

    @Override
    public void init() throws ServletException {
        goalDAO = new GoalDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        try {
            switch (action) {
                case "/create":
                    createGoal(request, response);
                    break;
                case "/update":
                    updateGoal(request, response);
                    break;
                case "/progress":
                    updateProgress(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        try {
            switch (action) {
                case "/list":
                    listGoals(request, response);
                    break;
                case "/get":
                    getGoal(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void createGoal(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        LocalDate targetDate = LocalDate.parse(request.getParameter("targetDate"));
        int targetMinutes = Integer.parseInt(request.getParameter("targetMinutes"));
        
        Goal goal = new Goal(userId, title, description, targetDate, targetMinutes);
        goalDAO.createGoal(goal);
        
        response.setContentType("application/json");
        response.getWriter().write("{\"goalId\": " + goal.getId() + "}");
    }

    private void updateGoal(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int goalId = Integer.parseInt(request.getParameter("goalId"));
        Goal goal = goalDAO.getGoalById(goalId);
        
        if (goal != null) {
            goal.setTitle(request.getParameter("title"));
            goal.setDescription(request.getParameter("description"));
            goal.setTargetDate(LocalDate.parse(request.getParameter("targetDate")));
            goal.setTargetMinutes(Integer.parseInt(request.getParameter("targetMinutes")));
            goal.setStatus(request.getParameter("status"));
            
            goalDAO.updateGoal(goal);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Goal not found");
        }
    }

    private void updateProgress(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int goalId = Integer.parseInt(request.getParameter("goalId"));
        int additionalMinutes = Integer.parseInt(request.getParameter("minutes"));
        
        goalDAO.updateGoalProgress(goalId, additionalMinutes);
        
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true}");
    }

    private void listGoals(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        List<Goal> goals = goalDAO.getGoalsByUserId(userId);
        
        response.setContentType("application/json");
        response.getWriter().write(goalsToJson(goals));
    }

    private void getGoal(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int goalId = Integer.parseInt(request.getParameter("goalId"));
        Goal goal = goalDAO.getGoalById(goalId);
        
        response.setContentType("application/json");
        if (goal != null) {
            response.getWriter().write(goalToJson(goal));
        } else {
            response.getWriter().write("null");
        }
    }

    private String goalsToJson(List<Goal> goals) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < goals.size(); i++) {
            if (i > 0) json.append(",");
            json.append(goalToJson(goals.get(i)));
        }
        json.append("]");
        return json.toString();
    }

    private String goalToJson(Goal goal) {
        return String.format(
            "{\"id\": %d, \"userId\": %d, \"title\": \"%s\", \"description\": \"%s\", " +
            "\"targetDate\": \"%s\", \"targetMinutes\": %d, \"completedMinutes\": %d, " +
            "\"status\": \"%s\", \"progressPercentage\": %.2f}",
            goal.getId(),
            goal.getUserId(),
            goal.getTitle(),
            goal.getDescription(),
            goal.getTargetDate(),
            goal.getTargetMinutes(),
            goal.getCompletedMinutes(),
            goal.getStatus(),
            goal.getProgressPercentage()
        );
    }
} 