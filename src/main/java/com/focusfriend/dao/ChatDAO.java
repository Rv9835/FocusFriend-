package com.focusfriend.dao;

import com.focusfriend.model.ChatMessage;
import com.focusfriend.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {
    private static final String INSERT_MESSAGE = "INSERT INTO chat_messages (user_id, message, is_ai_response, created_at) VALUES (?, ?, ?, ?)";
    private static final String GET_RECENT_MESSAGES = "SELECT * FROM chat_messages ORDER BY created_at DESC LIMIT ?";

    public void saveMessage(ChatMessage msg) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_MESSAGE)) {
            stmt.setLong(1, msg.getUserId());
            stmt.setString(2, msg.getMessage());
            stmt.setBoolean(3, msg.isAiResponse());
            stmt.setTimestamp(4, Timestamp.valueOf(msg.getCreatedAt()));
            stmt.executeUpdate();
        }
    }

    public List<ChatMessage> getRecentMessages(int limit) throws SQLException {
        List<ChatMessage> messages = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_RECENT_MESSAGES)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ChatMessage msg = new ChatMessage();
                    msg.setId(rs.getLong("id"));
                    msg.setUserId(rs.getLong("user_id"));
                    msg.setMessage(rs.getString("message"));
                    msg.setAiResponse(rs.getBoolean("is_ai_response"));
                    msg.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    messages.add(msg);
                }
            }
        }
        return messages;
    }
} 