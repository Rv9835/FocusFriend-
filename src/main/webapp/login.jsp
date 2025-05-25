<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - FocusFriend</title>
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
      }
      .login-container {
        max-width: 400px;
        margin: 100px auto;
        padding: 20px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }
      .login-header {
        text-align: center;
        margin-bottom: 30px;
      }
      .login-header h1 {
        color: #0d6efd;
        font-size: 2rem;
        margin-bottom: 10px;
      }
      .form-floating {
        margin-bottom: 15px;
      }
      .btn-login {
        width: 100%;
        padding: 10px;
        font-size: 1.1rem;
      }
      .login-footer {
        text-align: center;
        margin-top: 20px;
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
          <h1><i class="fas fa-brain"></i> FocusFriend</h1>
          <p class="text-muted">Sign in to your account</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
          <% if (request.getParameter("error").equals("invalid")) { %> Invalid
          username or password <% } %>
        </div>
        <% } %> <% if (request.getParameter("registered") != null) { %>
        <div class="alert alert-success">
          Registration successful! Please login.
        </div>
        <% } %> <% if (request.getParameter("reset") != null) { %>
        <div class="alert alert-success">
          <% if (request.getParameter("reset").equals("email_sent")) { %>
          Password reset instructions have been sent to your email. <% } else if
          (request.getParameter("reset").equals("success")) { %> Password has
          been reset successfully. Please login with your new password. <% } %>
        </div>
        <% } %>

        <form
          action="${pageContext.request.contextPath}/auth/login"
          method="post"
        >
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
          <div class="form-check mb-3">
            <input
              class="form-check-input"
              type="radio"
              name="userType"
              id="userTypeUser"
              value="user"
              checked
            />
            <label class="form-check-label" for="userTypeUser"> User </label>
            <input
              class="form-check-input ms-3"
              type="radio"
              name="userType"
              id="userTypeAdmin"
              value="admin"
            />
            <label class="form-check-label" for="userTypeAdmin"> Admin </label>
          </div>
          <button type="submit" class="btn btn-primary btn-login">
            <i class="fas fa-sign-in-alt"></i> Sign In
          </button>
        </form>

        <div class="login-footer">
          <p class="mb-2">
            <a
              href="${pageContext.request.contextPath}/reset-password.jsp"
              class="text-decoration-none"
            >
              Forgot your password?
            </a>
          </p>
          <p class="mb-0">
            Don't have an account?
            <a
              href="${pageContext.request.contextPath}/register.jsp"
              class="text-decoration-none"
            >
              Register here
            </a>
          </p>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
