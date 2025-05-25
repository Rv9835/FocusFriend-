<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>User Management - FocusFriend</title>
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
      .table th {
        background-color: #f8f9fa;
      }
      .status-badge {
        width: 80px;
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
                  class="nav-link"
                  href="${pageContext.request.contextPath}/admin/dashboard"
                >
                  <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active"
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
            <h1 class="h2">User Management</h1>
            <button
              type="button"
              class="btn btn-primary"
              data-bs-toggle="modal"
              data-bs-target="#createUserModal"
            >
              <i class="fas fa-user-plus"></i> Add User
            </button>
          </div>

          <c:if test="${param.success != null}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <c:choose>
                <c:when test="${param.success == 'created'}">
                  User created successfully
                </c:when>
                <c:when test="${param.success == 'updated'}">
                  User updated successfully
                </c:when>
                <c:when test="${param.success == 'deleted'}">
                  User deleted successfully
                </c:when>
              </c:choose>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <c:if test="${param.error != null}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <c:choose>
                <c:when test="${param.error == 'not_found'}">
                  User not found
                </c:when>
                <c:when test="${param.error == 'username_exists'}">
                  Username already exists
                </c:when>
              </c:choose>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <div class="card">
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Username</th>
                      <th>Email</th>
                      <th>Full Name</th>
                      <th>Created At</th>
                      <th>Last Login</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${users}" var="user">
                      <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.fullName}</td>
                        <td>
                          <fmt:formatDate
                            value="${user.createdAt}"
                            pattern="yyyy-MM-dd HH:mm"
                          />
                        </td>
                        <td>
                          <fmt:formatDate
                            value="${user.lastLogin}"
                            pattern="yyyy-MM-dd HH:mm"
                          />
                        </td>
                        <td>
                          <span
                            class="badge ${user.active ? 'bg-success' : 'bg-danger'} status-badge"
                          >
                            ${user.active ? 'Active' : 'Inactive'}
                          </span>
                        </td>
                        <td>
                          <button
                            type="button"
                            class="btn btn-sm btn-primary"
                            onclick="editUser(${user.id})"
                          >
                            <i class="fas fa-edit"></i>
                          </button>
                          <button
                            type="button"
                            class="btn btn-sm btn-danger"
                            onclick="deleteUser(${user.id})"
                          >
                            <i class="fas fa-trash"></i>
                          </button>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>

    <!-- Create User Modal -->
    <div class="modal fade" id="createUserModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Create New User</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <form
            action="${pageContext.request.contextPath}/admin/create-user"
            method="post"
          >
            <div class="modal-body">
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
                <label for="email" class="form-label">Email</label>
                <input
                  type="email"
                  class="form-control"
                  id="email"
                  name="email"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="fullName" class="form-label">Full Name</label>
                <input
                  type="text"
                  class="form-control"
                  id="fullName"
                  name="fullName"
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
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
              >
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">Create User</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Edit User</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <form
            action="${pageContext.request.contextPath}/admin/update-user"
            method="post"
          >
            <input type="hidden" id="editUserId" name="userId" />
            <div class="modal-body">
              <div class="mb-3">
                <label for="editEmail" class="form-label">Email</label>
                <input
                  type="email"
                  class="form-control"
                  id="editEmail"
                  name="email"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="editFullName" class="form-label">Full Name</label>
                <input
                  type="text"
                  class="form-control"
                  id="editFullName"
                  name="fullName"
                  required
                />
              </div>
              <div class="mb-3">
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    id="editIsActive"
                    name="isActive"
                  />
                  <label class="form-check-label" for="editIsActive">
                    Active
                  </label>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
              >
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                Save Changes
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      function editUser(userId) {
        // TODO: Fetch user data and populate the edit modal
        const editModal = new bootstrap.Modal(
          document.getElementById("editUserModal")
        );
        editModal.show();
      }

      function deleteUser(userId) {
        if (confirm("Are you sure you want to delete this user?")) {
          const form = document.createElement("form");
          form.method = "POST";
          form.action = "${pageContext.request.contextPath}/admin/delete-user";

          const input = document.createElement("input");
          input.type = "hidden";
          input.name = "userId";
          input.value = userId;

          form.appendChild(input);
          document.body.appendChild(form);
          form.submit();
        }
      }
    </script>
  </body>
</html>
