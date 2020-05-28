use pogodb

select "RemoteGpsController settings" as '';
select
date as 'date      ', rpad(ifnull(RGC_auth_username,'no_data '),8," ") as 'username', rpad(ifnull(RGC_auth_password,'no_data '),11," ") as 'password   ', rpad(ifnull(RGC_websocket_uri,'no_data '),37," ") as 'websocket_url                     ', rpad(ifnull(RGC_boot_delay,'no_data '),10," ") as 'boot_delay', count(origin) as '#devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, RGC_auth_username, RGC_auth_password, RGC_websocket_uri, RGC_boot_delay
;

