<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>FocusFriend Chat</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    />
    <style>
      #chat-box {
        height: 400px;
        overflow-y: scroll;
        background: #f8f9fa;
        border: 1px solid #ddd;
        padding: 1rem;
      }
      .chat-message {
        margin-bottom: 0.5rem;
        padding: 0.5rem;
        border-radius: 0.25rem;
      }
      .chat-message.user {
        text-align: right;
        background-color: #e3f2fd;
      }
      .chat-message.ai {
        text-align: left;
        background-color: #f5f5f5;
      }
      .error-message {
        color: red;
        margin: 1rem 0;
      }
    </style>
  </head>
  <body>
    <div class="container mt-4">
      <h2>Chat Room</h2>
      <div id="error-message" class="error-message" style="display: none"></div>
      <div id="chat-box" class="mb-3"></div>
      <form id="chat-form" class="d-flex">
        <input
          type="text"
          id="message"
          class="form-control me-2"
          placeholder="Type your message..."
          autocomplete="off"
          required
        />
        <button type="submit" class="btn btn-primary">Send</button>
      </form>
    </div>
    <script>
      function showError(message) {
        const errorDiv = document.getElementById("error-message");
        errorDiv.textContent = message;
        errorDiv.style.display = "block";
        setTimeout(() => {
          errorDiv.style.display = "none";
        }, 5000);
      }

      function fetchMessages() {
        fetch("${pageContext.request.contextPath}/chat/api")
          .then((res) => {
            if (!res.ok) {
              throw new Error("Failed to fetch messages");
            }
            return res.json();
          })
          .then((messages) => {
            const box = document.getElementById("chat-box");
            box.innerHTML = "";
            messages.reverse().forEach((msg) => {
              const div = document.createElement("div");
              div.className =
                "chat-message " + (msg.aiResponse ? "ai" : "user");
              div.textContent = msg.message;
              box.appendChild(div);
            });
            box.scrollTop = box.scrollHeight;
          })
          .catch((error) => {
            showError("Error loading messages: " + error.message);
          });
      }

      fetchMessages();
      setInterval(fetchMessages, 3000);

      document.getElementById("chat-form").onsubmit = function (e) {
        e.preventDefault();
        const message = document.getElementById("message").value;
        fetch("${pageContext.request.contextPath}/chat", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: "message=" + encodeURIComponent(message),
        })
          .then((res) => {
            if (!res.ok) {
              throw new Error("Failed to send message");
            }
            document.getElementById("message").value = "";
            fetchMessages();
          })
          .catch((error) => {
            showError("Error sending message: " + error.message);
          });
      };
    </script>
  </body>
</html>
