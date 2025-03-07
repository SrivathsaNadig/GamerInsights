--GAME AND PLAYERS SESSION
SELECT 
    u.[UserID], 
    [UserName], 
    [Country], 
    [Age], 
    [Gender], 
    g.[GameID], 
    [GameName], 
    [RegistrationDate],
[Device],
[AchievementsUnlocked],
    [LastLogin],
    [TotalPlayTime],
    [SessionID], 
    [SessionStart], 
    [SessionEnd], 
    [SessionLength],
    [SessionType], 
    [LevelReached], 
    [ReleaseDate]
INTO #quickaccess
FROM Users u 
LEFT JOIN Sessions s ON u.UserID = s.UserID
RIGHT JOIN Games g ON g.GameID = s.GameID;



