package com.focusfriend.dao;

import com.focusfriend.model.Goal;
import com.focusfriend.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GoalDAO {
    
    public void addGoal(Goal goal) throws SQLException {
        String sql = "INSERT INTO goals (user_id, title, description, deadline, target_minutes, completed_minutes, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, goal.getUserId());
            stmt.setString(2, goal.getTitle());
            stmt.setString(3, goal.getDescription());
            stmt.setDate(4, goal.getDeadline());
            stmt.setInt(5, goal.getTargetMinutes());
            stmt.setInt(6, goal.getCompletedMinutes());
            stmt.setString(7, goal.getStatus());
            stmt.executeUpdate();
        }
    }
    
    public void updateGoal(Goal goal) throws SQLException {
        String sql = "UPDATE goals SET title = ?, description = ?, deadline = ?, target_minutes = ?, completed_minutes = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, goal.getTitle());
            pstmt.setString(2, goal.getDescription());
            pstmt.setDate(3, goal.getDeadline());
            pstmt.setInt(4, goal.getTargetMinutes());
            pstmt.setInt(5, goal.getCompletedMinutes());
            pstmt.setString(6, goal.getStatus());
            pstmt.setInt(7, goal.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    public List<Goal> getGoalsByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM goals WHERE user_id = ? ORDER BY deadline ASC";
        List<Goal> goals = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Goal goal = new Goal();
                    goal.setId(rs.getInt("id"));
                    goal.setUserId(rs.getInt("user_id"));
                    goal.setTitle(rs.getString("title"));
                    goal.setDescription(rs.getString("description"));
                    goal.setDeadline(rs.getDate("deadline"));
                    goal.setTargetMinutes(rs.getInt("target_minutes"));
                    goal.setCompletedMinutes(rs.getInt("completed_minutes"));
                    goal.setStatus(rs.getString("status"));
                    goals.add(goal);
                }
            }
        }
        return goals;
    }
    
    public Goal getGoalById(int goalId) throws SQLException {
        String sql = "SELECT * FROM goals WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, goalId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Goal goal = new Goal();
                    goal.setId(rs.getInt("id"));
                    goal.setUserId(rs.getInt("user_id"));
                    goal.setTitle(rs.getString("title"));
                    goal.setDescription(rs.getString("description"));
                    goal.setDeadline(rs.getDate("deadline"));
                    goal.setTargetMinutes(rs.getInt("target_minutes"));
                    goal.setCompletedMinutes(rs.getInt("completed_minutes"));
                    goal.setStatus(rs.getString("status"));
                    return goal;
                }
            }
        }
        return null;
    }
    
    public void updateGoalProgress(int goalId, int additionalMinutes) throws SQLException {
        String sql = "UPDATE goals SET completed_minutes = completed_minutes + ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, additionalMinutes);
            pstmt.setInt(2, goalId);
            
            pstmt.executeUpdate();
        }
    }

    public void deleteGoal(int goalId) throws SQLException {
        String sql = "DELETE FROM goals WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, goalId);
            stmt.executeUpdate();
        }
    }
} 