package com.focusfriend.model;

import java.time.LocalDateTime;

public class User {
    private Long id;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;
    private LocalDateTime updatedAt;
    private UserSettings settings;

    public User() {
        this.active = true;
        this.createdAt = LocalDateTime.now();
        this.settings = new UserSettings();
    }

    public User(String username, String email, String password, String fullName) {
        this();
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public UserSettings getSettings() {
        return settings;
    }

    public void setSettings(UserSettings settings) {
        this.settings = settings;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", createdAt=" + createdAt +
                ", lastLogin=" + lastLogin +
                '}';
    }

    public static class UserSettings {
        private int focusDuration; // in minutes
        private int shortBreakDuration; // in minutes
        private int longBreakDuration; // in minutes
        private int sessionsUntilLongBreak;
        private boolean autoStartBreaks;
        private boolean autoStartPomodoros;
        private boolean desktopNotifications;
        private boolean soundAlerts;
        private String themeColor;

        public UserSettings() {
            // Default settings
            this.focusDuration = 25;
            this.shortBreakDuration = 5;
            this.longBreakDuration = 15;
            this.sessionsUntilLongBreak = 4;
            this.autoStartBreaks = false;
            this.autoStartPomodoros = false;
            this.desktopNotifications = true;
            this.soundAlerts = true;
            this.themeColor = "#4a90e2";
        }

        // Getters and Setters
        public int getFocusDuration() {
            return focusDuration;
        }

        public void setFocusDuration(int focusDuration) {
            this.focusDuration = focusDuration;
        }

        public int getShortBreakDuration() {
            return shortBreakDuration;
        }

        public void setShortBreakDuration(int shortBreakDuration) {
            this.shortBreakDuration = shortBreakDuration;
        }

        public int getLongBreakDuration() {
            return longBreakDuration;
        }

        public void setLongBreakDuration(int longBreakDuration) {
            this.longBreakDuration = longBreakDuration;
        }

        public int getSessionsUntilLongBreak() {
            return sessionsUntilLongBreak;
        }

        public void setSessionsUntilLongBreak(int sessionsUntilLongBreak) {
            this.sessionsUntilLongBreak = sessionsUntilLongBreak;
        }

        public boolean isAutoStartBreaks() {
            return autoStartBreaks;
        }

        public void setAutoStartBreaks(boolean autoStartBreaks) {
            this.autoStartBreaks = autoStartBreaks;
        }

        public boolean isAutoStartPomodoros() {
            return autoStartPomodoros;
        }

        public void setAutoStartPomodoros(boolean autoStartPomodoros) {
            this.autoStartPomodoros = autoStartPomodoros;
        }

        public boolean isDesktopNotifications() {
            return desktopNotifications;
        }

        public void setDesktopNotifications(boolean desktopNotifications) {
            this.desktopNotifications = desktopNotifications;
        }

        public boolean isSoundAlerts() {
            return soundAlerts;
        }

        public void setSoundAlerts(boolean soundAlerts) {
            this.soundAlerts = soundAlerts;
        }

        public String getThemeColor() {
            return themeColor;
        }

        public void setThemeColor(String themeColor) {
            this.themeColor = themeColor;
        }
    }
} 