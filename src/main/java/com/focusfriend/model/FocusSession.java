package com.focusfriend.model;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class FocusSession {
    public enum SessionType {
        FOCUS,
        BREAK,
        LONG_BREAK
    }

    private Long id;
    private Long userId;
    private SessionType type;
    private int duration;
    private boolean completed;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public FocusSession() {
        this.completed = false;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public SessionType getType() {
        return type;
    }

    public void setType(SessionType type) {
        this.type = type;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void endSession() {
        this.completed = true;
        this.endTime = LocalDateTime.now();
    }

    public long getActualDuration() {
        if (startTime == null) {
            return 0;
        }
        LocalDateTime end = endTime != null ? endTime : LocalDateTime.now();
        return ChronoUnit.MINUTES.between(startTime, end);
    }

    public boolean isActive() {
        return !completed && startTime != null && endTime == null;
    }

    @Override
    public String toString() {
        return "FocusSession{" +
                "id=" + id +
                ", userId=" + userId +
                ", type=" + type +
                ", duration=" + duration +
                ", completed=" + completed +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 