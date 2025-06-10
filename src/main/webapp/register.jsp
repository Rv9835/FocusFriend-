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
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        overflow: hidden;
      }

      body::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url("https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80")
          center/cover;
        opacity: 0.1;
        z-index: -1;
      }

      .register-container {
        max-width: 500px;
        width: 90%;
        margin: 20px;
        padding: 30px;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        backdrop-filter: blur(10px);
        transform: translateY(0);
        transition: transform 0.3s ease;
      }

      .register-container:hover {
        transform: translateY(-5px);
      }

      .register-header {
        text-align: center;
        margin-bottom: 30px;
      }

      .register-header h1 {
        color: #4a90e2;
        font-size: 2.5rem;
        margin-bottom: 10px;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
      }

      .form-floating {
        margin-bottom: 20px;
      }

      .form-control {
        border-radius: 10px;
        border: 2px solid #e9ecef;
        padding: 15px;
        transition: all 0.3s ease;
      }

      .form-control:focus {
        border-color: #4a90e2;
        box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
      }

      .btn-register {
        width: 100%;
        padding: 12px;
        font-size: 1.1rem;
        border-radius: 10px;
        background: linear-gradient(45deg, #4a90e2, #5cb3ff);
        border: none;
        color: white;
        font-weight: 600;
        transition: all 0.3s ease;
      }

      .btn-register:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
      }

      .register-footer {
        text-align: center;
        margin-top: 25px;
      }

      .register-footer a {
        color: #4a90e2;
        font-weight: 600;
        transition: color 0.3s ease;
      }

      .register-footer a:hover {
        color: #2c6cb0;
      }

      .alert {
        border-radius: 10px;
        margin-bottom: 20px;
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

    <div class="container">
      <div class="register-container">
        <div class="register-header">
          <h1><i class="fas fa-brain"></i> FocusFriend</h1>
          <p class="text-muted">Join our community of focused learners</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
          <% if (request.getParameter("error").equals("username_exists")) { %>
          Username already exists. Please choose a different one. <% } else if
          (request.getParameter("error").equals("email_exists")) { %> Email
          already registered. Please use a different email or login. <% } else {
          %> An error occurred during registration. Please try again. <% } %>
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
            <div class="invalid-feedback">Please enter a username.</div>
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

          <button type="submit" class="btn btn-register">
            <i class="fas fa-user-plus"></i> Create Account
          </button>
        </form>

        <div class="register-footer">
          <p class="mb-0">
            Already have an account?
            <a
              href="${pageContext.request.contextPath}/login"
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
