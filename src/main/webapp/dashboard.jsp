<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
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
      }
      .dashboard-card {
        background: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      .timer-display {
        font-size: 3rem;
        font-weight: bold;
        color: #000dff;
      }
      .progress {
        height: 10px;
      }
      .goal-card {
        border-left: 4px solid #000dff;
      }
      .session-card {
        border-left: 4px solid #28a745;
      }
      .btn-focus {
        background: #000dff;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        transition: background 0.3s ease;
      }
      .btn-focus:hover {
        background: #0009cc;
        color: white;
      }
      .stats-value {
        font-size: 2rem;
        font-weight: bold;
        color: #000dff;
      }
      .stats-label {
        color: #6c757d;
        font-size: 0.9rem;
      }
      .streak-badge {
        background: #ffd700;
        color: #000;
        padding: 5px 10px;
        border-radius: 15px;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
        <a class="navbar-brand" href="index.jsp">FocusFriend</a>
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
              <a class="nav-link active" href="dashboard.jsp">Dashboard</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#" id="newGoalBtn">New Goal</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#" id="logoutBtn">Logout</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container mt-4">
      <div class="row">
        <!-- Timer Section -->
        <div class="col-md-4">
          <div class="dashboard-card">
            <h3>Focus Timer</h3>
            <div class="text-center my-4">
              <div class="timer-display" id="timer">00:00:00</div>
              <div class="mt-3">
                <button class="btn btn-focus" id="startTimer">
                  Start Session
                </button>
                <button class="btn btn-danger ms-2" id="stopTimer" disabled>
                  Stop
                </button>
              </div>
            </div>
            <div class="form-group">
              <label for="sessionDescription">What are you working on?</label>
              <input
                type="text"
                class="form-control"
                id="sessionDescription"
                placeholder="Enter session description"
              />
            </div>
          </div>
        </div>

        <!-- Stats Section -->
        <div class="col-md-8">
          <div class="row">
            <div class="col-md-4">
              <div class="dashboard-card text-center">
                <div class="stats-value" id="todayMinutes">0</div>
                <div class="stats-label">Minutes Today</div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="dashboard-card text-center">
                <div class="stats-value" id="streak">0</div>
                <div class="stats-label">Day Streak</div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="dashboard-card text-center">
                <div class="stats-value" id="productivity">0%</div>
                <div class="stats-label">Productivity</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <!-- Active Goals -->
        <div class="col-md-6">
          <div class="dashboard-card">
            <h3>Active Goals</h3>
            <div id="goalsList">
              <!-- Goals will be dynamically added here -->
            </div>
          </div>
        </div>

        <!-- Recent Sessions -->
        <div class="col-md-6">
          <div class="dashboard-card">
            <h3>Recent Sessions</h3>
            <div id="sessionsList">
              <!-- Sessions will be dynamically added here -->
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-md-8">
          <!-- AI Assistant Section -->
          <div class="card mb-4">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-robot"></i> AI Assistant
              </h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <button
                  class="btn btn-primary w-100 mb-2"
                  onclick="analyzeGoals()"
                >
                  <i class="fas fa-chart-line"></i> Analyze Goals
                </button>
                <button
                  class="btn btn-info w-100 mb-2"
                  onclick="getProductivityTips()"
                >
                  <i class="fas fa-lightbulb"></i> Get Productivity Tips
                </button>
              </div>
              <div id="aiResponse" class="alert alert-info d-none">
                <div
                  class="spinner-border spinner-border-sm me-2"
                  role="status"
                >
                  <span class="visually-hidden">Loading...</span>
                </div>
                <span id="aiResponseText"></span>
              </div>
            </div>
          </div>

          <!-- Chat Section -->
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-comments"></i> Chat with AI
              </h5>
            </div>
            <div class="card-body">
              <div
                id="chatMessages"
                class="mb-3"
                style="height: 300px; overflow-y: auto"
              >
                <!-- Chat messages will be added here -->
              </div>
              <div class="input-group">
                <input
                  type="text"
                  id="chatInput"
                  class="form-control"
                  placeholder="Type your message..."
                />
                <button class="btn btn-primary" onclick="sendChatMessage()">
                  <i class="fas fa-paper-plane"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- New Goal Modal -->
    <div class="modal fade" id="newGoalModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Create New Goal</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <form id="newGoalForm">
              <div class="mb-3">
                <label for="goalTitle" class="form-label">Title</label>
                <input
                  type="text"
                  class="form-control"
                  id="goalTitle"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="goalDescription" class="form-label"
                  >Description</label
                >
                <textarea
                  class="form-control"
                  id="goalDescription"
                  rows="3"
                ></textarea>
              </div>
              <div class="mb-3">
                <label for="targetDate" class="form-label">Target Date</label>
                <input
                  type="date"
                  class="form-control"
                  id="targetDate"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="targetMinutes" class="form-label"
                  >Target Minutes</label
                >
                <input
                  type="number"
                  class="form-control"
                  id="targetMinutes"
                  required
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
            <button type="button" class="btn btn-primary" id="saveGoal">
              Save Goal
            </button>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Add session check at the start
      document.addEventListener("DOMContentLoaded", function () {
        // Check if user is logged in
        fetch("${pageContext.request.contextPath}/auth/check")
          .then((response) => response.json())
          .then((data) => {
            if (!data.loggedIn) {
              window.location.href =
                "${pageContext.request.contextPath}/login.jsp";
            }
          })
          .catch((error) => {
            console.error("Error checking session:", error);
            window.location.href =
              "${pageContext.request.contextPath}/login.jsp";
          });
      });

      // Timer functionality
      let timerInterval;
      let startTime;
      let isRunning = false;
      let currentSessionId = null;

      document
        .getElementById("startTimer")
        .addEventListener("click", function () {
          if (!isRunning) {
            const description =
              document.getElementById("sessionDescription").value;
            if (!description) {
              alert("Please enter a session description");
              return;
            }

            fetch("/session/start", {
              method: "POST",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: "userId=1&description=" + encodeURIComponent(description),
            })
              .then((response) => response.json())
              .then((data) => {
                currentSessionId = data.sessionId;
                startTime = new Date();
                isRunning = true;
                this.disabled = true;
                document.getElementById("stopTimer").disabled = false;
                timerInterval = setInterval(updateTimer, 1000);
              })
              .catch((error) => console.error("Error:", error));
          }
        });

      document
        .getElementById("stopTimer")
        .addEventListener("click", function () {
          if (isRunning) {
            clearInterval(timerInterval);
            isRunning = false;
            this.disabled = true;
            document.getElementById("startTimer").disabled = false;

            fetch("/session/end", {
              method: "POST",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: "userId=1&sessionId=" + currentSessionId,
            })
              .then((response) => response.json())
              .then((data) => {
                updateDashboard();
                document.getElementById("sessionDescription").value = "";
              })
              .catch((error) => console.error("Error:", error));
          }
        });

      function updateTimer() {
        const now = new Date();
        const diff = now - startTime;
        const hours = Math.floor(diff / 3600000);
        const minutes = Math.floor((diff % 3600000) / 60000);
        const seconds = Math.floor((diff % 60000) / 1000);
        document.getElementById("timer").textContent =
          hours.toString().padStart(2, "0") +
          ":" +
          minutes.toString().padStart(2, "0") +
          ":" +
          seconds.toString().padStart(2, "0");
      }

      // Goal Modal
      const newGoalModal = new bootstrap.Modal(
        document.getElementById("newGoalModal")
      );
      document
        .getElementById("newGoalBtn")
        .addEventListener("click", function () {
          newGoalModal.show();
        });

      document
        .getElementById("saveGoal")
        .addEventListener("click", function () {
          const goal = {
            title: document.getElementById("goalTitle").value,
            description: document.getElementById("goalDescription").value,
            targetDate: document.getElementById("targetDate").value,
            targetMinutes: document.getElementById("targetMinutes").value,
          };

          fetch("/goal/create", {
            method: "POST",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body:
              "userId=1&title=" +
              encodeURIComponent(goal.title) +
              "&description=" +
              encodeURIComponent(goal.description) +
              "&targetDate=" +
              goal.targetDate +
              "&targetMinutes=" +
              goal.targetMinutes,
          })
            .then((response) => response.json())
            .then((data) => {
              updateDashboard();
              newGoalModal.hide();
              document.getElementById("newGoalForm").reset();
            })
            .catch((error) => console.error("Error:", error));
        });

      function updateDashboard() {
        const today = new Date().toISOString().split("T")[0];

        // Update stats
        fetch("/dashboard/stats?userId=1&date=" + today)
          .then((response) => response.json())
          .then((data) => {
            document.getElementById("todayMinutes").textContent =
              data.totalMinutes;
            document.getElementById("streak").textContent = data.streak;
            document.getElementById("productivity").textContent =
              data.productivityPercentage.toFixed(1) + "%";
          })
          .catch((error) => console.error("Error:", error));

        // Update recent activity
        fetch("/dashboard/recent?userId=1")
          .then((response) => response.json())
          .then((data) => {
            updateGoalsList(data.activeGoals);
            updateSessionsList(data.recentSessions);
          })
          .catch((error) => console.error("Error:", error));
      }

      function updateGoalsList(goals) {
        const goalsList = document.getElementById("goalsList");
        if (goals.length === 0) {
          goalsList.innerHTML =
            '<p class="text-muted">No active goals. Create one to get started!</p>';
          return;
        }

        goalsList.innerHTML = goals
          .map(
            (goal) =>
              '<div class="goal-card p-3 mb-3">' +
              "<h5>" +
              goal.title +
              "</h5>" +
              '<p class="text-muted">' +
              goal.description +
              "</p>" +
              '<div class="progress mb-2">' +
              '<div class="progress-bar" role="progressbar" ' +
              'style="width: ' +
              goal.progressPercentage +
              '%" ' +
              'aria-valuenow="' +
              goal.progressPercentage +
              '" ' +
              'aria-valuemin="0" ' +
              'aria-valuemax="100">' +
              "</div>" +
              "</div>" +
              '<div class="d-flex justify-content-between align-items-center">' +
              "<small>" +
              goal.completedMinutes +
              "/" +
              goal.targetMinutes +
              " minutes</small>" +
              '<small class="text-muted">Target: ' +
              goal.targetDate +
              "</small>" +
              "</div>" +
              "</div>"
          )
          .join("");
      }

      function updateSessionsList(sessions) {
        const sessionsList = document.getElementById("sessionsList");
        if (sessions.length === 0) {
          sessionsList.innerHTML =
            '<p class="text-muted">No recent sessions. Start a focus session!</p>';
          return;
        }

        sessionsList.innerHTML = sessions
          .map(
            (session) =>
              '<div class="session-card p-3 mb-3">' +
              "<h5>" +
              session.description +
              "</h5>" +
              '<div class="d-flex justify-content-between align-items-center">' +
              '<p class="mb-0">Duration: ' +
              session.duration +
              " minutes</p>" +
              '<small class="text-muted">' +
              session.startTime +
              "</small>" +
              "</div>" +
              "</div>"
          )
          .join("");
      }

      // Initial dashboard update
      updateDashboard();

      // Update dashboard every minute
      setInterval(updateDashboard, 60000);

      // Update AI functions to handle errors better
      function analyzeGoals() {
        const aiResponse = document.getElementById("aiResponse");
        const aiResponseText = document.getElementById("aiResponseText");

        aiResponse.classList.remove("d-none");
        aiResponseText.textContent = "Analyzing your goals...";

        fetch("${pageContext.request.contextPath}/ai/analyze")
          .then((response) => {
            if (!response.ok) {
              throw new Error("Network response was not ok");
            }
            return response.json();
          })
          .then((data) => {
            if (data.error) {
              throw new Error(data.error);
            }
            aiResponseText.innerHTML = data.analysis.replace(/\n/g, "<br>");
          })
          .catch((error) => {
            aiResponseText.textContent =
              "Error analyzing goals: " + error.message;
          });
      }

      function getProductivityTips() {
        const aiResponse = document.getElementById("aiResponse");
        const aiResponseText = document.getElementById("aiResponseText");

        aiResponse.classList.remove("d-none");
        aiResponseText.textContent = "Getting productivity tips...";

        fetch("${pageContext.request.contextPath}/ai/tips")
          .then((response) => {
            if (!response.ok) {
              throw new Error("Network response was not ok");
            }
            return response.json();
          })
          .then((data) => {
            if (data.error) {
              throw new Error(data.error);
            }
            aiResponseText.innerHTML = data.tips.replace(/\n/g, "<br>");
          })
          .catch((error) => {
            aiResponseText.textContent = "Error getting tips: " + error.message;
          });
      }

      function sendChatMessage() {
        const chatInput = document.getElementById("chatInput");
        const chatMessages = document.getElementById("chatMessages");
        const message = chatInput.value.trim();

        if (message === "") return;

        // Add user message
        const userMessageDiv = document.createElement("div");
        userMessageDiv.className = "mb-2 text-end";
        userMessageDiv.innerHTML =
          '<span class="badge bg-primary p-2">' + message + "</span>";
        chatMessages.appendChild(userMessageDiv);

        // Add AI response placeholder
        const aiMessageDiv = document.createElement("div");
        aiMessageDiv.className = "mb-2";
        aiMessageDiv.innerHTML =
          '<span class="badge bg-secondary p-2"><div class="spinner-border spinner-border-sm me-2" role="status"><span class="visually-hidden">Loading...</span></div>Thinking...</span>';
        chatMessages.appendChild(aiMessageDiv);

        // Clear input
        chatInput.value = "";

        // Scroll to bottom
        chatMessages.scrollTop = chatMessages.scrollHeight;

        // Send message to server
        fetch("${pageContext.request.contextPath}/ai/chat", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: "message=" + encodeURIComponent(message),
        })
          .then((response) => {
            if (!response.ok) {
              throw new Error("Network response was not ok");
            }
            return response.json();
          })
          .then((data) => {
            if (data.error) {
              throw new Error(data.error);
            }
            aiMessageDiv.innerHTML =
              '<span class="badge bg-secondary p-2">' +
              data.response.replace(/\n/g, "<br>") +
              "</span>";
            chatMessages.scrollTop = chatMessages.scrollHeight;
          })
          .catch((error) => {
            aiMessageDiv.innerHTML =
              '<span class="badge bg-danger p-2">Error: ' +
              error.message +
              "</span>";
          });
      }

      // Add logout functionality
      document
        .getElementById("logoutBtn")
        .addEventListener("click", function (e) {
          e.preventDefault();
          fetch("${pageContext.request.contextPath}/auth/logout", {
            method: "POST",
          })
            .then(() => {
              window.location.href =
                "${pageContext.request.contextPath}/login.jsp";
            })
            .catch((error) => {
              console.error("Error logging out:", error);
            });
        });

      // Handle Enter key in chat input
      document
        .getElementById("chatInput")
        .addEventListener("keypress", function (e) {
          if (e.key === "Enter") {
            sendChatMessage();
          }
        });
    </script>
  </body>
</html>
