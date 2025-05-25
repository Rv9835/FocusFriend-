package com.focusfriend.dao;

import com.focusfriend.model.Session;
import com.focusfriend.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SessionDAO {
    
    public void createSession(Session session) throws SQLException {
        String sql = "INSERT INTO sessions (user_id, start_time, description, status) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, session.getUserId());
            pstmt.setTimestamp(2, Timestamp.valueOf(session.getStartTime()));
            pstmt.setString(3, session.getDescription());
            pstmt.setString(4, session.getStatus());
            
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    session.setId(rs.getInt(1));
                }
            }
        }
    }
    
    public void updateSession(Session session) throws SQLException {
        String sql = "UPDATE sessions SET end_time = ?, duration = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, Timestamp.valueOf(session.getEndTime()));
            pstmt.setInt(2, session.getDuration());
            pstmt.setString(3, session.getStatus());
            pstmt.setInt(4, session.getId());
            
            pstmt.executeUpdate();
        }
    }
    
    public List<Session> getSessionsByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM sessions WHERE user_id = ? ORDER BY start_time DESC";
        List<Session> sessions = new ArrayList<>();
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Session session = new Session();
                    session.setId(rs.getInt("id"));
                    session.setUserId(rs.getInt("user_id"));
                    session.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                    session.setEndTime(rs.getTimestamp("end_time") != null ? 
                                     rs.getTimestamp("end_time").toLocalDateTime() : null);
                    session.setDescription(rs.getString("description"));
                    session.setDuration(rs.getInt("duration"));
                    session.setStatus(rs.getString("status"));
                    sessions.add(session);
                }
            }
        }
        return sessions;
    }
    
    public Session getActiveSession(int userId) throws SQLException {
        String sql = "SELECT * FROM sessions WHERE user_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Session session = new Session();
                    session.setId(rs.getInt("id"));
                    session.setUserId(rs.getInt("user_id"));
                    session.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                    session.setEndTime(rs.getTimestamp("end_time") != null ? 
                                     rs.getTimestamp("end_time").toLocalDateTime() : null);
                    session.setDescription(rs.getString("description"));
                    session.setDuration(rs.getInt("duration"));
                    session.setStatus(rs.getString("status"));
                    return session;
                }
            }
        }
        return null;
    }
} 