<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FocusFriend - Your Productivity Companion</title>
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
      .hero-section {
        background: linear-gradient(135deg, #6b73ff 0%, #000dff 100%);
        color: white;
        padding: 100px 0;
        margin-bottom: 50px;
      }
      .feature-card {
        background: white;
        border-radius: 10px;
        padding: 30px;
        margin-bottom: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
      }
      .feature-card:hover {
        transform: translateY(-5px);
      }
      .feature-icon {
        font-size: 2.5rem;
        margin-bottom: 20px;
        color: #000dff;
      }
      .cta-button {
        background: #000dff;
        color: white;
        padding: 15px 30px;
        border-radius: 25px;
        text-decoration: none;
        transition: background 0.3s ease;
      }
      .cta-button:hover {
        background: #0009cc;
        color: white;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
        <a class="navbar-brand" href="#">FocusFriend</a>
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
              <a class="nav-link" href="#about">About</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="dashboard.jsp">Dashboard</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <section class="hero-section text-center">
      <div class="container">
        <h1 class="display-4 mb-4">Boost Your Productivity</h1>
        <p class="lead mb-5">
          Track your focus sessions, set goals, and achieve more with
          FocusFriend
        </p>
        <a href="dashboard.jsp" class="cta-button">Get Started</a>
      </div>
    </section>

    <section id="features" class="container mb-5">
      <h2 class="text-center mb-5">Key Features</h2>
      <div class="row">
        <div class="col-md-4">
          <div class="feature-card text-center">
            <i class="fas fa-clock feature-icon"></i>
            <h3>Focus Sessions</h3>
            <p>
              Track your work sessions and maintain focus with our intuitive
              timer.
            </p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="feature-card text-center">
            <i class="fas fa-bullseye feature-icon"></i>
            <h3>Goal Setting</h3>
            <p>
              Set and track your productivity goals with detailed progress
              monitoring.
            </p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="feature-card text-center">
            <i class="fas fa-chart-line feature-icon"></i>
            <h3>Analytics</h3>
            <p>
              View your productivity trends and get insights to improve your
              workflow.
            </p>
          </div>
        </div>
      </div>
    </section>

    <section id="about" class="container mb-5">
      <div class="row align-items-center">
        <div class="col-md-6">
          <h2>About FocusFriend</h2>
          <p>
            FocusFriend is your personal productivity companion, designed to
            help you stay focused and achieve your goals. Whether you're a
            student, professional, or anyone looking to improve their
            productivity, our tools will help you track your progress and
            maintain momentum.
          </p>
        </div>
        <div class="col-md-6">
          <img
            src="https://via.placeholder.com/600x400"
            alt="Productivity"
            class="img-fluid rounded"
          />
        </div>
      </div>
    </section>

    <footer class="bg-dark text-white py-4">
      <div class="container text-center">
        <p>&copy; 2024 FocusFriend. All rights reserved.</p>
      </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
