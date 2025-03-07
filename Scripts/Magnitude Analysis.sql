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


  --Rank countries having most number of players
select *,
RANK() over(order by NoOfPlayers DESC) 'Rank'
from(
SELECT 
Country,
COUNT(distinct UserID) 'NoOfPlayers' 
from #quickaccess
group by Country)t1;


--Show age of player playing a certain game
SELECT
GameID,
GameName,
(Age)  'Average Age'
from 
#quickaccess
group by GameID,GameName;



--TOTAL TIME SPENT BY PLAYER ON A GAME AS PER RECORDS

 select 
	GameID,
	UserID,
	UserName,
	SUM(DATEDIFF(MINUTE,SessionStart,SessionEnd)) 'SessionDuration'
	--,DATEDIFF(HOUR,RegistrationDate,SessionStart) 'DedicatedTime'
 from #quickaccess
 GROUP BY GameID,
		  UserID,
		  UserName;

--DAU
select
	GameID,
	GameName,
	DATETRUNC(DAy,SessionStart) 'Daily',
	COUNT(UserID) 'SESSIONCount',
	COUNT(distinct UserID) 'USERCount'
from #quickaccess
GROUP BY GameID,GameName,DATETRUNC(DAy,SessionStart)
ORDER BY GameID,DATETRUNC(DAy,SessionStart);