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

      .chart-container {
        position: relative;
        height: 300px;
        padding: 1.5rem;
      }

      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        padding: 1.5rem;
      }

      .stat-card {
        text-align: center;
        padding: 1.5rem;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        transition: all 0.3s ease;
      }

      .stat-card:hover {
        transform: translateY(-3px);
        background: rgba(255, 255, 255, 0.2);
      }

      .stat-value {
        font-size: 2rem;
        font-weight: 600;
        color: var(--primary-color);
        margin-bottom: 0.5rem;
      }

      .stat-label {
        color: var(--text-color);
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      .time-filter {
        display: flex;
        gap: 0.5rem;
        margin-bottom: 1rem;
      }

      .time-filter-btn {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 20px;
        background: rgba(255, 255, 255, 0.1);
        color: var(--text-color);
        font-weight: 500;
        transition: all 0.3s ease;
      }

      .time-filter-btn:hover,
      .time-filter-btn.active {
        background: var(--primary-color);
        color: white;
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

      .progress-item {
        padding: 1rem;
        border-bottom: 1px solid rgba(74, 144, 226, 0.1);
      }

      .progress-item:last-child {
        border-bottom: none;
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
              <a class="nav-link" href="#">
                <i class="fas fa-tasks"></i> Tasks
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link active" href="progress.jsp">
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
      <h2 class="text-white mb-4">Your Progress</h2>

      <div class="row mb-4">
        <div class="col-md-4">
          <div class="card stat-card">
            <i class="fas fa-clock"></i>
            <h3 id="totalFocusTime">0h</h3>
            <p>Total Focus Time</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card stat-card">
            <i class="fas fa-check-circle"></i>
            <h3 id="completedSessions">0</h3>
            <p>Completed Sessions</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card stat-card">
            <i class="fas fa-chart-line"></i>
            <h3 id="averageSession">0m</h3>
            <p>Average Session Length</p>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-md-8">
          <div class="card mb-4">
            <div class="card-body">
              <h5 class="card-title">Focus Time Trend</h5>
              <div class="chart-container">
                <canvas id="focusTimeChart"></canvas>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Recent Sessions</h5>
              <div id="recentSessions">
                <!-- Sessions will be populated by JavaScript -->
              </div>
            </div>
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

      // Initialize charts
      const focusTimeChart = new Chart(
        document.getElementById("focusTimeChart"),
        {
          type: "line",
          data: {
            labels: [],
            datasets: [
              {
                label: "Focus Time (minutes)",
                data: [],
                borderColor: "#4a90e2",
                tension: 0.4,
                fill: true,
                backgroundColor: "rgba(74, 144, 226, 0.1)",
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false,
              },
            },
            scales: {
              y: {
                beginAtZero: true,
                grid: {
                  color: "rgba(0, 0, 0, 0.1)",
                },
              },
              x: {
                grid: {
                  display: false,
                },
              },
            },
          },
        }
      );

      // Fetch progress data
      function fetchProgressData() {
        fetch("progress", {
          headers: {
            Accept: "application/json",
          },
        })
          .then((response) => response.json())
          .then((data) => {
            // Update statistics
            document.getElementById("totalFocusTime").textContent = formatTime(
              data.totalFocusTime
            );
            document.getElementById("completedSessions").textContent =
              data.completedSessions;
            document.getElementById("averageSession").textContent = formatTime(
              data.averageSessionLength
            );

            // Update chart
            focusTimeChart.data.labels = data.focusTimeTrend.map(
              (item) => item.date
            );
            focusTimeChart.data.datasets[0].data = data.focusTimeTrend.map(
              (item) => item.minutes
            );
            focusTimeChart.update();

            // Update recent sessions
            const recentSessionsHtml = data.recentSessions
              .map(
                (session) => `
            <div class="progress-item">
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <h6 class="mb-0">${session.taskTitle}</h6>
                  <small class="text-muted">${formatDate(session.date)}</small>
                </div>
                <span class="badge bg-primary">${formatTime(
                  session.duration
                )}</span>
              </div>
            </div>
          `
              )
              .join("");
            document.getElementById("recentSessions").innerHTML =
              recentSessionsHtml;
          })
          .catch((error) =>
            console.error("Error fetching progress data:", error)
          );
      }

      function formatTime(minutes) {
        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;
        return hours > 0 ? `${hours}h ${mins}m` : `${mins}m`;
      }

      function formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit",
        });
      }

      // Initial fetch
      fetchProgressData();
    </script>
  </body>
</html>
