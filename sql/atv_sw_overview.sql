use pogodb

select "ATV architecture" as '';
select
datetime as 'datetime  ', rpad(ifnull(arch,'no_data '),8," ") as 'rom     ', count(origin) as 'devices'
from ATVdetails

where
date(datime) = curdate() - interval XXA day

group by datetime, arch
;

select "ATV ROM" as '';
select
datetime as 'datetime  ', rpad(ifnull(rom,'no_data '),8," ") as 'rom     ', count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, rom
;

select "ATV ROM options" as '';
select
datetime as 'datetime  ', rpad(ifnull(pogo_update,'no_data '),11," ") as 'pogo_update', rpad(ifnull(pd_update,'no_data '),9," ") as pd_update, rpad(ifnull(rgc_update,'no_data '),10," ") as 'rgc_update', rpad(ifnull(pingreboot,'no_data '),10," ") as pinreboot, count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, pogo_update, pd_update, rgc_update, pingreboot
;

select "RemoteGpsController" as '';
select
datetime as 'datetime  ', rpad(ifnull(rgc,'no_data '),8," ") as'rgc     ', count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, rgc
;

select "PogoDroid" as '';
select
datetime as 'datetime  ', rpad(ifnull(pogodroid,'no_data'),8," ") as 'pogodroid', count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, pogodroid
;

select "PokemonGo" as '';
select
datetime as 'datetime  ', rpad(ifnull(pogo,'no_data'),8," ") as 'pogo    ', count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, pogo
;

select "Magisk" as '';
select
datetime as 'datetime  ', rpad(ifnull(magisk,'no_data'),8," ") as 'magisk  ', count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, magisk
;

select "Magisk Modules" as '';
select
datetime as 'datetime  ', rpad(ifnull(magisk_modules,'no_data '),34," ") as 'magisk modules                    ', count(origin) as 'devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, magisk_modules
;

select "Average temperature" as '';
select
date(datetime) as 'datetime  ', round(sum(temperature)/count(temperature),1) as 'temperature'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime
;
