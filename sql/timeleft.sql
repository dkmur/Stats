use pogodb

Create TEMPORARY TABLE pogodb.tmp400
AS(
select
b.Datetime  as 'Datetime',
round(sum(b.TRPL)/count(b.Worker),1) 'DevRPL',
count(b.Worker) as 'Worker'

from stats_worker b, Area c

where
b.RPL = XXB and
date(b.Datetime) >= curdate() - interval XXA day and
c.Area = 'XXC' and
c.Origin = b.Worker

group by b.Datetime
);




select 
date(a.Datetime) as 'Date      ',
time(a.Datetime) as 'Time    ',
a.RPL as 'RPL',
a.TRPL 'Trpl',
b.Worker 'Workers',
b.DevRPL 'DevRPL',
rpad(a.Area,8,' ') 'Area    ',
rpad(ifnull(AvgMinutesLeft,0),10,' ') as 'avgMinLeft',
ifnull(a.Spawndef15,0) as 'Spawn60',
ifnull(a.SpawndefNot15,0) as 'Spawn30',
round(100*w5/Mons_all,1) as '%5min',
round(100*w10/Mons_all,1) as '%10min',
round(100*w15/Mons_all,1) as '%15min',
round(100*w20/Mons_all,1) as '%20min',
ifnull(round(100*a.MinutesLeft/((a.Spawndef15 * 60)+(a.SpawndefNot15 * 30)),1),0) as '%timeLeft'
from stats_area a, pogodb.tmp400 b

where
a.RPL = XXB and
date(a.Datetime) >= curdate() - interval XXA day and
a.Area = 'XXC' and
a.Datetime = b.Datetime
;

drop table pogodb.tmp400;
