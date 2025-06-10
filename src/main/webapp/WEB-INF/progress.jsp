<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Progress - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
      rel="stylesheet"
    />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
      .progress-card {
        background: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        position: relative;
        z-index: 1;
      }
      .stat-card {
        background: white;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 10px;
        text-align: center;
      }
      .stat-value {
        font-size: 24px;
        font-weight: bold;
        color: #0d6efd;
      }
      .stat-label {
        color: #6c757d;
        font-size: 14px;
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
    <div class="container mt-5">
      <div class="row">
        <div class="col-md-4">
          <div class="stat-card">
            <div class="stat-value" id="totalFocusTime">0h</div>
            <div class="stat-label">Total Focus Time</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="stat-card">
            <div class="stat-value" id="completedSessions">0</div>
            <div class="stat-label">Completed Sessions</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="stat-card">
            <div class="stat-value" id="averageSessionLength">0m</div>
            <div class="stat-label">Average Session Length</div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-md-6">
          <div class="progress-card">
            <h4>Focus Time by Day</h4>
            <canvas id="dailyChart"></canvas>
          </div>
        </div>
        <div class="col-md-6">
          <div class="progress-card">
            <h4>Session Types</h4>
            <canvas id="sessionTypeChart"></canvas>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-12">
          <div class="progress-card">
            <h4>Recent Sessions</h4>
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Type</th>
                    <th>Duration</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody id="recentSessions">
                  <!-- Sessions will be loaded here -->
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Load progress data when page loads
      document.addEventListener("DOMContentLoaded", function () {
        loadProgressData();
      });

      // Load all progress data
      function loadProgressData() {
        fetch("${pageContext.request.contextPath}/progress/api/stats")
          .then((response) => response.json())
          .then((data) => {
            updateStats(data);
            createCharts(data);
            updateRecentSessions(data.recentSessions);
          })
          .catch((error) =>
            console.error("Error loading progress data:", error)
          );
      }

      // Update statistics
      function updateStats(data) {
        document.getElementById("totalFocusTime").textContent = formatDuration(
          data.totalFocusTime
        );
        document.getElementById("completedSessions").textContent =
          data.completedSessions;
        document.getElementById("averageSessionLength").textContent =
          formatDuration(data.averageSessionLength);
      }

      // Create charts
      function createCharts(data) {
        // Daily focus time chart
        new Chart(document.getElementById("dailyChart"), {
          type: "bar",
          data: {
            labels: data.dailyStats.map((stat) => stat.date),
            datasets: [
              {
                label: "Focus Time (minutes)",
                data: data.dailyStats.map((stat) => stat.duration),
                backgroundColor: "#0d6efd",
              },
            ],
          },
          options: {
            responsive: true,
            scales: {
              y: {
                beginAtZero: true,
              },
            },
          },
        });

        // Session types chart
        new Chart(document.getElementById("sessionTypeChart"), {
          type: "pie",
          data: {
            labels: data.sessionTypes.map((type) => type.name),
            datasets: [
              {
                data: data.sessionTypes.map((type) => type.count),
                backgroundColor: ["#0d6efd", "#198754", "#dc3545", "#ffc107"],
              },
            ],
          },
          options: {
            responsive: true,
          },
        });
      }

      // Update recent sessions table
      function updateRecentSessions(sessions) {
        const tbody = document.getElementById("recentSessions");
        tbody.innerHTML = "";

        sessions.forEach((session) => {
          const tr = document.createElement("tr");
          tr.innerHTML = `
                    <td>${formatDate(session.startTime)}</td>
                    <td>${session.type}</td>
                    <td>${formatDuration(session.duration)}</td>
                    <td><span class="badge bg-${
                      session.completed ? "success" : "warning"
                    }">
                        ${session.completed ? "Completed" : "In Progress"}
                    </span></td>
                `;
          tbody.appendChild(tr);
        });
      }

      // Helper functions
      function formatDuration(minutes) {
        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;
        return hours > 0 ? `${hours}h ${mins}m` : `${mins}m`;
      }

      function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString() + " " + date.toLocaleTimeString();
      }
    </script>
  </body>
</html>
