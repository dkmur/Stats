use pogodb

select "Device IP (eth)" as '';
select
date as 'date      ', rpad(origin,13," ") as 'origin       ', eth0 as 'IP'
from ATVdetails

where
date = curdate() - interval XXA day

order by origin
;
