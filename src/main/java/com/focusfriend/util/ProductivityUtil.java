package com.focusfriend.util;

import java.time.Duration;
import java.time.LocalDateTime;

public class ProductivityUtil {
    
    public static int calculateSessionDuration(LocalDateTime startTime, LocalDateTime endTime) {
        if (startTime == null || endTime == null) {
            return 0;
        }
        Duration duration = Duration.between(startTime, endTime);
        return (int) duration.toMinutes();
    }

    public static double calculateDailyProductivity(int totalMinutes, int targetMinutes) {
        if (targetMinutes == 0) {
            return 0;
        }
        return (double) totalMinutes / targetMinutes * 100;
    }

    public static String getProductivityStatus(double productivityPercentage) {
        if (productivityPercentage >= 100) {
            return "Excellent";
        } else if (productivityPercentage >= 80) {
            return "Very Good";
        } else if (productivityPercentage >= 60) {
            return "Good";
        } else if (productivityPercentage >= 40) {
            return "Fair";
        } else {
            return "Needs Improvement";
        }
    }

    public static int calculateStreak(int[] dailyMinutes) {
        int streak = 0;
        for (int minutes : dailyMinutes) {
            if (minutes > 0) {
                streak++;
            } else {
                break;
            }
        }
        return streak;
    }
} 