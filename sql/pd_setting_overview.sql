use pogodb

select "PogoDroid settings" as '';
select
date as 'date      ', rpad(ifnull(PD_auth_username,'no_data '),8," ") as 'username', rpad(ifnull(PD_auth_password,'no_data '),11," ") as 'password   ', rpad(ifnull(PD_auth_token,'no_data '),18," ") as 'auth_token        ', rpad(ifnull(PD_post_destination,'no_data '),37," ") as 'post_destination                     ', rpad(ifnull(PD_boot_delay,'no_data '),10," ") as 'boot_delay', rpad(ifnull(PD_injection_delay,'no_data '),15," ") as 'injection_delay', count(origin) as '#devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, PD_auth_username, PD_auth_password, PD_auth_token, PD_post_destination, PD_boot_delay, PD_injection_delay
;

