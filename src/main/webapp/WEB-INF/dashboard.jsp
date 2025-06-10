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
      body {
        background-color: #f8f9fa;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }
      .navbar {
        background-color: white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      .dashboard-container {
        padding: 20px;
      }
      .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
      }
      .card-header {
        background-color: white;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        font-weight: 600;
      }
      .stat-card {
        text-align: center;
        padding: 20px;
      }
      .stat-icon {
        font-size: 2rem;
        margin-bottom: 10px;
        color: #0d6efd;
      }
      .stat-value {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 5px;
      }
      .stat-label {
        color: #6c757d;
      }
      .demo-banner {
        background-color: #fff3cd;
        color: #856404;
        padding: 10px;
        text-align: center;
        margin-bottom: 20px;
        border-radius: 5px;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container">
        <a
          class="navbar-brand"
          href="${pageContext.request.contextPath}/dashboard"
        >
          <i class="fas fa-brain"></i> FocusFriend
        </a>
        <div class="navbar-nav ms-auto">
          <% if ((Boolean)request.getAttribute("isLoggedIn")) { %>
          <a class="nav-link" href="${pageContext.request.contextPath}/tasks"
            >Tasks</a
          >
          <a class="nav-link" href="${pageContext.request.contextPath}/progress"
            >Progress</a
          >
          <a class="nav-link" href="${pageContext.request.contextPath}/settings"
            >Settings</a
          >
          <a class="nav-link" href="${pageContext.request.contextPath}/logout"
            >Logout</a
          >
          <% } else { %>
          <a class="nav-link" href="${pageContext.request.contextPath}/auth"
            >Login</a
          >
          <a
            class="nav-link"
            href="${pageContext.request.contextPath}/auth/register"
            >Register</a
          >
          <% } %>
        </div>
      </div>
    </nav>

    <div class="container dashboard-container">
      <% if (!(Boolean)request.getAttribute("isLoggedIn")) { %>
      <div class="demo-banner">
        <i class="fas fa-info-circle"></i> You are viewing the demo dashboard.
        <a href="${pageContext.request.contextPath}/auth" class="alert-link"
          >Login</a
        >
        to access all features.
      </div>
      <% } %>

      <div class="row">
        <div class="col-md-4">
          <div class="card stat-card">
            <i class="fas fa-clock stat-icon"></i>
            <div class="stat-value" id="totalFocusTime">0</div>
            <div class="stat-label">Total Focus Time (min)</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card stat-card">
            <i class="fas fa-check-circle stat-icon"></i>
            <div class="stat-value" id="completedSessions">0</div>
            <div class="stat-label">Completed Sessions</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card stat-card">
            <i class="fas fa-chart-line stat-icon"></i>
            <div class="stat-value" id="averageSessionLength">0</div>
            <div class="stat-label">Avg. Session Length (min)</div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <i class="fas fa-tasks"></i> Recent Tasks
            </div>
            <div class="card-body">
              <div id="recentTasks">
                <% if (!(Boolean)request.getAttribute("isLoggedIn")) { %>
                <p class="text-muted text-center">Login to view your tasks</p>
                <% } %>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <i class="fas fa-history"></i> Recent Sessions
            </div>
            <div class="card-body">
              <div id="recentSessions">
                <% if (!(Boolean)request.getAttribute("isLoggedIn")) { %>
                <p class="text-muted text-center">
                  Login to view your sessions
                </p>
                <% } %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Fetch dashboard data
      fetch("${pageContext.request.contextPath}/dashboard", {
        headers: {
          Accept: "application/json",
        },
      })
        .then((response) => response.json())
        .then((data) => {
          document.getElementById("totalFocusTime").textContent =
            data.totalFocusTime;
          document.getElementById("completedSessions").textContent =
            data.completedSessions;
          document.getElementById("averageSessionLength").textContent =
            Math.round(data.averageSessionLength * 10) / 10;
        })
        .catch((error) =>
          console.error("Error fetching dashboard data:", error)
        );
    </script>
  </body>
</html>
