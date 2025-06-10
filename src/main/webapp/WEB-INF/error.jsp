<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Oops! - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap"
      rel="stylesheet"
    />
    <style>
      :root {
        --primary-color: #4a90e2;
        --error-color: #e74c3c;
        --background-color: #f8f9fa;
      }

      body {
        background-color: var(--background-color);
        font-family: "Poppins", sans-serif;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .error-container {
        max-width: 600px;
        margin: 2rem;
        padding: 2rem;
        background: white;
        border-radius: 20px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        position: relative;
        overflow: hidden;
      }

      .error-container::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 5px;
        background: linear-gradient(90deg, var(--error-color), #c0392b);
      }

      .error-icon {
        font-size: 5rem;
        margin-bottom: 1rem;
        animation: bounce 2s infinite;
      }

      .error-title {
        color: var(--error-color);
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 1rem;
      }

      .error-message {
        color: #666;
        margin-bottom: 2rem;
      }

      .btn-primary {
        background: linear-gradient(135deg, var(--primary-color), #2980b9);
        border: none;
        padding: 0.8rem 1.5rem;
        border-radius: 25px;
        font-weight: 500;
        transition: transform 0.3s ease;
        margin: 0.5rem;
      }

      .btn-primary:hover {
        transform: scale(1.05);
        background: linear-gradient(135deg, #2980b9, var(--primary-color));
      }

      .btn-secondary {
        background: #95a5a6;
        border: none;
        padding: 0.8rem 1.5rem;
        border-radius: 25px;
        font-weight: 500;
        transition: transform 0.3s ease;
        margin: 0.5rem;
      }

      .btn-secondary:hover {
        transform: scale(1.05);
        background: #7f8c8d;
      }

      .error-details {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 10px;
        margin: 1rem 0;
        font-size: 0.9rem;
        color: #666;
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
          transform: translateY(-20px);
        }
        60% {
          transform: translateY(-10px);
        }
      }

      .fun-message {
        font-style: italic;
        color: #666;
        margin-top: 1rem;
      }

      @media (max-width: 768px) {
        .error-container {
          margin: 1rem;
          padding: 1.5rem;
        }
      }
    </style>
  </head>
  <body>
    <div class="error-container">
      <div class="error-icon">🤔</div>
      <h1 class="error-title">Oops! Something went wrong</h1>

      <% if (request.getAttribute("validationError") != null) { %>
      <div class="error-message">
        <h4>Validation Error</h4>
        <p>${errorMessage}</p>
        <% if (request.getAttribute("errorField") != null) { %>
        <p>Field: ${errorField}</p>
        <% } %>
        <p class="fun-message">
          Don't worry, even the best of us make typos! 😉
        </p>
      </div>
      <% } else { %>
      <div class="error-message">
        <h4>Error Details</h4>
        <p>${errorMessage}</p>
        <% if (request.getAttribute("errorDetails") != null) { %>
        <div class="error-details">${errorDetails}</div>
        <% } %>
        <p class="fun-message">Looks like our app took a coffee break! ☕</p>
      </div>
      <% } %>

      <div class="mt-4">
        <a
          href="${pageContext.request.contextPath}/dashboard"
          class="btn btn-primary"
        >
          <i class="fas fa-home me-2"></i>Return to Dashboard
        </a>
        <button onclick="history.back()" class="btn btn-secondary">
          <i class="fas fa-arrow-left me-2"></i>Go Back
        </button>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Add some fun animations
      document.addEventListener("DOMContentLoaded", function () {
        const errorIcon = document.querySelector(".error-icon");
        const emojis = ["🤔", "😅", "🙈", "🤷‍♂️", "💫"];
        let currentIndex = 0;

        setInterval(() => {
          errorIcon.style.opacity = "0";
          setTimeout(() => {
            errorIcon.textContent = emojis[currentIndex];
            errorIcon.style.opacity = "1";
            currentIndex = (currentIndex + 1) % emojis.length;
          }, 200);
        }, 3000);
      });
    </script>
  </body>
</html>
