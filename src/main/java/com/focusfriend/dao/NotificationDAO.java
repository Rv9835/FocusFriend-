package com.focusfriend.dao;

import com.focusfriend.model.Notification;
import com.focusfriend.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    private static final String CREATE_NOTIFICATION = 
        "INSERT INTO notifications (user_id, title, message, type, read, read_at, " +
        "created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_NOTIFICATION = 
        "SELECT * FROM notifications WHERE id = ? AND user_id = ?";

    private static final String GET_USER_NOTIFICATIONS = 
        "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";

    private static final String GET_UNREAD_NOTIFICATIONS = 
        "SELECT * FROM notifications WHERE user_id = ? AND read = FALSE ORDER BY created_at DESC";

    private static final String GET_UNREAD_NOTIFICATION_COUNT = 
        "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND read = FALSE";

    private static final String UPDATE_NOTIFICATION = 
        "UPDATE notifications SET title = ?, message = ?, type = ?, read = ?, " +
        "read_at = ?, updated_at = ? WHERE id = ? AND user_id = ?";

    private static final String DELETE_NOTIFICATION = 
        "DELETE FROM notifications WHERE id = ? AND user_id = ?";

    public Notification createNotification(Notification notification) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CREATE_NOTIFICATION, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, notification.getUserId());
            stmt.setString(2, notification.getTitle());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getType());
            stmt.setBoolean(5, notification.isRead());
            stmt.setTimestamp(6, notification.getReadAt() != null ? 
                Timestamp.valueOf(notification.getReadAt()) : null);
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating notification failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    notification.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating notification failed, no ID obtained.");
                }
            }

            return notification;
        }
    }

    public Notification getNotification(Long notificationId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_NOTIFICATION)) {
            
            stmt.setLong(1, notificationId);
            stmt.setLong(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNotification(rs);
                }
                return null;
            }
        }
    }

    public List<Notification> getUserNotifications(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_NOTIFICATIONS)) {
            
            stmt.setLong(1, userId);

            List<Notification> notifications = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            return notifications;
        }
    }

    public List<Notification> getUnreadNotifications(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_UNREAD_NOTIFICATIONS)) {
            
            stmt.setLong(1, userId);

            List<Notification> notifications = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            return notifications;
        }
    }

    public int getUnreadNotificationCount(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_UNREAD_NOTIFICATION_COUNT)) {
            
            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                return 0;
            }
        }
    }

    public boolean updateNotification(Notification notification) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_NOTIFICATION)) {
            
            stmt.setString(1, notification.getTitle());
            stmt.setString(2, notification.getMessage());
            stmt.setString(3, notification.getType());
            stmt.setBoolean(4, notification.isRead());
            stmt.setTimestamp(5, notification.getReadAt() != null ? 
                Timestamp.valueOf(notification.getReadAt()) : null);
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(7, notification.getId());
            stmt.setLong(8, notification.getUserId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public boolean deleteNotification(Long notificationId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_NOTIFICATION)) {
            
            stmt.setLong(1, notificationId);
            stmt.setLong(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getLong("id"));
        notification.setUserId(rs.getLong("user_id"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setRead(rs.getBoolean("read"));
        
        Timestamp readAt = rs.getTimestamp("read_at");
        if (readAt != null) {
            notification.setReadAt(readAt.toLocalDateTime());
        }
        
        notification.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        notification.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return notification;
    }
} 