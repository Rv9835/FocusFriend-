package com.focusfriend.util;

public class TaskUtils {
    public static String getPriorityColor(String priority) {
        if (priority == null) {
            return "secondary";
        }
        
        switch (priority.toLowerCase()) {
            case "high":
                return "danger";
            case "medium":
                return "warning";
            case "low":
                return "success";
            default:
                return "secondary";
        }
    }
} 