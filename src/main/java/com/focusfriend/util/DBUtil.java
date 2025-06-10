package com.focusfriend.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBUtil {
    private static final String URL = "jdbc:h2:mem:focusfriend;DB_CLOSE_DELAY=-1";
    private static final String USER = "sa";
    private static final String PASSWORD = "";

    static {
        try {
            Class.forName("org.h2.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void initializeDatabase() {
        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            // Users table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "username VARCHAR(50) NOT NULL UNIQUE,"
                + "password VARCHAR(255) NOT NULL,"
                + "email VARCHAR(100) NOT NULL UNIQUE,"
                + "full_name VARCHAR(100),"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                + "last_login TIMESTAMP NULL,"
                + "is_active BOOLEAN DEFAULT TRUE,"
                + "reset_token VARCHAR(255),"
                + "reset_token_expiry TIMESTAMP"
                + ")");
            // Admins table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS admins ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "username VARCHAR(50) NOT NULL UNIQUE,"
                + "password VARCHAR(255) NOT NULL,"
                + "email VARCHAR(100) NOT NULL UNIQUE,"
                + "full_name VARCHAR(100),"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                + "last_login TIMESTAMP NULL,"
                + "is_active BOOLEAN DEFAULT TRUE,"
                + "is_super_admin BOOLEAN DEFAULT FALSE,"
                + "reset_token VARCHAR(255),"
                + "reset_token_expiry TIMESTAMP"
                + ")");

            // Create default admin user if not exists
            String checkAdmin = "SELECT COUNT(*) FROM admins WHERE username = 'admin'";
            ResultSet rs = stmt.executeQuery(checkAdmin);
            rs.next();
            if (rs.getInt(1) == 0) {
                String hashedPassword = PasswordUtil.hashPassword("admin");
                stmt.executeUpdate("INSERT INTO admins (username, password, email, full_name, is_active, is_super_admin) " +
                    "VALUES ('admin', '" + hashedPassword + "', 'admin@focusfriend.com', 'System Administrator', true, true)");
            }

            // Create default user if not exists
            String checkUser = "SELECT COUNT(*) FROM users WHERE username = '123'";
            rs = stmt.executeQuery(checkUser);
            rs.next();
            if (rs.getInt(1) == 0) {
                String hashedUserPassword = PasswordUtil.hashPassword("123");
                stmt.executeUpdate("INSERT INTO users (username, password, email, full_name, is_active) " +
                    "VALUES ('123', '" + hashedUserPassword + "', 'user@focusfriend.com', 'Default User', true)");
            }

            // Sessions table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS sessions ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "user_id INT NOT NULL,"
                + "start_time DATETIME NOT NULL,"
                + "end_time DATETIME,"
                + "description VARCHAR(255),"
                + "duration INT,"
                + "status VARCHAR(20),"
                + "FOREIGN KEY (user_id) REFERENCES users(id)"
                + ")");
            // Goals table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS goals ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "user_id INT NOT NULL,"
                + "title VARCHAR(100) NOT NULL,"
                + "description TEXT,"
                + "target_date DATE,"
                + "target_minutes INT,"
                + "completed_minutes INT DEFAULT 0,"
                + "status VARCHAR(20),"
                + "FOREIGN KEY (user_id) REFERENCES users(id)"
                + ")");
            // Chat messages table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS chat_messages ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "user_id INT NOT NULL,"
                + "message TEXT,"
                + "is_ai_response BOOLEAN,"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                + "FOREIGN KEY (user_id) REFERENCES users(id)"
                + ")");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 