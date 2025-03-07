-- DAILY ACTIVE USERS (DAU)
SELECT
    DATETRUNC(DAY, s.session_start) AS "date",
    COUNT(DISTINCT user_id) AS "DAU"
FROM [sessions] s
GROUP BY DATETRUNC(DAY, s.session_start)
ORDER BY 1;

-- MONTHLY ACTIVE USERS (MAU)
SELECT
    DATETRUNC(MONTH, s.session_start) AS "date",
    COUNT(DISTINCT user_id) AS "MAU"
FROM [sessions] s
GROUP BY DATETRUNC(MONTH, s.session_start)
ORDER BY 1;

-- AVERAGE SESSION LENGTH
SELECT 
    AVG(DATEDIFF(HOUR, session_start, session_end)) AS "Average Session Length"
FROM sessions;

-- LEVEL COMPLETION RATE
SELECT 
    COUNT(DISTINCT user_id) * 100.0 / (SELECT COUNT(*) FROM users) AS "Level Completion Rate"
FROM events
WHERE event_type = 'level_completion';

-- LIST TABLES IN THE DATABASE
SELECT name AS "Table Name"
FROM sys.tables;

-- CHURN RATE (for users inactive for 25 days)
-- Option 1
SELECT 
    COUNT(DATEDIFF(DAY, last_active, GETDATE())) / (SELECT COUNT(user_id) * 0.01 FROM users) AS "Churn Rate"
FROM users
WHERE DATEDIFF(DAY, last_active, GETDATE()) >= 25;

-- Option 2 (more standard approach)
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users) AS "Churn Rate"
FROM users
WHERE last_active < DATEADD(DAY, -25, GETDATE());

-- RETENTION RATE (sessions where session_end > session_start)
SELECT *
FROM Sessions
WHERE session_end > session_start;
