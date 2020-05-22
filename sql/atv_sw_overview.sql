use pogodb

select "ATV ROM" as '';
select
date as 'date      ', rpad(ifnull(rom,'no_data '),8," ") as 'rom     ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, rom
;

select "ATV ROM options" as '';
select
date as 'date      ', rpad(ifnull(pogo_update,'no_data '),11," ") as 'pogo_update', rpad(ifnull(pd_update,'no_data '),9," ") as pd_update, rpad(ifnull(rgc_update,'no_data '),10," ") as 'rgc_update', rpad(ifnull(pingreboot,'no_data '),10," ") as pinreboot, count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, pogo_update, pd_update, rgc_update, pingreboot
;

select "RemoteGpsController" as '';
select
date as 'date      ', rpad(ifnull(rgc,'no_data '),8," ") as'rgc     ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, rgc
;

select "PogoDroid" as '';
select
date as 'date      ', rpad(ifnull(pogodroid,'no_data'),8," ") as 'pogodroid', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, pogodroid
;

select "PokemonGo" as '';
select
date as 'date      ', rpad(ifnull(pogo,'no_data'),8," ") as 'pogo    ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, pogo
;

select "Magisk" as '';
select
date as 'date      ', rpad(ifnull(magisk,'no_data'),8," ") as 'magisk  ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, magisk
;

select "Magisk Modules" as '';
select
date as 'date      ', rpad(ifnull(magisk_modules,'no_data '),34," ") as 'magisk modules                    ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, magisk_modules
;

select "Average temperature" as '';
select
date as 'date      ', round(sum(temperature)/count(temperature),1) as 'temperature'
from ATVdetails

where
date = curdate() - interval XXA day

group by date
;
