select 
rpad(a.name,14,' ') as 'Name          ', rpad(b.gruntType,9,' ') as 'gruntType' , b.gender, b.distance
from 
poracle.humans a, poracle.incident b 
where 
a.name = 'XXA' and
a.id = b.id
;
