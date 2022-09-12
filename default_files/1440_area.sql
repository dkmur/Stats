-- Daily aggregation of mon data

select @period := concat(date(now() - interval 1500 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1500 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600));


INSERT INTO stats_area (Datetime,RPL, TRPL, Area, Fence, Spawnpoints,Mons_all, MonsIV, Iv100, Iv0, MinutesLeft, numWi_En,timeWi_En,numNeSp_Wi,timeNeSp_Wi,numNeSp_En,timeNeSp_En,numNeCl_Wi,timeNeCl_Wi,numNeCl_En,timeNeCl_En)
SELECT
@period,
'1440', 
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
Datetime >= @period and
Datetime < @stop and
RPL = 60
group by Area,Fence
;
