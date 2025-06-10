package com.focusfriend.servlet;

import com.focusfriend.dao.ChatDAO;
import com.focusfriend.model.ChatMessage;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class ChatServlet extends HttpServlet {
    private ChatDAO chatDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        chatDAO = new ChatDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if user is logged in
        Long userId = (Long) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        // If it's an API request
        if (pathInfo != null && pathInfo.equals("/api")) {
            response.setContentType("application/json");
            try {
                List<ChatMessage> messages = chatDAO.getRecentMessages(50);
                response.getWriter().write(gson.toJson(messages));
            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Database error\"}");
            }
            return;
        }

        // Otherwise, show the chat page
        request.getRequestDispatcher("/WEB-INF/chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long userId = (Long) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }

        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Message required\"}");
            return;
        }

        ChatMessage chatMessage = new ChatMessage(userId, message, false);
        chatMessage.setCreatedAt(LocalDateTime.now());

        try {
            chatDAO.saveMessage(chatMessage);
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(gson.toJson(chatMessage));
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error\"}");
        }
    }
} 