<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - FocusFriend</title>
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
      .register-container {
        max-width: 500px;
        margin: 50px auto;
        padding: 20px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }
      .register-header {
        text-align: center;
        margin-bottom: 30px;
      }
      .register-header h1 {
        color: #0d6efd;
        font-size: 2rem;
        margin-bottom: 10px;
      }
      .form-floating {
        margin-bottom: 15px;
      }
      .btn-register {
        width: 100%;
        padding: 10px;
        font-size: 1.1rem;
      }
      .register-footer {
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
      <div class="register-container">
        <div class="register-header">
          <h1><i class="fas fa-brain"></i> FocusFriend</h1>
          <p class="text-muted">Create your account</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
          <% if (request.getParameter("error").equals("username_exists")) { %>
          Username already exists <% } else if
          (request.getParameter("error").equals("email_exists")) { %> Email
          already exists <% } %>
        </div>
        <% } %>

        <form
          action="${pageContext.request.contextPath}/auth/register"
          method="post"
          class="needs-validation"
          novalidate
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
            <div class="invalid-feedback">Please choose a username.</div>
          </div>
          <div class="form-floating">
            <input
              type="email"
              class="form-control"
              id="email"
              name="email"
              placeholder="Email"
              required
            />
            <label for="email">Email</label>
            <div class="invalid-feedback">
              Please enter a valid email address.
            </div>
          </div>
          <div class="form-floating">
            <input
              type="text"
              class="form-control"
              id="fullName"
              name="fullName"
              placeholder="Full Name"
              required
            />
            <label for="fullName">Full Name</label>
            <div class="invalid-feedback">Please enter your full name.</div>
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
            <div class="invalid-feedback">Please enter a password.</div>
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
            <div class="invalid-feedback">Please confirm your password.</div>
          </div>
          <button type="submit" class="btn btn-primary btn-register">
            <i class="fas fa-user-plus"></i> Register
          </button>
        </form>

        <div class="register-footer">
          <p class="mb-0">
            Already have an account?
            <a
              href="${pageContext.request.contextPath}/login.jsp"
              class="text-decoration-none"
            >
              Sign in here
            </a>
          </p>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Form validation
      (function () {
        "use strict";
        var forms = document.querySelectorAll(".needs-validation");
        Array.prototype.slice.call(forms).forEach(function (form) {
          form.addEventListener(
            "submit",
            function (event) {
              if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
              }

              // Check if passwords match
              var password = document.getElementById("password");
              var confirmPassword = document.getElementById("confirmPassword");
              if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords do not match");
                event.preventDefault();
                event.stopPropagation();
              } else {
                confirmPassword.setCustomValidity("");
              }

              form.classList.add("was-validated");
            },
            false
          );
        });
      })();
    </script>
  </body>
</html>
