package com.focusfriend.servlet;

import com.focusfriend.dao.TaskDAO;
import com.focusfriend.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Check if this is an API request
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            handleApiRequest(request, response, session);
        } else {
            // Regular page request
            request.getRequestDispatcher("tasks.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Create new task
        Task task = new Task();
        task.setUserId((int) session.getAttribute("userId"));
        task.setTitle(request.getParameter("title"));
        task.setDescription(request.getParameter("description"));
        task.setPriority(request.getParameter("priority"));
        task.setDueDate(java.sql.Timestamp.valueOf(request.getParameter("dueDate")));

        int taskId = taskDAO.createTask(task);

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", true);
        jsonResponse.addProperty("taskId", taskId);

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    @Override
    protected void doPatch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int taskId = Integer.parseInt(request.getParameter("taskId"));
        Task task = taskDAO.getTaskById(taskId);

        if (task != null && task.getUserId() == (int) session.getAttribute("userId")) {
            task.setCompleted(Boolean.parseBoolean(request.getParameter("completed")));
            taskDAO.updateTask(task);

            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);

            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(jsonResponse));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int taskId = Integer.parseInt(request.getParameter("taskId"));
        Task task = taskDAO.getTaskById(taskId);

        if (task != null && task.getUserId() == (int) session.getAttribute("userId")) {
            taskDAO.deleteTask(taskId);

            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);

            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(jsonResponse));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        // Sample data for testing
        JsonArray tasks = new JsonArray();
        
        JsonObject task1 = new JsonObject();
        task1.addProperty("id", 1);
        task1.addProperty("title", "Complete Project Report");
        task1.addProperty("description", "Write the final project report");
        task1.addProperty("priority", "high");
        task1.addProperty("dueDate", "2024-03-20T15:00:00");
        task1.addProperty("completed", false);
        tasks.add(task1);

        JsonObject task2 = new JsonObject();
        task2.addProperty("id", 2);
        task2.addProperty("title", "Review Code Changes");
        task2.addProperty("description", "Review pull requests");
        task2.addProperty("priority", "medium");
        task2.addProperty("dueDate", "2024-03-19T12:00:00");
        task2.addProperty("completed", true);
        tasks.add(task2);

        JsonObject task3 = new JsonObject();
        task3.addProperty("id", 3);
        task3.addProperty("title", "Update Documentation");
        task3.addProperty("description", "Update API documentation");
        task3.addProperty("priority", "low");
        task3.addProperty("dueDate", "2024-03-21T18:00:00");
        task3.addProperty("completed", false);
        tasks.add(task3);

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(tasks));
    }
} 