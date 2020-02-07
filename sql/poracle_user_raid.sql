select 
rpad(a.name,14,' ') as 'Name          ', b.pokemon_id, b.level, b.form, b.park, b.distance, b.team
from 
poracle.humans a, poracle.raid b 
where 
a.name = 'XXA' and
a.id = b.id
;
