<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FocusFriend - Welcome</title>
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
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .welcome-container {
        max-width: 600px;
        padding: 40px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
      }
      .welcome-icon {
        font-size: 4rem;
        color: #0d6efd;
        margin-bottom: 20px;
      }
      .btn-container {
        margin-top: 30px;
        display: flex;
        gap: 15px;
        justify-content: center;
      }
      .btn {
        padding: 12px 30px;
        font-size: 1.1rem;
      }
    </style>
  </head>
  <body>
    <div class="welcome-container">
      <i class="fas fa-brain welcome-icon"></i>
      <h1 class="mb-4">Welcome to FocusFriend</h1>
      <p class="lead mb-4">Your personal productivity companion</p>
      <div class="btn-container">
        <a href="login.jsp" class="btn btn-primary">Login</a>
        <a href="dashboard.jsp" class="btn btn-outline-primary"
          >Go to Dashboard</a
        >
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
