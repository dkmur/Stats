use pogodb

select "Device IP (eth)" as '';
select
date as 'date      ', rpad(origin,13," ") as 'origin       ', gmail as 'gmail'
from ATVdetails

where
date = curdate() - interval XXA day

order by origin
;
