use pogodb

select "Device PD ID" as '';
select
datetime as 'datetime  ', rpad(origin,13," ") as 'origin       ', ifnull(PD_auth_id,'no_data') as 'auth_id'
from ATVdetails

where
date = curdate() - interval XXA day

order by origin
;
