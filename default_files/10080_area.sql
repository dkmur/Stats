-- Weekly aggregation of mon data


INSERT INTO stats_area (Datetime,RPL, TRPL, Area, Fence, Spawnpoints,Mons_all, MonsIV, Iv100, Iv0, MinutesLeft, numWi_En,timeWi_En,numNeSp_Wi,timeNeSp_Wi,numNeSp_En,timeNeSp_En,numNeCl_Wi,timeNeCl_Wi,numNeCl_En,timeNeCl_En)
SELECT
concat(date(curdate() - interval weekday(curdate()) + 7 day),' ','00:00:00'),
'10080', 
sum(TRPL),
Area,
Fence,
sum(Spawnpoints),
sum(Mons_all),
sum(MonsIV),
sum(Iv100),
sum(Iv0),
sum(MinutesLeft),
sum(numWi_En),
sum(timeWi_En),
sum(numNeSp_Wi),
sum(timeNeSp_Wi),
sum(numNeSp_En),
sum(timeNeSp_En),
sum(numNeCl_Wi),
sum(timeNeCl_Wi),
sum(numNeCl_En),
sum(timeNeCl_En)

from stats_area

where
date(Datetime) >=  date(curdate() - interval weekday(curdate()) + 7 day) and
RPL = 1440
group by Area,Fence
;
