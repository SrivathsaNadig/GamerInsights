-- Game Popularity by Player Count
SELECT *, RANK() OVER (ORDER BY NoOfPlayers DESC) 'Rank'
FROM (
    SELECT GameID, GameName, COUNT(DISTINCT UserID) 'NoOfPlayers' 
    FROM #quickaccess
    GROUP BY GameID, GameName
) t1;

-- Top Gaming Countries by Player Count
SELECT *, RANK() OVER (ORDER BY NoOfPlayers DESC) 'Rank'
FROM (
    SELECT Country, COUNT(DISTINCT UserID) 'NoOfPlayers' 
    FROM #quickaccess
    GROUP BY Country
) t1;

-- Average Player Age by Game
SELECT GameID, GameName, AVG(Age) 'Average Age'
FROM #quickaccess
GROUP BY GameID, GameName;

-- Total Playtime Per Player Per Game
SELECT GameID, UserID, UserName, 
       SUM(DATEDIFF(MINUTE, SessionStart, SessionEnd)) 'SessionDuration'
FROM #quickaccess
GROUP BY GameID, UserID, UserName;

-- Daily Active Users (DAU)
SELECT GameID, GameName, DATETRUNC(DAY, SessionStart) 'Daily',
       COUNT(UserID) 'SESSIONCount',
       COUNT(DISTINCT UserID) 'USERCount'
FROM #quickaccess
GROUP BY GameID, GameName, DATETRUNC(DAY, SessionStart)
ORDER BY GameID, DATETRUNC(DAY, SessionStart);

-- Total Revenue by Game
SELECT *, DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) 'Rank'
FROM (
    SELECT g.GameID, g.GameName, SUM(Amount) 'TotalRevenue'
    FROM Purchases p
    JOIN Games g ON p.GameID = g.GameID
    GROUP BY g.GameID, g.GameName
) t1;

-- Player Feedback & Game Ratings
SELECT g.GameID, g.GameName, 
       AVG(f.Score) AS 'AvgScore',
       COUNT(f.FeedbackID) AS 'TotalReviews',
       RANK() OVER (ORDER BY AVG(f.Score) DESC) AS 'Rank'
FROM Feedback f 
JOIN Games g ON g.GameID = f.GameID
GROUP BY g.GameID, g.GameName;

-- Cohort Analysis (User Retention)
SELECT DATETRUNC(MONTH, RegistrationDate) AS CohortMonth, 
       COUNT(DISTINCT UserID) AS NewUsers
FROM Users
GROUP BY DATETRUNC(MONTH, RegistrationDate)
ORDER BY CohortMonth;

-- Churn Rate Analysis (Inactive Users)
SELECT DATETRUNC(MONTH, LastLogin) AS LastActiveMonth, 
       COUNT(DISTINCT UserID) AS ActiveUsers
FROM Users
GROUP BY DATETRUNC(MONTH, LastLogin)
ORDER BY LastActiveMonth;

-- LTV (Lifetime Value) Analysis
SELECT UserID, SUM(Amount) / COUNT(DISTINCT UserID) AS 'LTV'
FROM Purchases
GROUP BY UserID;

--Devices Preferred to Play The Games
select 
GameID,GameName,
Device,
count(Device) 'NoOfUsers'
from #quickaccess
group by gameID,GameName,Device;