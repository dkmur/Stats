-- daily
-- add to pokemon_history
insert ignore into pogodb.pokemon_history select * from pogodb.pokemon_history_temp where date(first_scanned) = curdate() - interval 1 day;

-- delete from pokemon_history_temp
delete from pogodb.pokemon_history_temp where date(first_scanned) = curdate() - interval 1 day;
