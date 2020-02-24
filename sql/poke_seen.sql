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
pokemon_id = XXB

group by date(first_scanned)
);



select
Date as 'Date      ', Mon, Scanned, Shiny
from pogodb.tmp400
;
select '';
select 'Period Total';
select '';
select
Mon,
sum(scanned) as 'scanned',
sum(Shiny) as 'shiny'
from pogodb.tmp400
group by Mon
;


drop table pogodb.tmp400;
