// AIServlet.java is currently disabled due to missing GeminiUtil and AI integration.
// Placeholder for future AI integration.

/*
package com.focusfriend.servlet;

import com.focusfriend.dao.GoalDAO;
import com.focusfriend.dao.SessionDAO;
import com.focusfriend.model.Goal;
import com.focusfriend.model.Session;
import com.focusfriend.util.GeminiUtil;
import com.google.cloud.vertexai.generativeai.ChatSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ai/*")
public class AIServlet extends HttpServlet {
    private GoalDAO goalDAO;
    private SessionDAO sessionDAO;

    @Override
    public void init() throws ServletException {
        goalDAO = new GoalDAO();
        sessionDAO = new SessionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/analyze";
        }

        switch (pathInfo) {
            case "/analyze":
                analyzeGoals(request, response);
                break;
            case "/suggestions":
                getSuggestions(request, response);
                break;
            case "/tips":
                getProductivityTips(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/chat";
        }

        switch (pathInfo) {
            case "/chat":
                handleChat(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void analyzeGoals(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Goal> goals = goalDAO.getGoalsByUserId(userId);
        List<String> goalStrings = new ArrayList<>();
        
        for (Goal goal : goals) {
            goalStrings.add(String.format("%s (Target: %d minutes, Completed: %d minutes)",
                goal.getTitle(), goal.getTargetMinutes(), goal.getCompletedMinutes()));
        }

        String analysis = GeminiUtil.analyzeGoals(goalStrings);
        response.setContentType("application/json");
        response.getWriter().write("{\"analysis\": \"" + analysis.replace("\n", "\\n").replace("\"", "\\\"") + "\"}");
    }

    private void getSuggestions(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String goalId = request.getParameter("goalId");
        if (goalId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Goal goal = goalDAO.getGoalById(Integer.parseInt(goalId));
        if (goal == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String suggestions = GeminiUtil.getGoalSuggestions(goal.getTitle());
        response.setContentType("application/json");
        response.getWriter().write("{\"suggestions\": \"" + suggestions.replace("\n", "\\n").replace("\"", "\\\"") + "\"}");
    }

    private void getProductivityTips(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tips = GeminiUtil.getProductivityTips();
        response.setContentType("application/json");
        response.getWriter().write("{\"tips\": \"" + tips.replace("\n", "\\n").replace("\"", "\\\"") + "\"}");
    }

    private void handleChat(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String message = request.getParameter("message");
        if (message == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        ChatSession chatSession = (ChatSession) session.getAttribute("chatSession");
        if (chatSession == null) {
            chatSession = GeminiUtil.createChatSession();
            session.setAttribute("chatSession", chatSession);
        }

        String response = GeminiUtil.sendChatMessage(chatSession, message);
        response.setContentType("application/json");
        response.getWriter().write("{\"response\": \"" + response.replace("\n", "\\n").replace("\"", "\\\"") + "\"}");
    }
}
*/ 