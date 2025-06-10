CREATE TABLE IF NOT EXISTS achievements (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    icon VARCHAR(255) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    unlocked_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert default achievements
INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'First Focus',
    'Complete your first focus session',
    'first-focus.png',
    10,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'First Focus'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Focus Master',
    'Complete 10 focus sessions',
    'focus-master.png',
    50,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Focus Master'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Task Champion',
    'Complete 20 tasks',
    'task-champion.png',
    75,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Task Champion'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Consistency King',
    'Complete focus sessions for 7 consecutive days',
    'consistency-king.png',
    100,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Consistency King'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Early Bird',
    'Complete a focus session before 8 AM',
    'early-bird.png',
    25,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Early Bird'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Night Owl',
    'Complete a focus session after 10 PM',
    'night-owl.png',
    25,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Night Owl'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Marathon Runner',
    'Complete a focus session longer than 60 minutes',
    'marathon-runner.png',
    50,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Marathon Runner'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Task Master',
    'Complete all tasks for a day',
    'task-master.png',
    30,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Task Master'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Focus Legend',
    'Complete 100 focus sessions',
    'focus-legend.png',
    200,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Focus Legend'
);

INSERT INTO achievements (user_id, name, description, icon, points, created_at, updated_at)
SELECT 
    u.id,
    'Task Legend',
    'Complete 100 tasks',
    'task-legend.png',
    200,
    NOW(),
    NOW()
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM achievements a 
    WHERE a.user_id = u.id AND a.name = 'Task Legend'
); 