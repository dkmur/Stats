use pogodb

Create TEMPORARY TABLE pogodb.tmp400
AS(
select
date(first_scanned) as 'Date',
pokemon_id as 'Mon',
count(pokemon_id) as 'Scanned',
sum(is_shiny) as 'Shiny'

from pogodb.pokemon_history

where
date(first_scanned) >= curdate() - interval XXA day and
(seen_type = 'encounter' or seen_type = 'wild') and
pokemon_id = XXB

group by date(first_scanned)
);



select
Date as 'Date      ',
Mon,
Scanned,
Shiny,
concat('1:',round(Scanned/Shiny,0)) as 'odds',
round(100*Shiny/Scanned,4) as 'pct'
from pogodb.tmp400
;
select '';
select 'Period Total';
select '';
select
Mon,
sum(scanned) as 'scanned',
sum(Shiny) as 'shiny',
concat('1:',round(sum(Scanned)/sum(Shiny),0)) as 'odds',
round(100*sum(Shiny)/sum(Scanned),4) as 'pct'
from pogodb.tmp400
group by Mon
;


drop table pogodb.tmp400;
