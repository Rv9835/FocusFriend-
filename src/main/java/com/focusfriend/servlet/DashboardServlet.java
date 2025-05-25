package com.focusfriend.servlet;

import com.focusfriend.dao.GoalDAO;
import com.focusfriend.dao.SessionDAO;
import com.focusfriend.model.Goal;
import com.focusfriend.model.Session;
import com.focusfriend.util.ProductivityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {
    private SessionDAO sessionDAO;
    private GoalDAO goalDAO;

    @Override
    public void init() throws ServletException {
        sessionDAO = new SessionDAO();
        goalDAO = new GoalDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        try {
            switch (action) {
                case "/stats":
                    getStats(request, response);
                    break;
                case "/recent":
                    getRecentActivity(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void getStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        LocalDate date = LocalDate.parse(request.getParameter("date"));
        
        // Get sessions for the day
        List<Session> sessions = sessionDAO.getSessionsByUserId(userId);
        int totalMinutes = sessions.stream()
            .filter(s -> s.getStartTime().toLocalDate().equals(date))
            .mapToInt(Session::getDuration)
            .sum();
        
        // Get active goals
        List<Goal> goals = goalDAO.getGoalsByUserId(userId);
        int targetMinutes = goals.stream()
            .filter(g -> g.getStatus().equals("ACTIVE"))
            .mapToInt(Goal::getTargetMinutes)
            .sum();
        
        double productivityPercentage = ProductivityUtil.calculateDailyProductivity(totalMinutes, targetMinutes);
        String productivityStatus = ProductivityUtil.getProductivityStatus(productivityPercentage);
        
        // Calculate streak
        int[] dailyMinutes = new int[7]; // Last 7 days
        for (int i = 0; i < 7; i++) {
            LocalDate currentDate = date.minusDays(i);
            final LocalDate finalDate = currentDate;
            dailyMinutes[i] = sessions.stream()
                .filter(s -> s.getStartTime().toLocalDate().equals(finalDate))
                .mapToInt(Session::getDuration)
                .sum();
        }
        int streak = ProductivityUtil.calculateStreak(dailyMinutes);
        
        response.setContentType("application/json");
        response.getWriter().write(String.format(
            "{\"totalMinutes\": %d, \"targetMinutes\": %d, \"productivityPercentage\": %.2f, " +
            "\"productivityStatus\": \"%s\", \"streak\": %d}",
            totalMinutes,
            targetMinutes,
            productivityPercentage,
            productivityStatus,
            streak
        ));
    }

    private void getRecentActivity(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        // Get recent sessions
        List<Session> sessions = sessionDAO.getSessionsByUserId(userId);
        sessions = sessions.subList(0, Math.min(sessions.size(), 5)); // Get last 5 sessions
        
        // Get active goals
        List<Goal> goals = goalDAO.getGoalsByUserId(userId);
        goals = goals.stream()
            .filter(g -> g.getStatus().equals("ACTIVE"))
            .limit(5)
            .toList();
        
        response.setContentType("application/json");
        response.getWriter().write(String.format(
            "{\"recentSessions\": %s, \"activeGoals\": %s}",
            sessionsToJson(sessions),
            goalsToJson(goals)
        ));
    }

    private String sessionsToJson(List<Session> sessions) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < sessions.size(); i++) {
            if (i > 0) json.append(",");
            json.append(sessionToJson(sessions.get(i)));
        }
        json.append("]");
        return json.toString();
    }

    private String sessionToJson(Session session) {
        return String.format(
            "{\"id\": %d, \"startTime\": \"%s\", \"duration\": %d, \"description\": \"%s\"}",
            session.getId(),
            session.getStartTime(),
            session.getDuration(),
            session.getDescription()
        );
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
            "{\"id\": %d, \"title\": \"%s\", \"targetDate\": \"%s\", " +
            "\"completedMinutes\": %d, \"targetMinutes\": %d, \"progressPercentage\": %.2f}",
            goal.getId(),
            goal.getTitle(),
            goal.getTargetDate(),
            goal.getCompletedMinutes(),
            goal.getTargetMinutes(),
            goal.getProgressPercentage()
        );
    }
} 