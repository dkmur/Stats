-- Weekly aggregation of spawnpoint data

insert ignore into stats_area_spawnpoint (datetime,rpl,area,fence,spawnpoints,eventSpawns,verified,def15,not15,seen,1d,3d,5d,7d,14d)
select
concat(date(curdate() - interval weekday(curdate()) + 7 day),' ','00:00:00'),
'10080',
area,
fence,
max(spawnpoints),
max(eventSpawns),
max(verified),
max(def15),
max(not15),
max(seen),
min(1d),
min(3d),
min(5d),
min(7d),
min(14d)

from stats_area_spawnpoint
where date(datetime) >=  date(curdate() - interval weekday(curdate()) + 7 day) and RPL = 1440
group by area,fence
;
