CREATE trigger pokemoncopy
after insert
on pokemon for each row
insert into pogodb.pokemon_history_temp (encounter_id,spawnpoint_id,pokemon_id,latitude,longitude,disappear_time,individual_attack,individual_defense,individual_stamina,move_1,move_2,cp,cp_multiplier,weight,height,gender,form,costume,catch_prob_1,catch_prob_2,catch_prob_3,rating_attack,rating_defense,weather_boosted_condition,last_modified) 
values (new.encounter_id,new.spawnpoint_id,new.pokemon_id,new.latitude,new.longitude,new.disappear_time,new.individual_attack,new.individual_defense,new.individual_stamina,new.move_1,new.move_2,new.cp,new.cp_multiplier,new.weight,new.height,new.gender,new.form,new.costume,new.catch_prob_1,new.catch_prob_2,new.catch_prob_3,new.rating_attack,new.rating_defense,new.weather_boosted_condition,new.last_modified)
;

CREATE trigger pokemonupdate
after update
on pokemon for each row
update pogodb.pokemon_history_temp set
pogodb.pokemon_history_temp.pokemon_id=new.pokemon_id,
pogodb.pokemon_history_temp.disappear_time=new.disappear_time,
pogodb.pokemon_history_temp.individual_attack=new.individual_attack,
pogodb.pokemon_history_temp.individual_defense=new.individual_defense,
pogodb.pokemon_history_temp.individual_stamina=new.individual_stamina,
pogodb.pokemon_history_temp.move_1=new.move_1,
pogodb.pokemon_history_temp.move_2=new.move_2,
pogodb.pokemon_history_temp.cp=new.cp,
pogodb.pokemon_history_temp.weight=new.weight,
pogodb.pokemon_history_temp.height=new.height,
pogodb.pokemon_history_temp.gender=new.gender,
pogodb.pokemon_history_temp.form=new.form,
pogodb.pokemon_history_temp.costume=new.costume,
pogodb.pokemon_history_temp.weather_boosted_condition=new.weather_boosted_condition,
pogodb.pokemon_history_temp.last_modified=new.last_modified
where
pogodb.pokemon_history_temp.encounter_id=new.encounter_id
;
