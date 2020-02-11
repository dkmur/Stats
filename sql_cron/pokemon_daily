-- daily
-- add to pokemon_history
insert ignore into mons.pokemon_history select * from mons.pokemon_history_temp where date(first_scanned) = curdate() - interval 1 day;

-- delete from pokemon_history_temp
delete from mons.pokemon_history_temp where date(first_scanned) = curdate() - interval 1 day;
