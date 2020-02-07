use pogodb

select 
date(datetime) as 'Date      ',
time(datetime) as 'Time    ',
RPL as 'RPL',
TRPL 'Trpl',
Quest

from stats_worker

where
RPL = XXB and
date(datetime) >= curdate() - interval XXA day and
Worker = 'XXC' and
Quest > 0

order by datetime
;
