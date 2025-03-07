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