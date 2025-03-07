-- Drop existing tables if they exist
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE Events;
IF OBJECT_ID('dbo.Sessions', 'U') IS NOT NULL DROP TABLE Sessions;
IF OBJECT_ID('dbo.Game_Levels', 'U') IS NOT NULL DROP TABLE Game_Levels;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE Users;

-- Create Tables
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    signup_date DATE NOT NULL,
    last_active DATE NOT NULL
);

CREATE TABLE Sessions (
    session_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    session_start DATETIME NOT NULL,
    session_end DATETIME NOT NULL
);

CREATE TABLE Game_Levels (
    level_id INT IDENTITY(1,1) PRIMARY KEY,
    level_name NVARCHAR(255) NOT NULL
);

CREATE TABLE Events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    event_type NVARCHAR(50) CHECK (event_type IN ('level_completion', 'purchase', 'login')),
    level_id INT FOREIGN KEY REFERENCES Game_Levels(level_id),
    event_time DATETIME NOT NULL
);

-- Insert complex and large dummy data
SET NOCOUNT ON;

DECLARE @num_users INT = 100000;
DECLARE @num_sessions INT = 500000;
DECLARE @num_events INT = 1000000;

-- Insert Users
DECLARE @i INT = 1;
WHILE @i <= @num_users
BEGIN
    INSERT INTO Users (signup_date, last_active)
    VALUES (DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE()), 
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()));
    SET @i = @i + 1;
END;

-- Insert Sessions
SET @i = 1;
WHILE @i <= @num_sessions
BEGIN
    INSERT INTO Sessions (user_id, session_start, session_end)
    VALUES ((ABS(CHECKSUM(NEWID())) % @num_users + 1), 
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()), 
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()) + CAST(ABS(CHECKSUM(NEWID()) % 7200) AS FLOAT) / 3600);
    SET @i = @i + 1;
END;

-- Insert Game Levels
IF NOT EXISTS (SELECT 1 FROM Game_Levels)
BEGIN
    INSERT INTO Game_Levels (level_name) VALUES 
    ('Level 1'), ('Level 2'), ('Level 3'), ('Level 4'), ('Level 5');
END;

-- Insert Events
SET @i = 1;
WHILE @i <= @num_events
BEGIN
    INSERT INTO Events (user_id, event_type, level_id, event_time)
    VALUES ((ABS(CHECKSUM(NEWID())) % @num_users + 1),
            (CASE ABS(CHECKSUM(NEWID())) % 3 WHEN 0 THEN 'level_completion' WHEN 1 THEN 'purchase' ELSE 'login' END),
            (ABS(CHECKSUM(NEWID())) % 5 + 1),
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()));
    SET @i = @i + 1;
END;
