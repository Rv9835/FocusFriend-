<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Error - FocusFriend</title>
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

      .error-container {
        max-width: 500px;
        width: 90%;
        margin: 20px;
        padding: 30px;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        backdrop-filter: blur(10px);
        text-align: center;
        transform: translateY(0);
        transition: transform 0.3s ease;
      }

      .error-container:hover {
        transform: translateY(-5px);
      }

      .error-icon {
        font-size: 5rem;
        color: #4a90e2;
        margin-bottom: 1.5rem;
        animation: bounce 2s infinite;
      }

      .error-title {
        color: #2c3e50;
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 1rem;
      }

      .error-message {
        color: #666;
        font-size: 1.1rem;
        margin-bottom: 2rem;
      }

      .btn-home {
        background: linear-gradient(45deg, #4a90e2, #5cb3ff);
        border: none;
        border-radius: 10px;
        padding: 12px 30px;
        font-size: 1.1rem;
        font-weight: 600;
        color: white;
        transition: all 0.3s ease;
      }

      .btn-home:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(74, 144, 226, 0.4);
        color: white;
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

      @keyframes bounce {
        0%,
        20%,
        50%,
        80%,
        100% {
          transform: translateY(0);
        }
        40% {
          transform: translateY(-30px);
        }
        60% {
          transform: translateY(-15px);
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
      <div class="error-container">
        <div class="error-icon">
          <i class="fas fa-exclamation-circle"></i>
        </div>
        <h1 class="error-title">Oops! Something went wrong</h1>
        <p class="error-message">
          <%= request.getSession().getAttribute("error") != null ?
          request.getSession().getAttribute("error") : "We encountered an
          unexpected error. Please try again later." %>
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-home">
          <i class="fas fa-home"></i> Back to Home
        </a>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
