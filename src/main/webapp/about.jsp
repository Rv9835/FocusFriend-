<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About - FocusFriend</title>
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
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        position: relative;
        overflow-x: hidden;
      }

      body::before {
        content: "";
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url("https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80")
          center/cover;
        opacity: 0.1;
        z-index: -1;
      }

      .navbar {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .navbar-brand {
        color: #4a90e2 !important;
        font-weight: 600;
        font-size: 1.5rem;
      }

      .nav-link {
        color: #4a90e2 !important;
        font-weight: 500;
        transition: all 0.3s ease;
      }

      .nav-link:hover {
        transform: translateY(-2px);
      }

      .hero-section {
        padding: 100px 0;
        text-align: center;
        color: white;
      }

      .hero-title {
        font-size: 3.5rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
      }

      .hero-subtitle {
        font-size: 1.5rem;
        margin-bottom: 2rem;
        opacity: 0.9;
      }

      .btn-hero {
        padding: 15px 40px;
        font-size: 1.2rem;
        font-weight: 600;
        border-radius: 50px;
        margin: 0 10px;
        transition: all 0.3s ease;
      }

      .btn-primary {
        background: linear-gradient(45deg, #4a90e2, #5cb3ff);
        border: none;
      }

      .btn-outline-light {
        border: 2px solid white;
      }

      .btn-hero:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
      }

      .features-section {
        padding: 80px 0;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
      }

      .feature-card {
        text-align: center;
        padding: 30px;
        border-radius: 20px;
        background: white;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        height: 100%;
      }

      .feature-card:hover {
        transform: translateY(-10px);
      }

      .feature-icon {
        font-size: 3rem;
        color: #4a90e2;
        margin-bottom: 1.5rem;
      }

      .feature-title {
        font-size: 1.5rem;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 1rem;
      }

      .feature-text {
        color: #666;
        font-size: 1.1rem;
      }

      .floating-shapes {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
        z-index: -1;
      }

      .shape {
        position: absolute;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
        animation: float 15s infinite linear;
      }

      @keyframes float {
        0% {
          transform: translateY(0) rotate(0deg);
        }
        50% {
          transform: translateY(-20px) rotate(180deg);
        }
        100% {
          transform: translateY(0) rotate(360deg);
        }
      }
    </style>
  </head>
  <body>
    <div class="floating-shapes">
      <div
        class="shape"
        style="width: 100px; height: 100px; top: 10%; left: 10%"
      ></div>
      <div
        class="shape"
        style="width: 150px; height: 150px; top: 20%; right: 10%"
      ></div>
      <div
        class="shape"
        style="width: 80px; height: 80px; bottom: 20%; left: 20%"
      ></div>
      <div
        class="shape"
        style="width: 120px; height: 120px; bottom: 10%; right: 20%"
      ></div>
    </div>

    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container">
        <a class="navbar-brand" href="#">
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
              <a class="nav-link" href="#features">Features</a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/login"
                >Login</a
              >
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/register"
                >Register</a
              >
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <section class="hero-section">
      <div class="container">
        <h1 class="hero-title">Boost Your Productivity with FocusFriend</h1>
        <p class="hero-subtitle">
          Your personal productivity companion for better focus and time
          management
        </p>
        <div class="hero-buttons">
          <a
            href="${pageContext.request.contextPath}/register"
            class="btn btn-primary btn-hero"
          >
            <i class="fas fa-user-plus"></i> Get Started
          </a>
          <a href="#features" class="btn btn-outline-light btn-hero">
            <i class="fas fa-info-circle"></i> Learn More
          </a>
        </div>
      </div>
    </section>

    <section id="features" class="features-section">
      <div class="container">
        <div class="row g-4">
          <div class="col-md-4">
            <div class="feature-card">
              <div class="feature-icon">
                <i class="fas fa-clock"></i>
              </div>
              <h3 class="feature-title">Focus Timer</h3>
              <p class="feature-text">
                Stay focused with our customizable Pomodoro timer and track your
                productive hours.
              </p>
            </div>
          </div>
          <div class="col-md-4">
            <div class="feature-card">
              <div class="feature-icon">
                <i class="fas fa-tasks"></i>
              </div>
              <h3 class="feature-title">Task Management</h3>
              <p class="feature-text">
                Organize your tasks efficiently with our intuitive task
                management system.
              </p>
            </div>
          </div>
          <div class="col-md-4">
            <div class="feature-card">
              <div class="feature-icon">
                <i class="fas fa-chart-line"></i>
              </div>
              <h3 class="feature-title">Progress Tracking</h3>
              <p class="feature-text">
                Monitor your productivity and see your improvement over time.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
