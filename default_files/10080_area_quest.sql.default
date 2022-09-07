-- Hourly aggregation of quest data

select @period := concat(date(curdate() - interval weekday(curdate()) + 7 day),' ','00:00:00');

INSERT INTO stats_area_quest (Datetime,RPL, Area, Fence, stops, AR, nonAR, ARcum, nonARcum)
SELECT
@period,
'10080',
Area,
Fence,
sum(stops),
sum(AR),
sum(nonAR),
sum(ARcum),
sum(nonARcum)

from stats_area_quest
where Datetime >= date(curdate() - interval weekday(curdate()) + 7 day) and RPL = 1440
group by Area,Fence
;
