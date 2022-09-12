-- Settings
select @period := concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 900) * 900));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl := '60';

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
where
Datetime >= @period and
Datetime < @stop and
RPL = 15
group by area,fence
;
