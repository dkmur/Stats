-- Hourly aggregation of quest data

select @period := concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 86400) * 86400));

INSERT INTO stats_area_quest (Datetime,RPL, Area, Fence, stops, AR, nonAR, ARcum, nonARcum)
SELECT
@period,
'1440',
Area,
Fence,
max(stops),
sum(AR),
sum(nonAR),
max(ARcum),
max(nonARcum)

from stats_area_quest
where Datetime like concat(left(@Datetime,10),'%') and RPL = 60
group by Area,Fence
;
