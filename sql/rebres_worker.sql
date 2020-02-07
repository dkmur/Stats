use pogodb

select 
date(datetime) as 'Date      ',
time(datetime) as 'Time    ',
RPL as 'RPL',
TRPL 'Trpl',
Res,
ResTot,
Reb,
RebTot

from stats_worker

where
RPL = XXB and
date(datetime) >= curdate() - interval XXA day and
Worker = 'XXC'
;
