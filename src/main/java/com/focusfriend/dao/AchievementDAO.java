package com.focusfriend.dao;

import com.focusfriend.model.Achievement;
import com.focusfriend.util.DatabaseUtil;
import com.google.gson.JsonObject;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AchievementDAO {
    private static final String CREATE_ACHIEVEMENT = 
        "INSERT INTO achievements (user_id, name, description, icon, points, unlocked, " +
        "unlocked_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_ACHIEVEMENT = 
        "SELECT * FROM achievements WHERE id = ? AND user_id = ?";

    private static final String GET_USER_ACHIEVEMENTS = 
        "SELECT * FROM achievements WHERE user_id = ?";

    private static final String GET_UNLOCKED_ACHIEVEMENTS = 
        "SELECT * FROM achievements WHERE user_id = ? AND unlocked = TRUE";

    private static final String GET_LOCKED_ACHIEVEMENTS = 
        "SELECT * FROM achievements WHERE user_id = ? AND unlocked = FALSE";

    private static final String UPDATE_ACHIEVEMENT = 
        "UPDATE achievements SET name = ?, description = ?, icon = ?, points = ?, " +
        "unlocked = ?, unlocked_at = ?, updated_at = ? WHERE id = ? AND user_id = ?";

    private static final String DELETE_ACHIEVEMENT = 
        "DELETE FROM achievements WHERE id = ? AND user_id = ?";

    private static final String GET_ACHIEVEMENT_PROGRESS = 
        "SELECT " +
        "COUNT(*) as total_achievements, " +
        "SUM(CASE WHEN unlocked = TRUE THEN 1 ELSE 0 END) as unlocked_achievements, " +
        "SUM(points) as total_points, " +
        "SUM(CASE WHEN unlocked = TRUE THEN points ELSE 0 END) as earned_points " +
        "FROM achievements WHERE user_id = ?";

    public Achievement createAchievement(Achievement achievement) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CREATE_ACHIEVEMENT, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, achievement.getUserId());
            stmt.setString(2, achievement.getName());
            stmt.setString(3, achievement.getDescription());
            stmt.setString(4, achievement.getIcon());
            stmt.setInt(5, achievement.getPoints());
            stmt.setBoolean(6, achievement.isUnlocked());
            stmt.setTimestamp(7, achievement.getUnlockedAt() != null ? 
                Timestamp.valueOf(achievement.getUnlockedAt()) : null);
            stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating achievement failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    achievement.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating achievement failed, no ID obtained.");
                }
            }

            return achievement;
        }
    }

    public Achievement getAchievement(Long achievementId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_ACHIEVEMENT)) {
            
            stmt.setLong(1, achievementId);
            stmt.setLong(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAchievement(rs);
                }
                return null;
            }
        }
    }

    public List<Achievement> getUserAchievements(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_ACHIEVEMENTS)) {
            
            stmt.setLong(1, userId);

            List<Achievement> achievements = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    achievements.add(mapResultSetToAchievement(rs));
                }
            }
            return achievements;
        }
    }

    public List<Achievement> getUnlockedAchievements(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_UNLOCKED_ACHIEVEMENTS)) {
            
            stmt.setLong(1, userId);

            List<Achievement> achievements = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    achievements.add(mapResultSetToAchievement(rs));
                }
            }
            return achievements;
        }
    }

    public List<Achievement> getLockedAchievements(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_LOCKED_ACHIEVEMENTS)) {
            
            stmt.setLong(1, userId);

            List<Achievement> achievements = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    achievements.add(mapResultSetToAchievement(rs));
                }
            }
            return achievements;
        }
    }

    public boolean updateAchievement(Achievement achievement) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_ACHIEVEMENT)) {
            
            stmt.setString(1, achievement.getName());
            stmt.setString(2, achievement.getDescription());
            stmt.setString(3, achievement.getIcon());
            stmt.setInt(4, achievement.getPoints());
            stmt.setBoolean(5, achievement.isUnlocked());
            stmt.setTimestamp(6, achievement.getUnlockedAt() != null ? 
                Timestamp.valueOf(achievement.getUnlockedAt()) : null);
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(8, achievement.getId());
            stmt.setLong(9, achievement.getUserId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public boolean deleteAchievement(Long achievementId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_ACHIEVEMENT)) {
            
            stmt.setLong(1, achievementId);
            stmt.setLong(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public JsonObject getAchievementProgress(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_ACHIEVEMENT_PROGRESS)) {
            
            stmt.setLong(1, userId);

            JsonObject progress = new JsonObject();
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    progress.addProperty("totalAchievements", rs.getInt("total_achievements"));
                    progress.addProperty("unlockedAchievements", rs.getInt("unlocked_achievements"));
                    progress.addProperty("totalPoints", rs.getInt("total_points"));
                    progress.addProperty("earnedPoints", rs.getInt("earned_points"));
                }
            }
            return progress;
        }
    }

    private Achievement mapResultSetToAchievement(ResultSet rs) throws SQLException {
        Achievement achievement = new Achievement();
        achievement.setId(rs.getLong("id"));
        achievement.setUserId(rs.getLong("user_id"));
        achievement.setName(rs.getString("name"));
        achievement.setDescription(rs.getString("description"));
        achievement.setIcon(rs.getString("icon"));
        achievement.setPoints(rs.getInt("points"));
        achievement.setUnlocked(rs.getBoolean("unlocked"));
        
        Timestamp unlockedAt = rs.getTimestamp("unlocked_at");
        if (unlockedAt != null) {
            achievement.setUnlockedAt(unlockedAt.toLocalDateTime());
        }
        
        achievement.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        achievement.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return achievement;
    }
} 