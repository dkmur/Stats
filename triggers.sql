CREATE trigger pokemoncopy
after insert
on pokemon for each row
insert into mons.pokemon_history_temp (encounter_id,spawnpoint_id,pokemon_id,latitude,longitude,disappear_time,individual_attack,individual_defense,individual_stamina,move_1,move_2,cp,cp_multiplier,weight,height,gender,form,costume,catch_prob_1,catch_prob_2,catch_prob_3,rating_attack,rating_defense,weather_boosted_condition,last_modified) 
values (new.encounter_id,new.spawnpoint_id,new.pokemon_id,new.latitude,new.longitude,new.disappear_time,new.individual_attack,new.individual_defense,new.individual_stamina,new.move_1,new.move_2,new.cp,new.cp_multiplier,new.weight,new.height,new.gender,new.form,new.costume,new.catch_prob_1,new.catch_prob_2,new.catch_prob_3,new.rating_attack,new.rating_defense,new.weather_boosted_condition,new.last_modified)
;

CREATE trigger pokemonupdate
after update
on pokemon for each row
update mons.pokemon_history_temp set
mons.pokemon_history_temp.pokemon_id=new.pokemon_id,
mons.pokemon_history_temp.disappear_time=new.disappear_time,
mons.pokemon_history_temp.individual_attack=new.individual_attack,
mons.pokemon_history_temp.individual_defense=new.individual_defense,
mons.pokemon_history_temp.individual_stamina=new.individual_stamina,
mons.pokemon_history_temp.move_1=new.move_1,
mons.pokemon_history_temp.move_2=new.move_2,
mons.pokemon_history_temp.cp=new.cp,
mons.pokemon_history_temp.weight=new.weight,
mons.pokemon_history_temp.height=new.height,
mons.pokemon_history_temp.gender=new.gender,
mons.pokemon_history_temp.form=new.form,
mons.pokemon_history_temp.costume=new.costume,
mons.pokemon_history_temp.weather_boosted_condition=new.weather_boosted_condition,
mons.pokemon_history_temp.last_modified=new.last_modified
where
mons.pokemon_history_temp.encounter_id=new.encounter_id
;
