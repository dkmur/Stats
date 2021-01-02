use pogodb

select "Average temperature" as '';
select
datetime as 'datetime  ', round(sum(temperature)/count(temperature),1) as 'temperature'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime
;

select "High 5" as '';
select
datetime as 'datetime  ', rpad(origin,13," ") as 'origin       ', temperature
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

order by temperature DESC
limit 5
;

select "Low 5" as '';
select
datetime as 'datetime  ', rpad(origin,13," ") as 'origin      ', temperature
from ATVdetails

where
date(datetime) = curdate() - interval XXA day and
temperature is not NULL and
temperature <> ''

order by temperature ASC
limit 5
;

select "By temperature" as '';
select
datetime as 'datetime  ', rpad(ifnull(temperature,'no_data'),11," ") as 'temperature', count(origin) as '#devices' 
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, temperature
;
