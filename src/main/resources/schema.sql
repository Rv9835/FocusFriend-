-- Create database if not exists
CREATE DATABASE IF NOT EXISTS focusfriend;
USE focusfriend;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User settings table
CREATE TABLE IF NOT EXISTS user_settings (
    user_id BIGINT PRIMARY KEY,
    focus_duration INT NOT NULL DEFAULT 25,
    short_break_duration INT NOT NULL DEFAULT 5,
    long_break_duration INT NOT NULL DEFAULT 15,
    sessions_until_long_break INT NOT NULL DEFAULT 4,
    auto_start_breaks BOOLEAN NOT NULL DEFAULT FALSE,
    auto_start_pomodoros BOOLEAN NOT NULL DEFAULT FALSE,
    desktop_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    sound_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    theme_color VARCHAR(7) NOT NULL DEFAULT '#4a90e2',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
    due_date TIMESTAMP,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Focus sessions table
CREATE TABLE IF NOT EXISTS focus_sessions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    duration BIGINT, -- in minutes
    type ENUM('FOCUS', 'SHORT_BREAK', 'LONG_BREAK') NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Achievements table
CREATE TABLE IF NOT EXISTS achievements (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon VARCHAR(50) NOT NULL,
    criteria_type ENUM('FOCUS_TIME', 'SESSIONS_COMPLETED', 'TASKS_COMPLETED', 'STREAK') NOT NULL,
    criteria_value INT NOT NULL
);

-- User achievements table
CREATE TABLE IF NOT EXISTS user_achievements (
    user_id BIGINT NOT NULL,
    achievement_id BIGINT NOT NULL,
    earned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
);

-- Insert default achievements
INSERT INTO achievements (name, description, icon, criteria_type, criteria_value) VALUES
('Focus Master', 'Complete 100 focus sessions', 'fa-fire', 'SESSIONS_COMPLETED', 100),
('Time Warrior', 'Accumulate 40 hours of focus time', 'fa-clock', 'FOCUS_TIME', 2400),
('Task Master', 'Complete 50 tasks in a week', 'fa-check-circle', 'TASKS_COMPLETED', 50),
('Consistency King', 'Maintain a 7-day streak of focus sessions', 'fa-star', 'STREAK', 7),
('Early Bird', 'Complete 5 focus sessions before 9 AM', 'fa-sun', 'SESSIONS_COMPLETED', 5),
('Night Owl', 'Complete 5 focus sessions after 9 PM', 'fa-moon', 'SESSIONS_COMPLETED', 5),
('Speed Demon', 'Complete 10 tasks in a single day', 'fa-bolt', 'TASKS_COMPLETED', 10),
('Marathon Runner', 'Complete a 2-hour focus session', 'fa-running', 'FOCUS_TIME', 120),
('Task Ninja', 'Complete 100 tasks', 'fa-user-ninja', 'TASKS_COMPLETED', 100),
('Focus Legend', 'Complete 500 focus sessions', 'fa-crown', 'SESSIONS_COMPLETED', 500);

-- Admins table
CREATE TABLE IF NOT EXISTS admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_super_admin BOOLEAN DEFAULT FALSE
);

-- Insert default admin user
INSERT INTO admins (username, password, email, full_name, is_super_admin)
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'admin@focusfriend.com', 'System Administrator', TRUE);

-- Sessions table (existing)
CREATE TABLE IF NOT EXISTS sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NULL,
    description TEXT,
    duration INT,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Goals table (existing)
CREATE TABLE IF NOT EXISTS goals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    target_date DATE NOT NULL,
    target_minutes INT NOT NULL,
    completed_minutes INT DEFAULT 0,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Chat messages table
CREATE TABLE IF NOT EXISTS chat_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    is_ai_response BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
); 