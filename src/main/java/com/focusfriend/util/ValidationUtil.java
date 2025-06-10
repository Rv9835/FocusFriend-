package com.focusfriend.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PASSWORD_PATTERN = 
        Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");
    
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }
    
    public static boolean isValidPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }
    
    public static boolean isValidSessionDuration(int duration) {
        return duration > 0 && duration <= 240; // Max 4 hours
    }
    
    public static boolean isValidGoalTitle(String title) {
        return title != null && !title.trim().isEmpty() && title.length() <= 100;
    }
    
    public static boolean isValidGoalDescription(String description) {
        return description != null && description.length() <= 500;
    }
    
    public static String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }
        return input.replaceAll("[<>\"']", "");
    }
} 