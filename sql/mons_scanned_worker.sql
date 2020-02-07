use pogodb

select 
date(datetime) as 'Date      ',
time(datetime) as 'Time    ',
RPL as 'RPL',
TRPL 'Trpl',
Tmon,
IVmon,
Mon,
round(IVmon/Tmon*100,2) '%IV',
Shiny,
Res,
Reb

from stats_worker

where
RPL = XXB and
date(datetime) >= curdate() - interval XXA day and
Worker = 'XXC'
;
