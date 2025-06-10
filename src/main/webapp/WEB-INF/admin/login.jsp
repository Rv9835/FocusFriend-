<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Login - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
      rel="stylesheet"
    />
    <style>
      body {
        background-color: #f8f9fa;
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .login-container {
        max-width: 400px;
        width: 100%;
        padding: 2rem;
        background: white;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
      }
      .login-header {
        text-align: center;
        margin-bottom: 2rem;
      }
      .login-header h1 {
        color: #333;
        font-size: 1.8rem;
        margin-bottom: 0.5rem;
      }
      .login-header p {
        color: #666;
        margin-bottom: 0;
      }
      .form-floating {
        margin-bottom: 1rem;
      }
      .btn-login {
        width: 100%;
        padding: 0.8rem;
        font-size: 1.1rem;
        margin-top: 1rem;
      }
      .alert {
        margin-bottom: 1rem;
      }
    </style>
  </head>
  <body>
    <div class="login-container">
      <div class="login-header">
        <h1>Admin Login</h1>
        <p>Welcome back! Please login to your account.</p>
      </div>

      <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %>

      <form
        action="${pageContext.request.contextPath}/admin/login"
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
        <button type="submit" class="btn btn-primary btn-login">
          <i class="fas fa-sign-in-alt"></i> Sign In
        </button>
      </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
