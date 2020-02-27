use pogodb

Create TEMPORARY TABLE pogodb.tmp400
AS(
select
b.Datetime  as 'Datetime',
round(sum(b.TRPL)/count(b.Worker),1) 'DevRPL',
count(b.worker) as 'worker'

from stats_worker b

where
b.RPL = XXB and
date(b.Datetime) >= curdate() - interval XXA day

group by b.Datetime
);

select 
date(a.Datetime) as 'Date      ',
time(a.Datetime) as 'Time    ',
a.RPL as 'RPL',
a.TRPL 'Trpl',
b.worker 'Workers',
b.DevRPL 'DevRPL',
count(Area) 'Areas',
sum(Spawnpoints) as 'Spawns',
sum(Mons_all) as 'Mons',
sum(MonsIV) as 'IVmons',
sum(Mons_all)-sum(MonsIV) as  'nonIV',
round(sum(MonsIV)/sum(Mons_all)*100,2) as '%IV',
-- ifnull(sum(a.Spawndef15),0) as 'Spawn60',
-- ifnull(sum(a.SpawndefNot15),0) as 'Spawn30',
ifnull(round(100*sum(a.MinutesLeft)/((sum(a.Spawndef15) * 60)+(sum(a.SpawndefNot15) * 30)),1),0) as '%timeLeft'
from stats_area a, pogodb.tmp400 b

where
a.RPL = XXB and
date(a.Datetime) >= curdate() - interval XXA day and
a.Datetime = b.Datetime

group by a.Datetime
;

drop table pogodb.tmp400;
