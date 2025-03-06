USE GamingAnalytics;  -- Switch to your target database
SELECT name AS TableName FROM sys.tables;
-----------------------------------------------------------------------------------------
/*THIS SQL SCRIPT IS FOR THE ANALYST TO GET A FEEL OF THE DATA AND UNDERSTAND THE SCHEMA.
IT WILL CONSIST OF TABLE NAME AND A ROUGH DESCRIPTION OF THE TABLES.*/
-----------------------------------------------------------------------------------------
--TABLE NAME : 
--DEFINITION :

--TABLE NAME : FEEDBACK
--DEFINITION : TABLE WITH USERS AND THEIR FEEDBACKS ON GAMES
select * from Feedback;

--TABLE NAME : GAMES 
--DEFINITION : TABLE WITH GAMES WITH DETAILS AND STATS
select * from games;

--TABLE NAME : PURCHASES 
--DEFINITION : RECORDS OF TRANSACTION AND ITS DETAILS
select * from Purchases;

--TABLE NAME : SESSIONS 
--DEFINITION : RECORDS OF USER ACTIVITY ON A CERTAIN DATE
select * from Sessions;

--TABLE NAME : SOCIAL ENGAGEMENTS 
--DEFINITION : RECORDS OF USER ACTIVITY WITH OTHER PLAYERS
select * from SocialEngagements;


--TABLE NAME : USERS 
--DEFINITION : USERS'S PERSONAL DETAILS
select * from Users;