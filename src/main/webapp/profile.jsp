<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
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
      }

      .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
      }

      .profile-header {
        text-align: center;
        padding: 2rem;
        background: linear-gradient(
          45deg,
          var(--primary-color),
          var(--accent-color)
        );
        color: white;
      }

      .profile-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        border: 4px solid white;
        margin-bottom: 1rem;
        object-fit: cover;
      }

      .profile-name {
        font-size: 1.8rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
      }

      .profile-email {
        color: rgba(255, 255, 255, 0.9);
        font-size: 1.1rem;
      }

      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1rem;
        padding: 1.5rem;
      }

      .stat-card {
        text-align: center;
        padding: 1rem;
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

      .achievement-section {
        padding: 1.5rem;
      }

      .achievement-title {
        color: var(--text-color);
        font-weight: 600;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .achievement-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 1rem;
      }

      .achievement-card {
        text-align: center;
        padding: 1rem;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
        transition: all 0.3s ease;
      }

      .achievement-card:hover {
        transform: translateY(-3px);
        background: rgba(255, 255, 255, 0.2);
      }

      .achievement-icon {
        font-size: 2rem;
        color: var(--primary-color);
        margin-bottom: 0.5rem;
      }

      .achievement-name {
        color: var(--text-color);
        font-weight: 500;
        margin-bottom: 0.25rem;
      }

      .achievement-desc {
        color: var(--light-text);
        font-size: 0.8rem;
      }

      .edit-profile-btn {
        background: white;
        color: var(--primary-color);
        border: none;
        border-radius: 20px;
        padding: 0.5rem 1.5rem;
        font-weight: 600;
        transition: all 0.3s ease;
        margin-top: 1rem;
      }

      .edit-profile-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
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
              <a class="nav-link" href="#">
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
      <div class="row">
        <div class="col-md-8 mx-auto">
          <div class="card slide-in">
            <div class="profile-header">
              <img
                src="https://via.placeholder.com/120"
                alt="Profile Avatar"
                class="profile-avatar"
              />
              <h2 class="profile-name">John Doe</h2>
              <p class="profile-email">john.doe@example.com</p>
              <button class="edit-profile-btn">
                <i class="fas fa-edit"></i> Edit Profile
              </button>
            </div>

            <div class="stats-grid">
              <div class="stat-card">
                <div class="stat-value">127</div>
                <div class="stat-label">Focus Sessions</div>
              </div>
              <div class="stat-card">
                <div class="stat-value">42h</div>
                <div class="stat-label">Total Focus Time</div>
              </div>
              <div class="stat-card">
                <div class="stat-value">89%</div>
                <div class="stat-label">Task Completion</div>
              </div>
              <div class="stat-card">
                <div class="stat-value">15</div>
                <div class="stat-label">Achievements</div>
              </div>
            </div>

            <div class="achievement-section">
              <h5 class="achievement-title">
                <i class="fas fa-trophy"></i> Recent Achievements
              </h5>
              <div class="achievement-grid">
                <div class="achievement-card">
                  <div class="achievement-icon">
                    <i class="fas fa-fire"></i>
                  </div>
                  <div class="achievement-name">Focus Master</div>
                  <div class="achievement-desc">
                    Completed 100 focus sessions
                  </div>
                </div>
                <div class="achievement-card">
                  <div class="achievement-icon">
                    <i class="fas fa-clock"></i>
                  </div>
                  <div class="achievement-name">Time Warrior</div>
                  <div class="achievement-desc">
                    Accumulated 40 hours of focus time
                  </div>
                </div>
                <div class="achievement-card">
                  <div class="achievement-icon">
                    <i class="fas fa-check-circle"></i>
                  </div>
                  <div class="achievement-name">Task Master</div>
                  <div class="achievement-desc">
                    Completed 50 tasks in a week
                  </div>
                </div>
                <div class="achievement-card">
                  <div class="achievement-icon">
                    <i class="fas fa-star"></i>
                  </div>
                  <div class="achievement-name">Consistency King</div>
                  <div class="achievement-desc">
                    7 days streak of focus sessions
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
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

      // Edit profile button functionality
      document
        .querySelector(".edit-profile-btn")
        .addEventListener("click", function () {
          // Add your edit profile logic here
          alert("Edit profile functionality coming soon!");
        });
    </script>
  </body>
</html>
