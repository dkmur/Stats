use pogodb

select "Device IP (eth)" as '';
select
datetime as 'datetime  ', rpad(origin,13," ") as 'origin       ', ifnull(gmail,'no_data') as 'gmail'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

order by origin
;
