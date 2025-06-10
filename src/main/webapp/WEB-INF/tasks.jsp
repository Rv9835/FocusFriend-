<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tasks - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
      rel="stylesheet"
    />
    <style>
      body {
        background-color: #f8f9fa;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        position: relative;
        min-height: 100vh;
      }
      body::before {
        content: "";
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path d="M50 0 L100 50 L50 100 L0 50 Z" fill="none" stroke="rgba(0,0,0,0.15)" stroke-width="3"/><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(0,0,0,0.15)" stroke-width="3"/><path d="M50 10 L90 50 L50 90 L10 50 Z" fill="none" stroke="rgba(0,0,0,0.15)" stroke-width="3"/><path d="M50 20 L80 50 L50 80 L20 50 Z" fill="none" stroke="rgba(0,0,0,0.15)" stroke-width="3"/><path d="M50 30 L70 50 L50 70 L30 50 Z" fill="none" stroke="rgba(0,0,0,0.15)" stroke-width="3"/></svg>');
        background-repeat: repeat;
        background-size: 150px 150px;
        opacity: 0.2;
        z-index: -1;
        pointer-events: none;
        transform: rotate(45deg);
      }
      .task-card {
        background: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        position: relative;
        z-index: 1;
      }
      .task-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
      }
      .task-list {
        max-height: 600px;
        overflow-y: auto;
      }
      .task-item {
        background: white;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 10px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      }
      .task-item.completed {
        opacity: 0.7;
      }
      .task-item.completed .task-title {
        text-decoration: line-through;
      }
      .nav-link {
        color: #495057;
        padding: 0.5rem 1rem;
        border-radius: 0.25rem;
      }
      .nav-link:hover {
        background-color: #e9ecef;
      }
      .nav-link.active {
        color: #0d6efd;
        background-color: #e9ecef;
      }
    </style>
  </head>
  <body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
      <div class="container">
        <a
          class="navbar-brand"
          href="${pageContext.request.contextPath}/dashboard"
        >
          <i class="fas fa-brain"></i> FocusFriend
        </a>
        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav me-auto">
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/dashboard"
              >
                <i class="fas fa-home"></i> Dashboard
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link active"
                href="${pageContext.request.contextPath}/tasks"
              >
                <i class="fas fa-tasks"></i> Tasks
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/progress"
              >
                <i class="fas fa-chart-line"></i> Progress
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/settings"
              >
                <i class="fas fa-cog"></i> Settings
              </a>
            </li>
          </ul>
          <ul class="navbar-nav">
            <li class="nav-item">
              <a
                class="nav-link text-danger"
                href="${pageContext.request.contextPath}/logout"
              >
                <i class="fas fa-sign-out-alt"></i> Logout
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container mt-5">
      <div class="task-card">
        <div class="task-header">
          <h2><i class="fas fa-tasks"></i> My Tasks</h2>
          <button
            class="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#addTaskModal"
          >
            <i class="fas fa-plus"></i> Add Task
          </button>
        </div>

        <div class="task-list" id="taskList">
          <!-- Tasks will be loaded here dynamically -->
        </div>
      </div>
    </div>

    <!-- Add Task Modal -->
    <div class="modal fade" id="addTaskModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add New Task</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <form id="addTaskForm">
              <div class="mb-3">
                <label for="taskTitle" class="form-label">Task Title</label>
                <input
                  type="text"
                  class="form-control"
                  id="taskTitle"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="taskDescription" class="form-label"
                  >Description</label
                >
                <textarea
                  class="form-control"
                  id="taskDescription"
                  rows="3"
                ></textarea>
              </div>
              <div class="mb-3">
                <label for="taskPriority" class="form-label">Priority</label>
                <select class="form-select" id="taskPriority">
                  <option value="LOW">Low</option>
                  <option value="MEDIUM">Medium</option>
                  <option value="HIGH">High</option>
                </select>
              </div>
              <div class="mb-3">
                <label for="taskDueDate" class="form-label">Due Date</label>
                <input
                  type="datetime-local"
                  class="form-control"
                  id="taskDueDate"
                />
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <button type="button" class="btn btn-primary" id="saveTask">
              Save Task
            </button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Load tasks when page loads
      document.addEventListener("DOMContentLoaded", function () {
        loadTasks();
      });

      // Load tasks from server
      function loadTasks() {
        fetch("${pageContext.request.contextPath}/tasks/api/list")
          .then((response) => response.json())
          .then((tasks) => {
            const taskList = document.getElementById("taskList");
            taskList.innerHTML = "";

            tasks.forEach((task) => {
              const taskElement = createTaskElement(task);
              taskList.appendChild(taskElement);
            });
          })
          .catch((error) => console.error("Error loading tasks:", error));
      }

      // Create task element
      function createTaskElement(task) {
        const div = document.createElement("div");
        div.className = `task-item ${task.completed ? "completed" : ""}`;
        div.innerHTML = `
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="task-title">${task.title}</h5>
                        <p class="text-muted">${task.description || ""}</p>
                    </div>
                    <div>
                        <button class="btn btn-sm btn-success" onclick="toggleTask(${
                          task.id
                        })">
                            <i class="fas fa-check"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="deleteTask(${
                          task.id
                        })">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `;
        return div;
      }

      // Save new task
      document
        .getElementById("saveTask")
        .addEventListener("click", function () {
          const task = {
            title: document.getElementById("taskTitle").value,
            description: document.getElementById("taskDescription").value,
            priority: document.getElementById("taskPriority").value,
            dueDate: document.getElementById("taskDueDate").value,
          };

          fetch("${pageContext.request.contextPath}/tasks", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(task),
          })
            .then((response) => {
              if (response.ok) {
                loadTasks();
                bootstrap.Modal.getInstance(
                  document.getElementById("addTaskModal")
                ).hide();
                document.getElementById("addTaskForm").reset();
              }
            })
            .catch((error) => console.error("Error saving task:", error));
        });

      // Toggle task completion
      function toggleTask(taskId) {
        fetch(`${pageContext.request.contextPath}/tasks/${taskId}/toggle`, {
          method: "POST",
        })
          .then((response) => {
            if (response.ok) {
              loadTasks();
            }
          })
          .catch((error) => console.error("Error toggling task:", error));
      }

      // Delete task
      function deleteTask(taskId) {
        if (confirm("Are you sure you want to delete this task?")) {
          fetch(`${pageContext.request.contextPath}/tasks/${taskId}`, {
            method: "DELETE",
          })
            .then((response) => {
              if (response.ok) {
                loadTasks();
              }
            })
            .catch((error) => console.error("Error deleting task:", error));
        }
      }
    </script>
  </body>
</html>
