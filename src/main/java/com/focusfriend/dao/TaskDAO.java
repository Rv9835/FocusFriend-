package com.focusfriend.dao;

import com.focusfriend.model.Task;
import com.focusfriend.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {
    private static final String INSERT_TASK = "INSERT INTO tasks (title, description, priority, due_date, user_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_TASK = "UPDATE tasks SET title = ?, description = ?, priority = ?, due_date = ?, completed = ?, updated_at = ? WHERE id = ? AND user_id = ?";
    private static final String DELETE_TASK = "DELETE FROM tasks WHERE id = ? AND user_id = ?";
    private static final String GET_TASK = "SELECT * FROM tasks WHERE id = ? AND user_id = ?";
    private static final String GET_USER_TASKS = "SELECT * FROM tasks WHERE user_id = ? ORDER BY created_at DESC";
    private static final String GET_ACTIVE_TASKS = "SELECT * FROM tasks WHERE user_id = ? AND completed = false ORDER BY due_date ASC";
    private static final String GET_COMPLETED_TASKS = "SELECT * FROM tasks WHERE user_id = ? AND completed = true ORDER BY updated_at DESC";
    private static final String GET_TASKS_BY_PRIORITY = "SELECT * FROM tasks WHERE user_id = ? AND priority = ? ORDER BY due_date ASC";
    private static final String GET_TASKS_BY_DATE_RANGE = "SELECT * FROM tasks WHERE user_id = ? AND due_date BETWEEN ? AND ? ORDER BY due_date ASC";

    public Task createTask(Task task) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_TASK, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getPriority().name());
            stmt.setTimestamp(4, Timestamp.valueOf(task.getDueDate()));
            stmt.setLong(5, task.getUserId());
            stmt.setTimestamp(6, Timestamp.valueOf(task.getCreatedAt()));
            stmt.setTimestamp(7, Timestamp.valueOf(task.getUpdatedAt()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating task failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    task.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating task failed, no ID obtained.");
                }
            }

            return task;
        }
    }

    public boolean updateTask(Task task) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_TASK)) {
            
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getPriority().name());
            stmt.setTimestamp(4, Timestamp.valueOf(task.getDueDate()));
            stmt.setBoolean(5, task.isCompleted());
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(7, task.getId());
            stmt.setLong(8, task.getUserId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public boolean deleteTask(Long taskId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_TASK)) {
            
            stmt.setLong(1, taskId);
            stmt.setLong(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public Task getTask(Long taskId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_TASK)) {
            
            stmt.setLong(1, taskId);
            stmt.setLong(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTask(rs);
                }
            }
            return null;
        }
    }

    public List<Task> getUserTasks(Long userId) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_TASKS)) {
            
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
            return tasks;
        }
    }

    public List<Task> getActiveTasks(Long userId) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_ACTIVE_TASKS)) {
            
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
            return tasks;
        }
    }

    public List<Task> getCompletedTasks(Long userId) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_COMPLETED_TASKS)) {
            
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
            return tasks;
        }
    }

    public List<Task> getTasksByPriority(Long userId, Task.Priority priority) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_TASKS_BY_PRIORITY)) {
            
            stmt.setLong(1, userId);
            stmt.setString(2, priority.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
            return tasks;
        }
    }

    public List<Task> getTasksByDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_TASKS_BY_DATE_RANGE)) {
            
            stmt.setLong(1, userId);
            stmt.setTimestamp(2, Timestamp.valueOf(startDate));
            stmt.setTimestamp(3, Timestamp.valueOf(endDate));

            List<Task> tasks = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapResultSetToTask(rs));
                }
            }
            return tasks;
        }
    }

    private Task mapResultSetToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setId(rs.getLong("id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setPriority(Task.Priority.valueOf(rs.getString("priority")));
        task.setDueDate(rs.getTimestamp("due_date").toLocalDateTime());
        task.setCompleted(rs.getBoolean("completed"));
        task.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        task.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        task.setUserId(rs.getLong("user_id"));
        return task;
    }
} 