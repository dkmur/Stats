-- Settings
select @period := concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 900) * 900));
select @rpl := '1440';

-- Process data
insert ignore into stats_area_spawnpoint (datetime,rpl,area,fence,spawnpoints,eventSpawns,verified,def15,not15,seen,1d,3d,5d,7d,14d)
select
@period,
@rpl,
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
where datetime like concat(left(from_unixtime(@period),10),'%') and RPL = 60
group by area,fence
;
