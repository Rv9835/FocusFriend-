package com.focusfriend.model;

import java.sql.Date;

public class Goal {
    private int id;
    private int userId;
    private String title;
    private String description;
    private Date deadline;
    private int targetMinutes;
    private int completedMinutes;
    private String status; // "ACTIVE", "COMPLETED", "ABANDONED"

    public Goal() {}

    public Goal(int userId, String title, String description, Date deadline, int targetMinutes) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.deadline = deadline;
        this.targetMinutes = targetMinutes;
        this.completedMinutes = 0;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public int getTargetMinutes() {
        return targetMinutes;
    }

    public void setTargetMinutes(int targetMinutes) {
        this.targetMinutes = targetMinutes;
    }

    public int getCompletedMinutes() {
        return completedMinutes;
    }

    public void setCompletedMinutes(int completedMinutes) {
        this.completedMinutes = completedMinutes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getProgressPercentage() {
        return (double) completedMinutes / targetMinutes * 100;
    }
} 