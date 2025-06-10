<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${param.title} - FocusFriend</title>
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
      }
      body::before {
        content: "";
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path d="M50 0 L100 50 L50 100 L0 50 Z" fill="none" stroke="rgba(0,0,0,0.1)" stroke-width="2"/><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(0,0,0,0.1)" stroke-width="2"/><path d="M50 10 L90 50 L50 90 L10 50 Z" fill="none" stroke="rgba(0,0,0,0.1)" stroke-width="2"/></svg>');
        background-repeat: repeat;
        background-size: 200px 200px;
        opacity: 0.1;
        z-index: -1;
        pointer-events: none;
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
                class="nav-link ${param.active == 'dashboard' ? 'active' : ''}"
                href="${pageContext.request.contextPath}/dashboard"
              >
                <i class="fas fa-home"></i> Dashboard
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link ${param.active == 'tasks' ? 'active' : ''}"
                href="${pageContext.request.contextPath}/tasks"
              >
                <i class="fas fa-tasks"></i> Tasks
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link ${param.active == 'progress' ? 'active' : ''}"
                href="${pageContext.request.contextPath}/progress"
              >
                <i class="fas fa-chart-line"></i> Progress
              </a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link ${param.active == 'settings' ? 'active' : ''}"
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
  </body>
</html>
