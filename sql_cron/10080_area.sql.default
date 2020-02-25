INSERT INTO pogodb.stats_area (Datetime,RPL, TRPL, Area, Spawnpoints,Mons_all, Mons_nonIV, MonsIV, Iv100, Iv0, MinutesLeft, Spawndef15, SpawndefNot15,  Raid_Egg)
select
concat(date(curdate() - interval weekday(curdate()) + 7 day),' ','00:00:00'),
'10080', 
sum(a.TRPL),
a.Area,
sum(a.Spawnpoints),
sum(a.Mons_all),
sum(a.Mons_nonIV),
sum(a.MonsIV),
sum(Iv100),
sum(Iv0),
sum(MinutesLeft),
sum(Spawndef15),
sum(SpawndefNot15),
sum(Raid_Egg)

from pogodb.stats_area a

where 
date(a.Datetime) >=  date(curdate() - interval weekday(curdate()) + 7 day) and a.RPL = 1440

group by a.Area
;
