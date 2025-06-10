package com.focusfriend.servlet;

import com.focusfriend.dao.FocusSessionDAO;
import com.focusfriend.dao.TaskDAO;
import com.focusfriend.model.FocusSession;
import com.focusfriend.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/api/stats/*")
public class StatsServlet extends HttpServlet {
    private FocusSessionDAO sessionDAO;
    private TaskDAO taskDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        sessionDAO = new FocusSessionDAO();
        taskDAO = new TaskDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        Long userId = (Long) request.getSession().getAttribute("userId");

        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get overall statistics
                getOverallStats(userId, response);
            } else if (pathInfo.equals("/daily")) {
                // Get daily statistics
                getDailyStats(userId, response);
            } else if (pathInfo.equals("/weekly")) {
                // Get weekly statistics
                getWeeklyStats(userId, response);
            } else if (pathInfo.equals("/monthly")) {
                // Get monthly statistics
                getMonthlyStats(userId, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid endpoint");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void getOverallStats(Long userId, HttpServletResponse response) throws SQLException, IOException {
        List<FocusSession> sessions = sessionDAO.getUserSessions(userId);
        List<Task> tasks = taskDAO.getUserTasks(userId);

        JsonObject stats = new JsonObject();

        // Session statistics
        long totalFocusTime = sessions.stream()
                .filter(FocusSession::isCompleted)
                .mapToLong(session -> ChronoUnit.MINUTES.between(session.getStartTime(), session.getEndTime()))
                .sum();
        stats.addProperty("totalFocusTime", totalFocusTime);
        stats.addProperty("totalSessions", sessions.size());
        stats.addProperty("completedSessions", sessions.stream().filter(FocusSession::isCompleted).count());

        // Task statistics
        stats.addProperty("totalTasks", tasks.size());
        stats.addProperty("completedTasks", tasks.stream().filter(Task::isCompleted).count());
        stats.addProperty("pendingTasks", tasks.stream().filter(task -> !task.isCompleted()).count());

        // Priority distribution
        Map<Task.Priority, Long> priorityDistribution = tasks.stream()
                .collect(Collectors.groupingBy(Task::getPriority, Collectors.counting()));
        JsonObject priorityStats = new JsonObject();
        for (Task.Priority priority : Task.Priority.values()) {
            priorityStats.addProperty(priority.name(), priorityDistribution.getOrDefault(priority, 0L));
        }
        stats.add("priorityDistribution", priorityStats);

        sendJsonResponse(response, stats);
    }

    private void getDailyStats(Long userId, HttpServletResponse response) throws SQLException, IOException {
        LocalDateTime today = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        List<FocusSession> sessions = sessionDAO.getSessionsByDateRange(userId, today, LocalDateTime.now());
        List<Task> tasks = taskDAO.getTasksByDateRange(userId, today, LocalDateTime.now());

        JsonObject stats = new JsonObject();

        // Session statistics
        long totalFocusTime = sessions.stream()
                .filter(FocusSession::isCompleted)
                .mapToLong(session -> ChronoUnit.MINUTES.between(session.getStartTime(), session.getEndTime()))
                .sum();
        stats.addProperty("totalFocusTime", totalFocusTime);
        stats.addProperty("totalSessions", sessions.size());
        stats.addProperty("completedSessions", sessions.stream().filter(FocusSession::isCompleted).count());

        // Task statistics
        stats.addProperty("totalTasks", tasks.size());
        stats.addProperty("completedTasks", tasks.stream().filter(Task::isCompleted).count());
        stats.addProperty("pendingTasks", tasks.stream().filter(task -> !task.isCompleted()).count());

        sendJsonResponse(response, stats);
    }

    private void getWeeklyStats(Long userId, HttpServletResponse response) throws SQLException, IOException {
        LocalDateTime weekStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0)
                .minusDays(LocalDateTime.now().getDayOfWeek().getValue() - 1);
        List<FocusSession> sessions = sessionDAO.getSessionsByDateRange(userId, weekStart, LocalDateTime.now());
        List<Task> tasks = taskDAO.getTasksByDateRange(userId, weekStart, LocalDateTime.now());

        JsonObject stats = new JsonObject();

        // Session statistics
        long totalFocusTime = sessions.stream()
                .filter(FocusSession::isCompleted)
                .mapToLong(session -> ChronoUnit.MINUTES.between(session.getStartTime(), session.getEndTime()))
                .sum();
        stats.addProperty("totalFocusTime", totalFocusTime);
        stats.addProperty("totalSessions", sessions.size());
        stats.addProperty("completedSessions", sessions.stream().filter(FocusSession::isCompleted).count());

        // Task statistics
        stats.addProperty("totalTasks", tasks.size());
        stats.addProperty("completedTasks", tasks.stream().filter(Task::isCompleted).count());
        stats.addProperty("pendingTasks", tasks.stream().filter(task -> !task.isCompleted()).count());

        // Daily breakdown
        JsonObject dailyBreakdown = new JsonObject();
        for (int i = 0; i < 7; i++) {
            LocalDateTime dayStart = weekStart.plusDays(i);
            LocalDateTime dayEnd = dayStart.plusDays(1);
            
            long dayFocusTime = sessions.stream()
                    .filter(session -> session.getStartTime().isAfter(dayStart) && session.getStartTime().isBefore(dayEnd))
                    .filter(FocusSession::isCompleted)
                    .mapToLong(session -> ChronoUnit.MINUTES.between(session.getStartTime(), session.getEndTime()))
                    .sum();
            
            JsonObject dayStats = new JsonObject();
            dayStats.addProperty("focusTime", dayFocusTime);
            dayStats.addProperty("sessions", sessions.stream()
                    .filter(session -> session.getStartTime().isAfter(dayStart) && session.getStartTime().isBefore(dayEnd))
                    .count());
            dayStats.addProperty("completedTasks", tasks.stream()
                    .filter(task -> task.isCompleted() && task.getCompletedAt().isAfter(dayStart) && task.getCompletedAt().isBefore(dayEnd))
                    .count());
            
            dailyBreakdown.add(dayStart.getDayOfWeek().name(), dayStats);
        }
        stats.add("dailyBreakdown", dailyBreakdown);

        sendJsonResponse(response, stats);
    }

    private void getMonthlyStats(Long userId, HttpServletResponse response) throws SQLException, IOException {
        LocalDateTime monthStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0)
                .withDayOfMonth(1);
        List<FocusSession> sessions = sessionDAO.getSessionsByDateRange(userId, monthStart, LocalDateTime.now());
        List<Task> tasks = taskDAO.getTasksByDateRange(userId, monthStart, LocalDateTime.now());

        JsonObject stats = new JsonObject();

        // Session statistics
        long totalFocusTime = sessions.stream()
                .filter(FocusSession::isCompleted)
                .mapToLong(session -> ChronoUnit.MINUTES.between(session.getStartTime(), session.getEndTime()))
                .sum();
        stats.addProperty("totalFocusTime", totalFocusTime);
        stats.addProperty("totalSessions", sessions.size());
        stats.addProperty("completedSessions", sessions.stream().filter(FocusSession::isCompleted).count());

        // Task statistics
        stats.addProperty("totalTasks", tasks.size());
        stats.addProperty("completedTasks", tasks.stream().filter(Task::isCompleted).count());
        stats.addProperty("pendingTasks", tasks.stream().filter(task -> !task.isCompleted()).count());

        // Weekly breakdown
        JsonObject weeklyBreakdown = new JsonObject();
        for (int i = 0; i < 4; i++) {
            LocalDateTime weekStart = monthStart.plusWeeks(i);
            LocalDateTime weekEnd = weekStart.plusWeeks(1);
            
            long weekFocusTime = sessions.stream()
                    .filter(session -> session.getStartTime().isAfter(weekStart) && session.getStartTime().isBefore(weekEnd))
                    .filter(FocusSession::isCompleted)
                    .mapToLong(session -> ChronoUnit.MINUTES.between(session.getStartTime(), session.getEndTime()))
                    .sum();
            
            JsonObject weekStats = new JsonObject();
            weekStats.addProperty("focusTime", weekFocusTime);
            weekStats.addProperty("sessions", sessions.stream()
                    .filter(session -> session.getStartTime().isAfter(weekStart) && session.getStartTime().isBefore(weekEnd))
                    .count());
            weekStats.addProperty("completedTasks", tasks.stream()
                    .filter(task -> task.isCompleted() && task.getCompletedAt().isAfter(weekStart) && task.getCompletedAt().isBefore(weekEnd))
                    .count());
            
            weeklyBreakdown.add("Week " + (i + 1), weekStats);
        }
        stats.add("weeklyBreakdown", weeklyBreakdown);

        sendJsonResponse(response, stats);
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
} 