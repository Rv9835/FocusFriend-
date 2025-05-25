// GeminiUtil.java is currently disabled due to missing Google Cloud Vertex AI Java SDK support.
// Placeholder for future AI integration.

/*
package com.focusfriend.util;

import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.ChatSession;
import com.google.cloud.vertexai.generativeai.Content;
import com.google.cloud.vertexai.generativeai.Part;

import java.util.List;
import java.util.ArrayList;

public class GeminiUtil {
    private static final String API_KEY = "AIzaSyBP0BTKp97HpdOZE-XCVEQP5XhaCTGtSxc";
    private static final String PROJECT_ID = "focusfriend";
    private static final String LOCATION = "us-central1";
    private static final String MODEL_NAME = "gemini-pro";

    private static VertexAI vertexAI;
    private static GenerativeModel model;

    static {
        try {
            vertexAI = new VertexAI(PROJECT_ID, LOCATION);
            model = new GenerativeModel(MODEL_NAME, vertexAI);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String analyzeGoals(List<String> goals) {
        try {
            StringBuilder prompt = new StringBuilder();
            prompt.append("Analyze these productivity goals and provide insights and suggestions:\n\n");
            for (String goal : goals) {
                prompt.append("- ").append(goal).append("\n");
            }
            prompt.append("\nPlease provide:\n");
            prompt.append("1. Overall progress analysis\n");
            prompt.append("2. Suggestions for improvement\n");
            prompt.append("3. Potential obstacles and solutions\n");

            GenerateContentResponse response = model.generateContent(prompt.toString());
            return response.getCandidates(0).getContent().getParts(0).getText();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error analyzing goals: " + e.getMessage();
        }
    }

    public static String getGoalSuggestions(String currentGoal) {
        try {
            String prompt = "Based on this productivity goal: \"" + currentGoal + 
                          "\", provide 3 specific and actionable suggestions to improve it. " +
                          "Format the response as a numbered list.";

            GenerateContentResponse response = model.generateContent(prompt);
            return response.getCandidates(0).getContent().getParts(0).getText();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error getting suggestions: " + e.getMessage();
        }
    }

    public static ChatSession createChatSession() {
        return model.startChat();
    }

    public static String sendChatMessage(ChatSession chatSession, String message) {
        try {
            GenerateContentResponse response = chatSession.sendMessage(message);
            return response.getCandidates(0).getContent().getParts(0).getText();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error in chat: " + e.getMessage();
        }
    }

    public static String getProductivityTips() {
        try {
            String prompt = "Provide 5 practical productivity tips for maintaining focus and achieving goals. " +
                          "Format the response as a numbered list with brief explanations.";

            GenerateContentResponse response = model.generateContent(prompt);
            return response.getCandidates(0).getContent().getParts(0).getText();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error getting productivity tips: " + e.getMessage();
        }
    }
}
*/ 