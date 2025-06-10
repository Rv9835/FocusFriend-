package com.focusfriend.dao;

import com.focusfriend.model.Admin;
import com.focusfriend.util.DBUtil;
import com.focusfriend.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    private Connection connection;

    public AdminDAO() {
        try {
            this.connection = DBUtil.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Error initializing AdminDAO", e);
        }
    }

    public Admin createAdmin(Admin admin) {
        String hashedPassword = PasswordUtil.hashPassword(admin.getPassword());
        String sql = "INSERT INTO admins (username, password, email, full_name, created_at, is_active, is_super_admin) " +
                    "VALUES (?, ?, ?, ?, NOW(), ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, hashedPassword);
            stmt.setString(3, admin.getEmail());
            stmt.setString(4, admin.getFullName());
            stmt.setBoolean(5, admin.isActive());
            stmt.setBoolean(6, admin.isSuperAdmin());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating admin failed, no rows affected.");
            }
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    admin.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating admin failed, no ID obtained.");
                }
            }
            return admin;
        } catch (SQLException e) {
            throw new RuntimeException("Error creating admin", e);
        }
    }

    public Admin getAdminById(int id) {
        String sql = "SELECT * FROM admins WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting admin by ID", e);
        }
        return null;
    }

    public Admin getAdminByUsername(String username) {
        String sql = "SELECT * FROM admins WHERE username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting admin by username", e);
        }
        return null;
    }

    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admins";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting all admins", e);
        }
        return admins;
    }

    public void updateAdmin(Admin admin) {
        String sql = "UPDATE admins SET username = ?, email = ?, full_name = ?, is_active = ?, is_super_admin = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getFullName());
            stmt.setBoolean(4, admin.isActive());
            stmt.setBoolean(5, admin.isSuperAdmin());
            stmt.setInt(6, admin.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating admin", e);
        }
    }

    public void updatePassword(int adminId, String newPassword) {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        String sql = "UPDATE admins SET password = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, adminId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating password", e);
        }
    }

    public void setResetToken(int adminId, String token, Timestamp expiry) {
        String sql = "UPDATE admins SET reset_token = ?, reset_token_expiry = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setTimestamp(2, expiry);
            stmt.setInt(3, adminId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error setting reset token", e);
        }
    }

    public Admin getAdminByResetToken(String token) {
        String sql = "SELECT * FROM admins WHERE reset_token = ? AND reset_token_expiry > NOW()";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting admin by reset token", e);
        }
        return null;
    }

    public void updateLastLogin(int adminId) {
        String sql = "UPDATE admins SET last_login = NOW() WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, adminId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating last login", e);
        }
    }

    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setId(rs.getInt("id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setEmail(rs.getString("email"));
        admin.setFullName(rs.getString("full_name"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        admin.setLastLogin(rs.getTimestamp("last_login"));
        admin.setActive(rs.getBoolean("is_active"));
        admin.setSuperAdmin(rs.getBoolean("is_super_admin"));
        admin.setResetToken(rs.getString("reset_token"));
        admin.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
        return admin;
    }

    public boolean validateAdmin(String username, String password) throws SQLException {
        String query = "SELECT * FROM admins WHERE username = ? AND is_active = true";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                return PasswordUtil.verifyPassword(password, hashedPassword);
            }
            return false;
        }
    }
} 