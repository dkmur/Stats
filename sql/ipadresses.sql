use pogodb

select "Device IP" as '';
select
datetime as 'datetime  ', rpad(origin,13," ") as 'origin       ', ifnull(ip,'no_data') as 'IP'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

order by origin
;
