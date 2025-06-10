<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - FocusFriend</title>
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
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        overflow-x: hidden;
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
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 1rem 0;
      }
      .navbar-brand {
        color: var(--primary-color) !important;
        font-size: 1.5rem;
        font-weight: 600;
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
        transition: 0.3s;
        padding: 0.5rem 1rem;
        border-radius: 8px;
      }
      .nav-link:hover,
      .nav-link.active {
        background: rgba(74, 144, 226, 0.1);
        transform: translateY(-2px);
      }
      .main-content {
        padding: 2rem;
        margin-top: 1rem;
      }
      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
      }
      .stats-card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        transition: 0.3s;
        text-align: center;
        padding: 1.5rem;
      }
      .stats-card:hover {
        transform: translateY(-5px) scale(1.02);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
      }
      .stats-icon {
        font-size: 2.5rem;
        background: linear-gradient(
          45deg,
          var(--primary-color),
          var(--accent-color)
        );
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 1rem;
      }
      .stats-value {
        font-size: 2rem;
        font-weight: 700;
        color: var(--text-color);
      }
      .stats-label {
        color: var(--light-text);
        font-size: 1.1rem;
        font-weight: 500;
      }
      .card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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
      .task-list,
      .session-list {
        list-style: none;
        padding: 0;
        margin: 0;
      }
      .task-item,
      .session-item {
        padding: 1rem;
        border-bottom: 1px solid rgba(74, 144, 226, 0.1);
        display: flex;
        align-items: center;
        gap: 1rem;
      }
      .task-item:last-child,
      .session-item:last-child {
        border-bottom: none;
      }
      .task-checkbox {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        border: 2px solid var(--primary-color);
        cursor: pointer;
      }
      .task-checkbox:checked {
        background: var(--primary-color);
      }
      .task-text {
        flex-grow: 1;
        margin: 0;
        color: var(--text-color);
      }
      .task-actions,
      .session-actions {
        display: flex;
        gap: 0.5rem;
      }
      .btn-icon {
        background: none;
        border: none;
        color: var(--primary-color);
        padding: 0.5rem;
        border-radius: 5px;
        transition: 0.3s;
      }
      .btn-icon:hover {
        background: rgba(74, 144, 226, 0.1);
      }
      .focus-timer {
        font-size: 4rem;
        font-weight: 700;
        color: var(--text-color);
        margin: 1rem 0;
        font-family: "Courier New", monospace;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
      }
      .btn-timer {
        padding: 0.8rem 2rem;
        border-radius: 50px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
      }
      .btn-start {
        background: linear-gradient(45deg, #4caf50, #45a049);
        color: white;
        border: none;
      }
      .btn-pause {
        background: linear-gradient(45deg, #ffc107, #ffa000);
        color: white;
        border: none;
      }
      .btn-reset {
        background: linear-gradient(45deg, #f44336, #e53935);
        color: white;
        border: none;
      }
      .badge {
        transition: 0.3s;
      }
      .badge.bg-success {
        background-color: #28a745 !important;
      }
      .badge.bg-info {
        background-color: #17a2b8 !important;
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
              <a class="nav-link active" href="dashboard.jsp"
                ><i class="fas fa-home"></i> Dashboard</a
              >
            </li>
            <li class="nav-item">
              <a class="nav-link" href="tasks.jsp"
                ><i class="fas fa-tasks"></i> Tasks</a
              >
            </li>
            <li class="nav-item">
              <a class="nav-link" href="progress.jsp"
                ><i class="fas fa-chart-line"></i> Progress</a
              >
            </li>
            <li class="nav-item">
              <a class="nav-link" href="settings.jsp"
                ><i class="fas fa-cog"></i> Settings</a
              >
            </li>
            <li class="nav-item">
              <a class="nav-link" href="logout"
                ><i class="fas fa-sign-out-alt"></i> Logout</a
              >
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container main-content">
      <div class="stats-grid mb-4">
        <div class="stats-card">
          <i class="fas fa-clock stats-icon"></i>
          <div class="stats-value" id="totalFocusTime">120</div>
          <div class="stats-label">Total Focus Time (min)</div>
        </div>
        <div class="stats-card">
          <i class="fas fa-check-circle stats-icon"></i>
          <div class="stats-value" id="completedSessions">6</div>
          <div class="stats-label">Completed Sessions</div>
        </div>
        <div class="stats-card">
          <i class="fas fa-chart-line stats-icon"></i>
          <div class="stats-value" id="averageSessionLength">20</div>
          <div class="stats-label">Avg. Session Length (min)</div>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-4">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title">
                <i class="fas fa-tasks"></i> Recent Tasks
              </h5>
              <a href="tasks.jsp" class="btn btn-primary btn-sm">
                <i class="fas fa-plus"></i> Add Task
              </a>
            </div>
            <div class="card-body p-0">
              <ul class="task-list" id="recentTasks">
                <li class="task-item">
                  <input type="checkbox" class="task-checkbox" checked />
                  <span class="task-text">Read 10 pages of textbook</span>
                  <div class="task-actions">
                    <button class="btn-icon" type="button">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-icon" type="button">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </li>
                <li class="task-item">
                  <input type="checkbox" class="task-checkbox" />
                  <span class="task-text"
                    >Write project report introduction</span
                  >
                  <div class="task-actions">
                    <button class="btn-icon" type="button">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-icon" type="button">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </li>
                <li class="task-item">
                  <input type="checkbox" class="task-checkbox" checked />
                  <span class="task-text">Review math homework</span>
                  <div class="task-actions">
                    <button class="btn-icon" type="button">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-icon" type="button">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="col-md-6 mb-4">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title">
                <i class="fas fa-history"></i> Recent Sessions
              </h5>
              <a href="progress.jsp" class="btn btn-primary btn-sm"
                ><i class="fas fa-chart-bar"></i> View All</a
              >
            </div>
            <div class="card-body p-0">
              <ul class="session-list" id="recentSessions">
                <li class="session-item">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div>
                      <h6 class="mb-0">Focus Session</h6>
                      <small class="text-muted">25 minutes</small>
                    </div>
                    <span class="badge bg-success">Completed</span>
                  </div>
                </li>
                <li class="session-item">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div>
                      <h6 class="mb-0">Focus Session</h6>
                      <small class="text-muted">20 minutes</small>
                    </div>
                    <span class="badge bg-info">In Progress</span>
                  </div>
                </li>
                <li class="session-item">
                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <div>
                      <h6 class="mb-0">Focus Session</h6>
                      <small class="text-muted">15 minutes</small>
                    </div>
                    <span class="badge bg-success">Completed</span>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-md-12">
          <div class="card mb-4">
            <div class="card-body">
              <h5 class="card-title">Focus Timer</h5>
              <div class="text-center mb-4">
                <h1 id="timer" class="display-1">25:00</h1>
                <div class="btn-group mb-3">
                  <button
                    class="btn btn-outline-primary timer-btn active"
                    data-duration="25"
                    type="button"
                  >
                    25m
                  </button>
                  <button
                    class="btn btn-outline-primary timer-btn"
                    data-duration="45"
                    type="button"
                  >
                    45m
                  </button>
                  <button
                    class="btn btn-outline-primary timer-btn"
                    data-duration="60"
                    type="button"
                  >
                    60m
                  </button>
                </div>
                <div>
                  <button
                    id="startBtn"
                    class="btn btn-primary me-2"
                    type="button"
                  >
                    <i class="fas fa-play"></i> Start
                  </button>
                  <button
                    id="pauseBtn"
                    class="btn btn-warning me-2"
                    type="button"
                  >
                    <i class="fas fa-pause"></i> Pause
                  </button>
                  <button id="resetBtn" class="btn btn-danger" type="button">
                    <i class="fas fa-redo"></i> Reset
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
    <script>
      particlesJS("particles-js", {
        particles: {
          number: { value: 80, density: { enable: true, value_area: 800 } },
          color: { value: "#ffffff" },
          shape: { type: "circle" },
          opacity: { value: 0.5 },
          size: { value: 3, random: true },
          line_linked: {
            enable: true,
            distance: 150,
            color: "#fff",
            opacity: 0.4,
            width: 1,
          },
          move: { enable: true, speed: 2 },
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

      // Timer functionality
      let timerInterval = null;
      let timeLeft = 25 * 60;
      let isRunning = false;

      function updateTimerDisplay() {
        const min = Math.floor(timeLeft / 60)
          .toString()
          .padStart(2, "0");
        const sec = (timeLeft % 60).toString().padStart(2, "0");
        document.getElementById("timer").textContent = `${min}:${sec}`;
      }

      function setTimerDuration(duration, event) {
        document
          .querySelectorAll(".timer-btn")
          .forEach((btn) => btn.classList.remove("active"));
        if (event) event.target.classList.add("active");
        else
          document
            .querySelector(`.timer-btn[data-duration="${duration}"]`)
            .classList.add("active");
        pauseTimer();
        timeLeft = duration * 60;
        updateTimerDisplay();
      }

      function startTimer() {
        if (!isRunning) {
          isRunning = true;
          if (!timerInterval) {
            timerInterval = setInterval(() => {
              if (timeLeft > 0) {
                timeLeft--;
                updateTimerDisplay();
              } else {
                stopTimer();
              }
            }, 1000);
          }
        }
      }

      function pauseTimer() {
        if (isRunning) {
          clearInterval(timerInterval);
          timerInterval = null;
          isRunning = false;
        }
      }

      function resetTimer() {
        pauseTimer();
        const activeBtn = document.querySelector(".timer-btn.active");
        timeLeft = (activeBtn ? parseInt(activeBtn.dataset.duration) : 25) * 60;
        updateTimerDisplay();
      }

      function stopTimer() {
        pauseTimer();
      }

      document.getElementById("startBtn").addEventListener("click", startTimer);
      document.getElementById("pauseBtn").addEventListener("click", pauseTimer);
      document.getElementById("resetBtn").addEventListener("click", resetTimer);
      document.querySelectorAll(".timer-btn").forEach((btn) => {
        btn.addEventListener("click", (e) =>
          setTimerDuration(parseInt(e.target.dataset.duration), e)
        );
      });

      // Initial timer setup
      setTimerDuration(25);
    </script>
  </body>
</html>
