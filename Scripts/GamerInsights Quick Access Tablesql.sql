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
    [Platform],
    [AchievementsUnlocked],
    [LastLogin],
    [TotalPlayTime],
    [SessionID], 
    [SessionStart], 
    [SessionEnd], 
    [SessionLength],
    [SessionType], 
    [LevelReached], 
    [Publisher], 
    [Rating], 
    [ReleaseDate], 
    [Genre], 
    [Developer]
INTO #quickaccess
FROM Users u 
LEFT JOIN Sessions s ON u.UserID = s.UserID
RIGHT JOIN Games g ON g.GameID = s.GameID;

 --Rank games having most number of players
 select *,
 RANK() over(order by NoOfPlayers DESC) 'Rank'
 from(
 SELECT 
 GameID,
 GameName,
 COUNT(distinct UserID) 'NoOfPlayers' 
 from #quickaccess
 group by GameID,GameName)t1;


 select * from #quickaccess;


  --Rank countries having most number of players
 select *,
 RANK() over(order by NoOfPlayers DESC) 'Rank'
 from(
 SELECT 
 Country,
 COUNT(distinct UserID) 'NoOfPlayers' 
 from #quickaccess
 group by Country)t1;


--Show games and gender distribution
SELECT 
GameID,
GameName
from #quickaccess
/*Yet To Be Coded