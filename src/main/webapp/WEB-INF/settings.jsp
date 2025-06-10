<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Settings - FocusFriend</title>
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
      .settings-card {
        background: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        position: relative;
        z-index: 1;
      }
      .settings-section {
        margin-bottom: 30px;
      }
      .settings-section h3 {
        margin-bottom: 20px;
        color: #0d6efd;
      }
      .nav-link {
        color: #495057;
        padding: 0.5rem 1rem;
        border-radius: 0.25rem;
      }
      .nav-link:hover {
        background-color: #e9ecef;
      }
      .nav-link.active {
        color: #0d6efd;
        background-color: #e9ecef;
      }
    </style>
  </head>
  <body>
    <div class="container mt-5">
      <div class="settings-card">
        <h2><i class="fas fa-cog"></i> Settings</h2>

        <!-- Focus Session Settings -->
        <div class="settings-section">
          <h3>Focus Session Settings</h3>
          <form id="focusSettingsForm">
            <div class="mb-3">
              <label for="defaultSessionLength" class="form-label"
                >Default Session Length (minutes)</label
              >
              <input
                type="number"
                class="form-control"
                id="defaultSessionLength"
                value="${userSettings.defaultSessionLength}"
                min="5"
                max="120"
              />
            </div>
            <div class="mb-3">
              <label for="breakLength" class="form-label"
                >Break Length (minutes)</label
              >
              <input
                type="number"
                class="form-control"
                id="breakLength"
                value="${userSettings.breakLength}"
                min="1"
                max="30"
              />
            </div>
            <div class="mb-3">
              <label for="longBreakLength" class="form-label"
                >Long Break Length (minutes)</label
              >
              <input
                type="number"
                class="form-control"
                id="longBreakLength"
                value="${userSettings.longBreakLength}"
                min="5"
                max="60"
              />
            </div>
            <div class="mb-3">
              <label for="sessionsUntilLongBreak" class="form-label"
                >Sessions Until Long Break</label
              >
              <input
                type="number"
                class="form-control"
                id="sessionsUntilLongBreak"
                value="${userSettings.sessionsUntilLongBreak}"
                min="1"
                max="10"
              />
            </div>
            <button type="submit" class="btn btn-primary">
              Save Focus Settings
            </button>
          </form>
        </div>

        <!-- Notification Settings -->
        <div class="settings-section">
          <h3>Notification Settings</h3>
          <form id="notificationSettingsForm">
            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input"
              id="enableNotifications" ${userSettings.enableNotifications ?
              'checked' : ''}>
              <label class="form-check-label" for="enableNotifications"
                >Enable Notifications</label
              >
            </div>
            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" id="soundEnabled"
              ${userSettings.soundEnabled ? 'checked' : ''}>
              <label class="form-check-label" for="soundEnabled"
                >Enable Sound</label
              >
            </div>
            <button type="submit" class="btn btn-primary">
              Save Notification Settings
            </button>
          </form>
        </div>

        <!-- Account Settings -->
        <div class="settings-section">
          <h3>Account Settings</h3>
          <form id="accountSettingsForm">
            <div class="mb-3">
              <label for="email" class="form-label">Email</label>
              <input
                type="email"
                class="form-control"
                id="email"
                value="${user.email}"
                readonly
              />
            </div>
            <div class="mb-3">
              <label for="currentPassword" class="form-label"
                >Current Password</label
              >
              <input
                type="password"
                class="form-control"
                id="currentPassword"
              />
            </div>
            <div class="mb-3">
              <label for="newPassword" class="form-label">New Password</label>
              <input type="password" class="form-control" id="newPassword" />
            </div>
            <div class="mb-3">
              <label for="confirmPassword" class="form-label"
                >Confirm New Password</label
              >
              <input
                type="password"
                class="form-control"
                id="confirmPassword"
              />
            </div>
            <button type="submit" class="btn btn-primary">
              Update Password
            </button>
          </form>
        </div>

        <!-- Danger Zone -->
        <div class="settings-section">
          <h3 class="text-danger">Danger Zone</h3>
          <button class="btn btn-danger" onclick="deleteAccount()">
            <i class="fas fa-trash"></i> Delete Account
          </button>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Save focus settings
      document
        .getElementById("focusSettingsForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();
          const settings = {
            defaultSessionLength: document.getElementById(
              "defaultSessionLength"
            ).value,
            breakLength: document.getElementById("breakLength").value,
            longBreakLength: document.getElementById("longBreakLength").value,
            sessionsUntilLongBreak: document.getElementById(
              "sessionsUntilLongBreak"
            ).value,
          };
          saveSettings("focus", settings);
        });

      // Save notification settings
      document
        .getElementById("notificationSettingsForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();
          const settings = {
            enableNotifications: document.getElementById("enableNotifications")
              .checked,
            soundEnabled: document.getElementById("soundEnabled").checked,
          };
          saveSettings("notification", settings);
        });

      // Update password
      document
        .getElementById("accountSettingsForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();
          const currentPassword =
            document.getElementById("currentPassword").value;
          const newPassword = document.getElementById("newPassword").value;
          const confirmPassword =
            document.getElementById("confirmPassword").value;

          if (newPassword !== confirmPassword) {
            alert("New passwords do not match!");
            return;
          }

          updatePassword(currentPassword, newPassword);
        });

      // Save settings to server
      function saveSettings(type, settings) {
        fetch("${pageContext.request.contextPath}/settings", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            type: type,
            settings: settings,
          }),
        })
          .then((response) => {
            if (response.ok) {
              alert("Settings saved successfully!");
            } else {
              alert("Error saving settings");
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("Error saving settings");
          });
      }

      // Update password
      function updatePassword(currentPassword, newPassword) {
        fetch("${pageContext.request.contextPath}/settings/password", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            currentPassword: currentPassword,
            newPassword: newPassword,
          }),
        })
          .then((response) => {
            if (response.ok) {
              alert("Password updated successfully!");
              document.getElementById("accountSettingsForm").reset();
            } else {
              alert("Error updating password");
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("Error updating password");
          });
      }

      // Delete account
      function deleteAccount() {
        if (
          confirm(
            "Are you sure you want to delete your account? This action cannot be undone."
          )
        ) {
          fetch("${pageContext.request.contextPath}/settings/account", {
            method: "DELETE",
          })
            .then((response) => {
              if (response.ok) {
                window.location.href =
                  "${pageContext.request.contextPath}/logout";
              } else {
                alert("Error deleting account");
              }
            })
            .catch((error) => {
              console.error("Error:", error);
              alert("Error deleting account");
            });
        }
      }
    </script>
  </body>
</html>
