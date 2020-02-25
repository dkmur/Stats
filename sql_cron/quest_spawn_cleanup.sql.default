-- daily cleanup added spawns during quest hours
-- add to backup db
insert ignore into pogodb.spawn_unused (spawnpoint,latitude,longitude,spawndef,earliest_unseen,last_scanned,first_detection,last_non_scanned,calc_endminsec)
select spawnpoint,latitude,longitude,spawndef,earliest_unseen,last_scanned,first_detection,last_non_scanned,calc_endminsec
from rmdb.trs_spawn
where
date(first_detection) = curdate() and
time(first_detection) >= '02:00:00' and
time(first_detection) <= '06:00:00'
;
-- remove from trs_spawn
delete
from rmdb.trs_spawn
where
date(first_detection) = curdate() and
time(first_detection) >= '02:00:00' and
time(first_detection) <= '06:00:00'
;

-- daily cleanup spawns not seen for 5 days
-- add to backup db
insert ignore into pogodb.spawn_unused (spawnpoint,latitude,longitude,spawndef,earliest_unseen,last_scanned,first_detection,last_non_scanned,calc_endminsec)
select spawnpoint,latitude,longitude,spawndef,earliest_unseen,last_scanned,first_detection,last_non_scanned,calc_endminsec
from rmdb.trs_spawn
where
date(last_non_scanned) < curdate() - interval 5 day
;
-- remove backed up
delete
from rmdb.trs_spawn
where
date(last_non_scanned) < curdate() - interval 5 day
;

-- daily cleanup first_detection 5 days ago and last_scanned is NULL
-- add to backup db
insert ignore into pogodb.spawn_unused (spawnpoint,latitude,longitude,spawndef,earliest_unseen,last_scanned,first_detection,last_non_scanned,calc_endminsec)
select spawnpoint,latitude,longitude,spawndef,earliest_unseen,last_scanned,first_detection,last_non_scanned,calc_endminsec
from rmdb.trs_spawn
where
date(first_detection) < curdate - interval 5 day and last_scanned is NULL;
;
-- remove backed up
delete
from rmdb.trs_spawn
where
date(first_detection) < curdate - interval 5 day and last_scanned is NULL;
;
