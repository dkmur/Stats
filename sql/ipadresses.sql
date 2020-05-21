use pogodb

select "Device IP" as '';
select
date as 'date      ', rpad(origin,13," ") as 'origin       ', ip as 'IP'
from ATVdetails

where
date = curdate() - interval XXA day

order by origin
;
