use pogodb

select "Average temperature" as '';
select
date as 'date      ', round(sum(temperature)/count(temperature),1) as 'temperature'
from ATVdetails

where
date = curdate() - interval XXA day

group by date
;

select "High 5" as '';
select
date as 'date      ', rpad(origin,13," ") as 'origin       ', temperature
from ATVdetails

where
date = curdate() - interval XXA day

order by temperature DESC
limit 5
;

select "Low 5" as '';
select
date as 'date      ', rpad(origin,13," ") as 'origin      ', temperature
from ATVdetails

where
date = curdate() - interval XXA day and
temperature is not NULL and
temperature <> ''

order by temperature ASC
limit 5
;

select "By temperature" as '';
select
date as 'date      ', temperature, count(origin) as '#devices' 
from ATVdetails

where
date = curdate() - interval XXA day

group by date, temperature
;
