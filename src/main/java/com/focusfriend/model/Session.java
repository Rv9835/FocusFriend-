package com.focusfriend.model;

import java.sql.Timestamp;

public class Session {
    private int id;
    private int userId;
    private Timestamp startTime;
    private Timestamp endTime;
    private String description;
    private int duration; // in minutes
    private String status; // "ACTIVE", "COMPLETED", "ABANDONED"

    public Session() {}

    public Session(int userId, Timestamp startTime, String description) {
        this.userId = userId;
        this.startTime = startTime;
        this.description = description;
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
} 