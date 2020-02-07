select 
rpad(a.name,14,' ') as 'Name          ', b.raid_level, b.park, b.distance, b.team
from 
poracle.humans a, poracle.egg b 
where 
a.name = 'XXA' and
a.id = b.id
;
