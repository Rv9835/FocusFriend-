<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="task"
uri="http://focusfriend.com/task-functions" %>
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
      :root {
        --primary-color: #4a90e2;
        --secondary-color: #764ba2;
        --accent-color: #5cb3ff;
        --text-color: #2c3e50;
        --light-text: #666;
        --white: #ffffff;
      }

      body {
        background: linear-gradient(
          135deg,
          var(--primary-color) 0%,
          var(--secondary-color) 100%
        );
        min-height: 100vh;
        position: relative;
        overflow-x: hidden;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }

      .particles {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: -1;
      }

      .navbar {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 1rem 0;
      }

      .navbar-brand {
        color: var(--primary-color) !important;
        font-weight: 600;
        font-size: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .navbar-brand i {
        font-size: 1.8rem;
        background: linear-gradient(
          45deg,
          var(--primary-color),
          var(--accent-color)
        );
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
      }

      .nav-link {
        color: var(--primary-color) !important;
        font-weight: 500;
        transition: all 0.3s ease;
        padding: 0.5rem 1rem;
        border-radius: 8px;
      }

      .nav-link:hover {
        background: rgba(74, 144, 226, 0.1);
        transform: translateY(-2px);
      }

      .main-content {
        padding: 2rem;
        margin-top: 1rem;
      }

      .card {
        background: rgba(255, 255, 255, 0.95);
        border: none;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        backdrop-filter: blur(10px);
        transition: all 0.3s ease;
        overflow: hidden;
        margin-bottom: 2rem;
      }

      .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
      }

      .card-header {
        background: transparent;
        border-bottom: 2px solid rgba(74, 144, 226, 0.1);
        padding: 1.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }

      .card-title {
        color: var(--primary-color);
        font-weight: 600;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .task-list {
        padding: 1.5rem;
      }

      .task-item {
        padding: 15px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        transition: background-color 0.3s;
      }

      .task-item:hover {
        background-color: rgba(74, 144, 226, 0.05);
      }

      .task-checkbox {
        width: 20px;
        height: 20px;
        margin-right: 10px;
      }

      .task-content {
        flex-grow: 1;
      }

      .task-title {
        color: var(--text-color);
        font-weight: 500;
        margin-bottom: 0.25rem;
      }

      .task-description {
        color: var(--light-text);
        font-size: 0.9rem;
      }

      .task-actions {
        display: flex;
        gap: 0.5rem;
      }

      .task-action-btn {
        background: none;
        border: none;
        color: var(--light-text);
        cursor: pointer;
        transition: all 0.3s ease;
        padding: 0.5rem;
        border-radius: 50%;
      }

      .task-action-btn:hover {
        background: rgba(74, 144, 226, 0.1);
        color: var(--primary-color);
      }

      .add-task-btn {
        background: linear-gradient(
          45deg,
          var(--primary-color),
          var(--accent-color)
        );
        color: white;
        border: none;
        border-radius: 10px;
        padding: 0.8rem 1.5rem;
        font-weight: 600;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .add-task-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
      }

      .task-filter {
        display: flex;
        gap: 0.5rem;
        margin-bottom: 1rem;
      }

      .filter-btn {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 20px;
        background: rgba(255, 255, 255, 0.1);
        color: var(--text-color);
        font-weight: 500;
        transition: all 0.3s ease;
      }

      .filter-btn:hover,
      .filter-btn.active {
        background: var(--primary-color);
        color: white;
      }

      .task-priority {
        padding: 0.25rem 0.5rem;
        border-radius: 15px;
        font-size: 0.8rem;
        font-weight: 500;
        margin-left: 1rem;
      }

      .priority-high {
        background: rgba(255, 59, 48, 0.1);
        color: #ff3b30;
      }

      .priority-medium {
        background: rgba(255, 149, 0, 0.1);
        color: #ff9500;
      }

      .priority-low {
        background: rgba(52, 199, 89, 0.1);
        color: #34c759;
      }

      @keyframes slideIn {
        from {
          transform: translateY(20px);
          opacity: 0;
        }
        to {
          transform: translateY(0);
          opacity: 1;
        }
      }

      .slide-in {
        animation: slideIn 0.5s ease forwards;
      }

      .modal-content {
        background: rgba(255, 255, 255, 0.98);
        border-radius: 15px;
        border: none;
      }

      .modal-header {
        border-bottom: 2px solid rgba(74, 144, 226, 0.1);
      }

      .modal-title {
        color: var(--primary-color);
        font-weight: 600;
      }

      .form-control {
        border-radius: 10px;
        border: 2px solid rgba(74, 144, 226, 0.1);
        padding: 0.8rem;
      }

      .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: none;
      }

      .form-select {
        border: 2px solid rgba(74, 144, 226, 0.2);
        border-radius: 10px;
        padding: 0.8rem 1rem;
        transition: all 0.3s ease;
      }

      .form-select:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
      }

      .btn-primary {
        background: var(--primary-color);
        border: none;
      }

      .btn-primary:hover {
        background: var(--accent-color);
      }
    </style>
  </head>
  <body>
    <div id="particles-js" class="particles"></div>

    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container">
        <a class="navbar-brand" href="dashboard.jsp">
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
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <a class="nav-link" href="dashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link active" href="tasks.jsp">
                <i class="fas fa-tasks"></i> Tasks
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="progress.jsp">
                <i class="fas fa-chart-line"></i> Progress
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="settings.jsp">
                <i class="fas fa-cog"></i> Settings
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="logout">
                <i class="fas fa-sign-out-alt"></i> Logout
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container main-content">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-white">My Tasks</h2>
        <button
          class="btn btn-add-task"
          data-bs-toggle="modal"
          data-bs-target="#taskModal"
        >
          <i class="fas fa-plus"></i> Add New Task
        </button>
      </div>

      <div class="card">
        <div class="card-body p-0">
          <div class="task-filters mb-3">
            <div class="btn-group">
              <button class="btn btn-outline-primary active" data-filter="all">
                All
              </button>
              <button class="btn btn-outline-primary" data-filter="active">
                Active
              </button>
              <button class="btn btn-outline-primary" data-filter="completed">
                Completed
              </button>
            </div>
          </div>
          <div class="list-group list-group-flush" id="taskList">
            <!-- Tasks will be populated by JavaScript -->
          </div>
        </div>
      </div>
    </div>

    <!-- Task Modal -->
    <div class="modal fade" id="taskModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add/Edit Task</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <form id="taskForm">
              <input type="hidden" id="taskId" />
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
                <label for="taskDueDate" class="form-label">Due Date</label>
                <input type="date" class="form-control" id="taskDueDate" />
              </div>
              <div class="mb-3">
                <label for="taskPriority" class="form-label">Priority</label>
                <select class="form-control" id="taskPriority">
                  <option value="low">Low</option>
                  <option value="medium">Medium</option>
                  <option value="high">High</option>
                </select>
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
            <button type="button" class="btn btn-primary" onclick="saveTask()">
              Save Task
            </button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
    <script>
      // Initialize particles.js
      particlesJS("particles-js", {
        particles: {
          number: { value: 80, density: { enable: true, value_area: 800 } },
          color: { value: "#ffffff" },
          shape: { type: "circle" },
          opacity: { value: 0.5, random: false },
          size: { value: 3, random: true },
          line_linked: {
            enable: true,
            distance: 150,
            color: "#ffffff",
            opacity: 0.4,
            width: 1,
          },
          move: {
            enable: true,
            speed: 2,
            direction: "none",
            random: false,
            straight: false,
            out_mode: "out",
            bounce: false,
          },
        },
        interactivity: {
          detect_on: "canvas",
          events: {
            onhover: { enable: true, mode: "repulse" },
            onclick: { enable: true, mode: "push" },
            resize: true,
          },
        },
        retina_detect: true,
      });

      // Initialize task modal
      const taskModal = new bootstrap.Modal(
        document.getElementById("taskModal")
      );

      // Show task modal
      function showTaskModal(task = null) {
        document.getElementById("taskId").value = task ? task.id : "";
        document.getElementById("taskTitle").value = task ? task.title : "";
        document.getElementById("taskDescription").value = task
          ? task.description
          : "";
        document.getElementById("taskDueDate").value = task ? task.dueDate : "";
        document.getElementById("taskPriority").value = task
          ? task.priority
          : "medium";
        taskModal.show();
      }

      // Save task
      function saveTask() {
        const taskData = {
          id: document.getElementById("taskId").value,
          title: document.getElementById("taskTitle").value,
          description: document.getElementById("taskDescription").value,
          dueDate: document.getElementById("taskDueDate").value,
          priority: document.getElementById("taskPriority").value,
        };

        // Here you would typically make an AJAX call to save the task
        console.log("Saving task:", taskData);
        taskModal.hide();
        loadTasks(); // Reload tasks after saving
      }

      // Load tasks
      function loadTasks() {
        // Here you would typically make an AJAX call to fetch tasks
        // For now, we'll use dummy data
        const dummyTasks = [
          {
            id: 1,
            title: "Complete project proposal",
            description: "Write and submit the project proposal",
            dueDate: "2024-03-20",
            priority: "high",
            completed: false,
          },
          {
            id: 2,
            title: "Review code changes",
            description: "Review and approve pending PRs",
            dueDate: "2024-03-21",
            priority: "medium",
            completed: true,
          },
          {
            id: 3,
            title: "Update documentation",
            description: "Update API documentation",
            dueDate: "2024-03-22",
            priority: "low",
            completed: false,
          },
        ];

        const taskList = document.getElementById("taskList");
        taskList.innerHTML = dummyTasks
          .map(
            (task) => `
          <div class="task-item d-flex align-items-center">
            <input type="checkbox" class="task-checkbox" ${
              task.completed ? "checked" : ""
            }
                   onchange="toggleTaskStatus(${task.id}, this.checked)">
            <div class="flex-grow-1">
              <h6 class="mb-0">${task.title}</h6>
              <small class="text-muted">${task.description}</small>
              <div class="mt-1">
                <span class="badge bg-${
                  task.priority == "high"
                    ? "danger"
                    : task.priority == "medium"
                    ? "warning"
                    : "success"
                }">${task.priority}</span>
                <small class="text-muted ms-2">Due: ${task.dueDate}</small>
              </div>
            </div>
            <div class="ms-3">
              <button class="btn btn-sm btn-outline-primary me-2" onclick="editTask(${
                task.id
              })">
                <i class="fas fa-edit"></i>
              </button>
              <button class="btn btn-sm btn-outline-danger" onclick="deleteTask(${
                task.id
              })">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </div>
        `
          )
          .join("");
      }

      function getPriorityColor(priority) {
        return priority === "high"
          ? "danger"
          : priority === "medium"
          ? "warning"
          : "success";
      }

      function toggleTaskStatus(id, completed) {
        // Here you would typically make an AJAX call to update the task status
        console.log(
          `Task ${id} marked as ${completed ? "completed" : "incomplete"}`
        );
      }

      function editTask(id) {
        // Here you would typically fetch the task details from the server
        const task = {
          id: id,
          title: "Sample Task",
          description: "Sample Description",
          dueDate: "2024-03-20",
          priority: "medium",
        };
        showTaskModal(task);
      }

      function deleteTask(id) {
        if (confirm("Are you sure you want to delete this task?")) {
          // Here you would typically make an AJAX call to delete the task
          console.log(`Deleting task ${id}`);
          loadTasks(); // Reload tasks after deletion
        }
      }

      // Load tasks when the page loads
      document.addEventListener("DOMContentLoaded", loadTasks);
    </script>
  </body>
</html>
