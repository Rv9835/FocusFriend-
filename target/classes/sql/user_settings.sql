CREATE TABLE IF NOT EXISTS user_settings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    push_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    sound_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    theme VARCHAR(20) NOT NULL DEFAULT 'light',
    default_focus_duration INT NOT NULL DEFAULT 25,
    default_break_duration INT NOT NULL DEFAULT 5,
    long_break_duration INT NOT NULL DEFAULT 15,
    sessions_until_long_break INT NOT NULL DEFAULT 4,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_settings (user_id)
); 