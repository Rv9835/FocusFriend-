package com.focusfriend.model;

import java.time.LocalDateTime;

public class ChatMessage {
    private Long id;
    private Long userId;
    private String message;
    private boolean aiResponse;
    private LocalDateTime createdAt;

    public ChatMessage() {}

    public ChatMessage(Long userId, String message, boolean aiResponse) {
        this.userId = userId;
        this.message = message;
        this.aiResponse = aiResponse;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isAiResponse() { return aiResponse; }
    public void setAiResponse(boolean aiResponse) { this.aiResponse = aiResponse; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
} 