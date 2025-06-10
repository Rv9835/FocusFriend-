<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - FocusFriend</title>
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

      .login-container {
        max-width: 400px;
        margin: 100px auto;
        padding: 20px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }

      .login-header {
        text-align: center;
        margin-bottom: 30px;
      }

      .login-header i {
        font-size: 3rem;
        color: #0d6efd;
        margin-bottom: 10px;
      }

      .form-floating {
        margin-bottom: 15px;
      }

      .alert {
        margin-bottom: 20px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="login-container">
        <div class="login-header">
          <i class="fas fa-brain"></i>
          <h2>FocusFriend</h2>
          <p class="text-muted">Sign in to your account</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
          <% if (request.getParameter("error").equals("invalid")) { %> Invalid
          username or password <% } else if
          (request.getParameter("error").equals("deactivated")) { %> Your
          account has been deactivated <% } else if
          (request.getParameter("error").equals("database")) { %> An error
          occurred. Please try again. <% } %>
        </div>
        <% } %> <% if (request.getParameter("registered") != null) { %>
        <div class="alert alert-success">
          Registration successful! Please sign in.
        </div>
        <% } %>

        <form action="auth" method="post">
          <div class="form-floating">
            <input
              type="text"
              class="form-control"
              id="username"
              name="username"
              placeholder="Username"
              required
            />
            <label for="username">Username</label>
          </div>
          <div class="form-floating">
            <input
              type="password"
              class="form-control"
              id="password"
              name="password"
              placeholder="Password"
              required
            />
            <label for="password">Password</label>
          </div>
          <button type="submit" class="btn btn-primary w-100">Sign In</button>
        </form>

        <div class="text-center mt-3">
          <p>
            Don't have an account?
            <a href="auth/register">Register</a>
          </p>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
