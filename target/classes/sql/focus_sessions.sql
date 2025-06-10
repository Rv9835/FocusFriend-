CREATE TABLE IF NOT EXISTS focus_sessions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    type VARCHAR(20) NOT NULL,
    duration INT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
); 