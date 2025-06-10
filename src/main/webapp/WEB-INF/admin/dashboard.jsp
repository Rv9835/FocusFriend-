<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - FocusFriend</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
      rel="stylesheet"
    />
    <style>
      .sidebar {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        z-index: 100;
        padding: 48px 0 0;
        box-shadow: inset -1px 0 0 rgba(0, 0, 0, 0.1);
        background-color: #f8f9fa;
      }
      .sidebar-sticky {
        position: relative;
        top: 0;
        height: calc(100vh - 48px);
        padding-top: 0.5rem;
        overflow-x: hidden;
        overflow-y: auto;
      }
      .navbar {
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      .main-content {
        margin-left: 240px;
        padding: 20px;
      }
      .stat-card {
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s;
      }
      .stat-card:hover {
        transform: translateY(-5px);
      }
      .stat-icon {
        font-size: 2rem;
        margin-bottom: 10px;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">
          <i class="fas fa-brain"></i> FocusFriend Admin
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
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/auth/logout"
              >
                <i class="fas fa-sign-out-alt"></i> Logout
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <nav class="col-md-3 col-lg-2 d-md-block sidebar">
          <div class="sidebar-sticky">
            <ul class="nav flex-column">
              <li class="nav-item">
                <a
                  class="nav-link active"
                  href="${pageContext.request.contextPath}/admin/dashboard"
                >
                  <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="${pageContext.request.contextPath}/admin/users"
                >
                  <i class="fas fa-users"></i> Users
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="${pageContext.request.contextPath}/admin/admins"
                >
                  <i class="fas fa-user-shield"></i> Admins
                </a>
              </li>
            </ul>
          </div>
        </nav>

        <main class="main-content">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom"
          >
            <h1 class="h2">Dashboard</h1>
          </div>

          <div class="row">
            <div class="col-md-4 mb-4">
              <div class="card stat-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="fas fa-users stat-icon"></i>
                  <h5 class="card-title">Total Users</h5>
                  <h2 class="card-text">${totalUsers}</h2>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card stat-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="fas fa-user-shield stat-icon"></i>
                  <h5 class="card-title">Total Admins</h5>
                  <h2 class="card-text">${totalAdmins}</h2>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card stat-card bg-info text-white">
                <div class="card-body text-center">
                  <i class="fas fa-chart-line stat-icon"></i>
                  <h5 class="card-title">Active Sessions</h5>
                  <h2 class="card-text">0</h2>
                </div>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-4">
              <div class="card">
                <div class="card-header">
                  <h5 class="card-title mb-0">Recent Users</h5>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table">
                      <thead>
                        <tr>
                          <th>Username</th>
                          <th>Email</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        <!-- TODO: Add recent users data -->
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card">
                <div class="card-header">
                  <h5 class="card-title mb-0">Recent Activity</h5>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table">
                      <thead>
                        <tr>
                          <th>User</th>
                          <th>Action</th>
                          <th>Time</th>
                        </tr>
                      </thead>
                      <tbody>
                        <!-- TODO: Add recent activity data -->
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
