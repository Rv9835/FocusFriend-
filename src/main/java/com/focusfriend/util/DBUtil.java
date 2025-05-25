package com.focusfriend.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/focusfriend";
    private static final String USER = "root";
    private static final String PASSWORD = "Window7lite";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
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