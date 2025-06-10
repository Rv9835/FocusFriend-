package com.focusfriend.dao;

import com.focusfriend.model.FocusSession;
import com.focusfriend.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FocusSessionDAO {
    private static final String CREATE_SESSION = 
        "INSERT INTO focus_sessions (user_id, type, duration, completed, start_time, " +
        "end_time, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_SESSION = 
        "SELECT * FROM focus_sessions WHERE id = ? AND user_id = ?";

    private static final String GET_USER_SESSIONS = 
        "SELECT * FROM focus_sessions WHERE user_id = ? ORDER BY start_time DESC";

    private static final String GET_ACTIVE_SESSIONS = 
        "SELECT * FROM focus_sessions WHERE user_id = ? AND completed = FALSE " +
        "AND start_time IS NOT NULL AND end_time IS NULL ORDER BY start_time DESC";

    private static final String GET_COMPLETED_SESSIONS = 
        "SELECT * FROM focus_sessions WHERE user_id = ? AND completed = TRUE " +
        "ORDER BY end_time DESC";

    private static final String GET_SESSIONS_BY_TYPE = 
        "SELECT * FROM focus_sessions WHERE user_id = ? AND type = ? " +
        "ORDER BY start_time DESC";

    private static final String GET_SESSIONS_BY_DATE_RANGE = 
        "SELECT * FROM focus_sessions WHERE user_id = ? AND start_time BETWEEN ? AND ? " +
        "ORDER BY start_time DESC";

    private static final String UPDATE_SESSION = 
        "UPDATE focus_sessions SET type = ?, duration = ?, completed = ?, " +
        "start_time = ?, end_time = ?, updated_at = ? WHERE id = ? AND user_id = ?";

    public FocusSession createSession(FocusSession session) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CREATE_SESSION, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, session.getUserId());
            stmt.setString(2, session.getType().name());
            stmt.setInt(3, session.getDuration());
            stmt.setBoolean(4, session.isCompleted());
            stmt.setTimestamp(5, Timestamp.valueOf(session.getStartTime()));
            stmt.setTimestamp(6, session.getEndTime() != null ? 
                Timestamp.valueOf(session.getEndTime()) : null);
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating session failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    session.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating session failed, no ID obtained.");
                }
            }

            return session;
        }
    }

    public FocusSession getSession(Long sessionId, Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_SESSION)) {
            
            stmt.setLong(1, sessionId);
            stmt.setLong(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSession(rs);
                }
                return null;
            }
        }
    }

    public List<FocusSession> getUserSessions(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_SESSIONS)) {
            
            stmt.setLong(1, userId);

            List<FocusSession> sessions = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapResultSetToSession(rs));
                }
            }
            return sessions;
        }
    }

    public List<FocusSession> getActiveSessions(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_ACTIVE_SESSIONS)) {
            
            stmt.setLong(1, userId);

            List<FocusSession> sessions = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapResultSetToSession(rs));
                }
            }
            return sessions;
        }
    }

    public List<FocusSession> getCompletedSessions(Long userId) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_COMPLETED_SESSIONS)) {
            
            stmt.setLong(1, userId);

            List<FocusSession> sessions = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapResultSetToSession(rs));
                }
            }
            return sessions;
        }
    }

    public List<FocusSession> getSessionsByType(Long userId, FocusSession.SessionType type) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_SESSIONS_BY_TYPE)) {
            
            stmt.setLong(1, userId);
            stmt.setString(2, type.name());

            List<FocusSession> sessions = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapResultSetToSession(rs));
                }
            }
            return sessions;
        }
    }

    public List<FocusSession> getSessionsByDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_SESSIONS_BY_DATE_RANGE)) {
            
            stmt.setLong(1, userId);
            stmt.setTimestamp(2, Timestamp.valueOf(startDate));
            stmt.setTimestamp(3, Timestamp.valueOf(endDate));

            List<FocusSession> sessions = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sessions.add(mapResultSetToSession(rs));
                }
            }
            return sessions;
        }
    }

    public boolean updateSession(FocusSession session) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_SESSION)) {
            
            stmt.setString(1, session.getType().name());
            stmt.setInt(2, session.getDuration());
            stmt.setBoolean(3, session.isCompleted());
            stmt.setTimestamp(4, Timestamp.valueOf(session.getStartTime()));
            stmt.setTimestamp(5, session.getEndTime() != null ? 
                Timestamp.valueOf(session.getEndTime()) : null);
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setLong(7, session.getId());
            stmt.setLong(8, session.getUserId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    private FocusSession mapResultSetToSession(ResultSet rs) throws SQLException {
        FocusSession session = new FocusSession();
        session.setId(rs.getLong("id"));
        session.setUserId(rs.getLong("user_id"));
        session.setType(FocusSession.SessionType.valueOf(rs.getString("type")));
        session.setDuration(rs.getInt("duration"));
        session.setCompleted(rs.getBoolean("completed"));
        session.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
        
        Timestamp endTime = rs.getTimestamp("end_time");
        if (endTime != null) {
            session.setEndTime(endTime.toLocalDateTime());
        }
        
        session.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        session.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return session;
    }
} 