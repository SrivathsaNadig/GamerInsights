/*HERE, ANALYSIS AS PER KPIS WILL BE PERFORMED ON A COMPLEX AND A LARGER DATASET

THE DATA SYNTHESIZED HERE BELONGS TO ONLY ONE FICTIONAL GAME */


--DAILY ACTIVE USERS (DAU)

select
	datetrunc(DAY,s.session_start) 'date',
	COUNT(distinct user_id) 'DAU'
from [sessions] s 
group by datetrunc(DAY,s.session_start)
order by 1;

--MONTHLY ACTIVE USERS (DAU)

select
	datetrunc(MONTH,s.session_start) 'date',
	COUNT(distinct user_id) 'DAU'
from [sessions] s 
group by datetrunc(MONTH,s.session_start)
order by 1;

--Average Session Length
select avg(datediff(HOUR,session_start,session_end)) 'Average Session Length'
from sessions;

--Level Completion Rate
SELECT 
	count(distinct user_id)* 100/(select count(*) from users) 'Level Completion Rate This Banner'
FROM
	events
WHERE event_type = 'level_completion' ;

select name as tablenname from sys.tables


--CHURN RATE   (say 25 days)

select 
	count(datediff(day,last_active,GETDATE()))/(select count(user_id) *0.01 from users) 'churnrate'
from users
where 	datediff(day,last_active,GETDATE())>=25;

--OR

SELECT 
	COUNT(*) * 100 /(select count(*) from users) 'Churnrate'
FROM USERS 
	WHERE last_active < dateadd(DAY,-25,GETDATE())


-- Retention Rate

SELECT *
FROM Sessions
WHERE session_end > session_start;