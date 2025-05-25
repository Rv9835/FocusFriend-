<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
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
        padding: 20px;
      }
      .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
      }
      .card-header {
        background-color: #000dff;
        color: white;
        text-align: center;
        border-radius: 10px 10px 0 0 !important;
        padding: 20px;
      }
      .btn-primary {
        background-color: #000dff;
        border-color: #000dff;
      }
      .btn-primary:hover {
        background-color: #0009cc;
        border-color: #0009cc;
      }
    </style>
  </head>
  <body>
    <div class="login-container">
      <div class="card">
        <div class="card-header">
          <h3 class="mb-0">Admin Login</h3>
        </div>
        <div class="card-body">
          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
          </c:if>
          <form
            action="${pageContext.request.contextPath}/admin/login"
            method="post"
          >
            <div class="mb-3">
              <label for="username" class="form-label">Username</label>
              <input
                type="text"
                class="form-control"
                id="username"
                name="username"
                required
              />
            </div>
            <div class="mb-3">
              <label for="password" class="form-label">Password</label>
              <input
                type="password"
                class="form-control"
                id="password"
                name="password"
                required
              />
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
          </form>
          <div class="text-center mt-3">
            <a
              href="${pageContext.request.contextPath}/"
              class="text-decoration-none"
              >Back to Home</a
            >
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
