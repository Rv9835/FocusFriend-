package com.focusfriend.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.focusfriend.dao.SessionDAO;
import com.focusfriend.model.Session;
import com.focusfriend.util.ErrorHandler;

@WebServlet("/session/*")
public class SessionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(SessionServlet.class.getName());
    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String action = request.getPathInfo();
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                ErrorHandler.handleError(request, response, "User not logged in", "login.jsp");
                return;
            }

            if ("/start".equals(action)) {
                Session focusSession = new Session();
                focusSession.setUserId(userId);
                focusSession.setStartTime(new Timestamp(System.currentTimeMillis()));
                focusSession.setStatus("ACTIVE");
                sessionDAO.addSession(focusSession);
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else if ("/end".equals(action)) {
                String sessionId = request.getParameter("sessionId");
                if (sessionId != null) {
                    Session focusSession = sessionDAO.getSession(Integer.parseInt(sessionId));
                    if (focusSession != null && focusSession.getUserId() == userId) {
                        focusSession.setEndTime(new Timestamp(System.currentTimeMillis()));
                        focusSession.setStatus("COMPLETED");
                        sessionDAO.updateSession(focusSession);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in session processing", e);
            ErrorHandler.handleError(request, response, "Error processing session", "dashboard.jsp");
        }
    }
} 