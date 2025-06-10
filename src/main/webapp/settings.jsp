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
      :root {
        --primary-color: #4a90e2;
        --secondary-color: #764ba2;
        --accent-color: #5cb3ff;
        --text-color: #2c3e50;
        --light-text: #666;
        --white: #fff;
      }

      body {
        background: linear-gradient(
          135deg,
          var(--primary-color) 0%,
          var(--secondary-color) 100%
        );
        min-height: 100vh;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      }

      .navbar {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }

      .navbar-brand {
        color: var(--primary-color) !important;
        font-weight: 600;
      }

      .card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
      }

      .settings-section {
        padding: 20px;
      }

      .form-label {
        font-weight: 500;
        color: var(--text-color);
      }

      .btn-primary {
        background: var(--primary-color);
        border: none;
      }

      .btn-primary:hover {
        background: var(--accent-color);
      }

      .profile-image {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        margin-bottom: 20px;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container">
        <a class="navbar-brand" href="dashboard">
          <i class="fas fa-brain"></i> FocusFriend
        </a>
        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <a class="nav-link" href="tasks">
                <i class="fas fa-tasks"></i> Tasks
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="progress">
                <i class="fas fa-chart-line"></i> Progress
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link active" href="settings">
                <i class="fas fa-cog"></i> Settings
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container mt-4">
      <div class="row">
        <!-- Profile Settings -->
        <div class="col-md-4">
          <div class="card">
            <div class="card-body text-center">
              <img
                src="https://via.placeholder.com/150"
                alt="Profile"
                class="profile-image"
              />
              <h5 class="card-title">John Doe</h5>
              <p class="text-muted">john.doe@example.com</p>
              <button
                class="btn btn-outline-primary btn-sm"
                onclick="document.getElementById('profileImageInput').click()"
              >
                <i class="fas fa-camera"></i> Change Photo
              </button>
              <input
                type="file"
                id="profileImageInput"
                style="display: none"
                accept="image/*"
              />
            </div>
          </div>
        </div>

        <!-- Account Settings -->
        <div class="col-md-8">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">Account Settings</h5>
            </div>
            <div class="card-body">
              <form id="accountSettingsForm">
                <div class="mb-3">
                  <label for="displayName" class="form-label"
                    >Display Name</label
                  >
                  <input
                    type="text"
                    class="form-control"
                    id="displayName"
                    value="John Doe"
                  />
                </div>
                <div class="mb-3">
                  <label for="email" class="form-label">Email Address</label>
                  <input
                    type="email"
                    class="form-control"
                    id="email"
                    value="john.doe@example.com"
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
                  <label for="newPassword" class="form-label"
                    >New Password</label
                  >
                  <input
                    type="password"
                    class="form-control"
                    id="newPassword"
                  />
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
                  Save Changes
                </button>
              </form>
            </div>
          </div>

          <!-- Notification Settings -->
          <div class="card mt-4">
            <div class="card-header">
              <h5 class="card-title mb-0">Notification Settings</h5>
            </div>
            <div class="card-body">
              <div class="form-check form-switch mb-3">
                <input
                  class="form-check-input"
                  type="checkbox"
                  id="emailNotifications"
                  checked
                />
                <label class="form-check-label" for="emailNotifications"
                  >Email Notifications</label
                >
              </div>
              <div class="form-check form-switch mb-3">
                <input
                  class="form-check-input"
                  type="checkbox"
                  id="sessionReminders"
                  checked
                />
                <label class="form-check-label" for="sessionReminders"
                  >Session Reminders</label
                >
              </div>
              <div class="form-check form-switch mb-3">
                <input
                  class="form-check-input"
                  type="checkbox"
                  id="taskReminders"
                  checked
                />
                <label class="form-check-label" for="taskReminders"
                  >Task Reminders</label
                >
              </div>
              <div class="form-check form-switch">
                <input
                  class="form-check-input"
                  type="checkbox"
                  id="progressUpdates"
                />
                <label class="form-check-label" for="progressUpdates"
                  >Weekly Progress Updates</label
                >
              </div>
            </div>
          </div>

          <!-- Focus Settings -->
          <div class="card mt-4">
            <div class="card-header">
              <h5 class="card-title mb-0">Focus Settings</h5>
            </div>
            <div class="card-body">
              <div class="mb-3">
                <label for="defaultSessionLength" class="form-label"
                  >Default Session Length (minutes)</label
                >
                <select class="form-select" id="defaultSessionLength">
                  <option value="25">25 minutes</option>
                  <option value="45">45 minutes</option>
                  <option value="60">60 minutes</option>
                  <option value="90">90 minutes</option>
                </select>
              </div>
              <div class="mb-3">
                <label for="breakLength" class="form-label"
                  >Break Length (minutes)</label
                >
                <select class="form-select" id="breakLength">
                  <option value="5">5 minutes</option>
                  <option value="10">10 minutes</option>
                  <option value="15">15 minutes</option>
                  <option value="20">20 minutes</option>
                </select>
              </div>
              <div class="form-check form-switch mb-3">
                <input
                  class="form-check-input"
                  type="checkbox"
                  id="autoStartBreaks"
                  checked
                />
                <label class="form-check-label" for="autoStartBreaks"
                  >Auto-start Breaks</label
                >
              </div>
              <div class="form-check form-switch">
                <input
                  class="form-check-input"
                  type="checkbox"
                  id="autoStartSessions"
                />
                <label class="form-check-label" for="autoStartSessions"
                  >Auto-start Next Session</label
                >
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Handle profile image upload
      document
        .getElementById("profileImageInput")
        .addEventListener("change", function (e) {
          const file = e.target.files[0];
          if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
              document.querySelector(".profile-image").src = e.target.result;
            };
            reader.readAsDataURL(file);
          }
        });

      // Handle form submission
      document
        .getElementById("accountSettingsForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();
          // Here you would typically make an AJAX call to save the settings
          alert("Settings saved successfully!");
        });

      // Handle notification settings changes
      document.querySelectorAll(".form-check-input").forEach((checkbox) => {
        checkbox.addEventListener("change", function () {
          // Here you would typically make an AJAX call to update the setting
          console.log(`${this.id} changed to ${this.checked}`);
        });
      });

      // Handle focus settings changes
      document
        .getElementById("defaultSessionLength")
        .addEventListener("change", function () {
          // Here you would typically make an AJAX call to update the setting
          console.log(
            `Default session length changed to ${this.value} minutes`
          );
        });

      document
        .getElementById("breakLength")
        .addEventListener("change", function () {
          // Here you would typically make an AJAX call to update the setting
          console.log(`Break length changed to ${this.value} minutes`);
        });
    </script>
  </body>
</html>
