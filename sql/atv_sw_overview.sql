use pogodb

select "ATV ROM" as '';
select
date as 'date      ', rpad(rom,8," ") as 'rom     ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, rom
;

select "ATV RemoteGpsController" as '';
select
date as 'date      ', rpad(rgc,8," ") as'rgc     ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, rgc
;

select "ATV PogoDroid" as '';
select
date as 'date      ', rpad(pogodroid,8," ") as 'pogodroid', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, pogodroid
;

select "ATV PokemonGo" as '';
select
date as 'date      ', rpad(pogo,8," ") as 'pogo    ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, pogo
;

select "ATV Magisk" as '';
select
date as 'date      ', rpad(magisk,8," ") as 'magisk  ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, magisk
;

select "ATV Magisk Modules" as '';
select
date as 'date      ', rpad(magisk_modules,34," ") as 'magisk modules                    ', count(origin) as 'devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, magisk_modules
;
