<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reset Password - FocusFriend</title>
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
      .reset-container {
        max-width: 400px;
        margin: 100px auto;
        padding: 20px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }
      .reset-header {
        text-align: center;
        margin-bottom: 30px;
      }
      .reset-header h1 {
        color: #0d6efd;
        font-size: 2rem;
        margin-bottom: 10px;
      }
      .form-floating {
        margin-bottom: 15px;
      }
      .btn-reset {
        width: 100%;
        padding: 10px;
        font-size: 1.1rem;
      }
      .reset-footer {
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
      <div class="reset-container">
        <div class="reset-header">
          <h1><i class="fas fa-brain"></i> FocusFriend</h1>
          <p class="text-muted">Reset your password</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
          <% if (request.getParameter("error").equals("not_found")) { %> No
          account found with that email address <% } else if
          (request.getParameter("error").equals("invalid_token")) { %> Invalid
          or expired reset token <% } %>
        </div>
        <% } %> <% if (request.getParameter("token") == null) { %>
        <form
          action="${pageContext.request.contextPath}/auth/reset-password"
          method="post"
        >
          <div class="form-floating">
            <input
              type="text"
              class="form-control"
              id="email"
              name="email"
              placeholder="Email"
              required
            />
            <label for="email">Email</label>
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
          <button type="submit" class="btn btn-primary btn-reset">
            <i class="fas fa-paper-plane"></i> Send Reset Link
          </button>
        </form>
        <% } else { %>
        <form
          action="${pageContext.request.contextPath}/auth/change-password"
          method="post"
        >
          <input type="hidden" name="token" value="<%=
          request.getParameter("token") %>"> <input type="hidden"
          name="userType" value="<%= request.getParameter("userType") %>">
          <div class="form-floating">
            <input
              type="password"
              class="form-control"
              id="newPassword"
              name="newPassword"
              placeholder="New Password"
              required
            />
            <label for="newPassword">New Password</label>
          </div>
          <div class="form-floating">
            <input
              type="password"
              class="form-control"
              id="confirmPassword"
              name="confirmPassword"
              placeholder="Confirm Password"
              required
            />
            <label for="confirmPassword">Confirm Password</label>
          </div>
          <button type="submit" class="btn btn-primary btn-reset">
            <i class="fas fa-key"></i> Reset Password
          </button>
        </form>
        <% } %>

        <div class="reset-footer">
          <p class="mb-0">
            <a
              href="${pageContext.request.contextPath}/login.jsp"
              class="text-decoration-none"
            >
              <i class="fas fa-arrow-left"></i> Back to Login
            </a>
          </p>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Password confirmation validation
      var newPassword = document.getElementById("newPassword");
      var confirmPassword = document.getElementById("confirmPassword");

      if (newPassword && confirmPassword) {
        confirmPassword.addEventListener("input", function () {
          if (newPassword.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity("Passwords do not match");
          } else {
            confirmPassword.setCustomValidity("");
          }
        });

        newPassword.addEventListener("input", function () {
          if (confirmPassword.value !== "") {
            if (newPassword.value !== confirmPassword.value) {
              confirmPassword.setCustomValidity("Passwords do not match");
            } else {
              confirmPassword.setCustomValidity("");
            }
          }
        });
      }
    </script>
  </body>
</html>
