package com.focusfriend.dao;

import com.focusfriend.model.UserSettings;
import com.focusfriend.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserSettingsDAO {
    private static final String CREATE_SETTINGS = 
        "INSERT INTO user_settings (user_id, theme, notification_enabled, " +
        "sound_enabled, focus_duration, break_duration, long_break_duration, " +
        "created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_SETTINGS = 
        "SELECT * FROM user_settings WHERE user_id = ?";

    private static final String UPDATE_SETTINGS = 
        "UPDATE user_settings SET theme = ?, notification_enabled = ?, " +
        "sound_enabled = ?, focus_duration = ?, break_duration = ?, " +
        "long_break_duration = ?, updated_at = ? WHERE user_id = ?";

    public UserSettings createSettings(UserSettings settings) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CREATE_SETTINGS)) {
            
            stmt.setLong(1, settings.getUserId());
            stmt.setString(2, settings.getTheme());
            stmt.setBoolean(3, settings.isNotificationEnabled());
            stmt.setBoolean(4, settings.isSoundEnabled());
            stmt.setInt(5, settings.getFocusDuration());
            stmt.setInt(6, settings.getBreakDuration());
            stmt.setInt(7, settings.getLongBreakDuration());
            stmt.setTimestamp(8, Timestamp.valueOf(settings.getCreatedAt()));
            stmt.setTimestamp(9, Timestamp.valueOf(settings.getUpdatedAt()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating settings failed, no rows affected.");
            }

            return settings;
        }
    }

    public UserSettings getSettings(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_SETTINGS)) {
            
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSettings(rs);
                }
                return null;
            }
        }
    }

    public boolean updateSettings(UserSettings settings) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_SETTINGS)) {
            
            stmt.setString(1, settings.getTheme());
            stmt.setBoolean(2, settings.isNotificationEnabled());
            stmt.setBoolean(3, settings.isSoundEnabled());
            stmt.setInt(4, settings.getFocusDuration());
            stmt.setInt(5, settings.getBreakDuration());
            stmt.setInt(6, settings.getLongBreakDuration());
            stmt.setTimestamp(7, Timestamp.valueOf(settings.getUpdatedAt()));
            stmt.setLong(8, settings.getUserId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    private UserSettings mapResultSetToSettings(ResultSet rs) throws SQLException {
        UserSettings settings = new UserSettings();
        settings.setUserId(rs.getLong("user_id"));
        settings.setTheme(rs.getString("theme"));
        settings.setNotificationEnabled(rs.getBoolean("notification_enabled"));
        settings.setSoundEnabled(rs.getBoolean("sound_enabled"));
        settings.setFocusDuration(rs.getInt("focus_duration"));
        settings.setBreakDuration(rs.getInt("break_duration"));
        settings.setLongBreakDuration(rs.getInt("long_break_duration"));
        settings.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        settings.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return settings;
    }

    public UserSettings getUserSettings(Long userId) throws SQLException {
        return getSettings(userId);
    }

    public boolean deleteSettings(Long userId) throws SQLException {
        String sql = "DELETE FROM user_settings WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }
} 