-- hourly
-- Cleanup of pokemon
-- delete from rmdb.pokemon
-- where
-- first_scanned < now() - interval 1 hour
-- ;

-- append shiny stats
Create TEMPORARY TABLE rmdb.tmp100
AS(
select distinct(cast(b.type_id as unsigned)) as type_id, b.is_shiny
from rmdb.trs_stats_detect_raw b
where b.is_shiny = 1
);

update pogodb.pokemon_history_temp a, rmdb.tmp100 b
set a.is_shiny = b.is_shiny
where  a.encounter_id = b.type_id
;

drop table rmdb.tmp100;

-- Cleanup of trs_stats_detect_raw
-- delete from rmdb.trs_stats_detect_raw
-- where
-- from_unixtime(timestamp_scan) < now() - interval 1 hour
-- ;

-- Cleanup of trs_stats_location_raw
-- delete from rmdb.trs_stats_location_raw
-- where
-- from_unixtime(period) < now() - interval 1 hour
-- ;