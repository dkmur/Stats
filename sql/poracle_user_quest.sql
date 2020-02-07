select 
rpad(a.name,14,' ') as 'Name          ', b.reward as 'Qrew', b.reward_type as 'QrewT', b.shiny as 'Qshiny', b.distance as 'Qdist'
from 
poracle.humans a, poracle.quest b 
where 
a.name = 'XXA' and
a.id = b.id
;
