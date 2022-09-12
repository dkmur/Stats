-- Hourly aggregation of quest data

select @period := concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));

INSERT INTO stats_area_quest (Datetime,RPL, Area, Fence, stops, AR, nonAR, ARcum, nonARcum)
SELECT
@period,
'60',
Area,
Fence,
max(stops),
sum(AR),
sum(nonAR),
max(ARcum),
max(nonARcum)

from stats_area_quest
where
Datetime >= @period and
Datetime < @stop and
RPL = 15
group by Area,Fence
;
