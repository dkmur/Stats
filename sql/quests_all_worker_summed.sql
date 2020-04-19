use pogodb

select 
rpad(worker,15,' ') 'Worker   ',
date(datetime) as 'Date      ',
sum(RPL) as 'RPL',
sum(TRPL) 'Trpl',
sum(Quest) as 'Quest'

from stats_worker

where
RPL = 60 and
date(datetime) >= curdate() - interval XXA day

group by worker,date(datetime)

order by worker,date(datetime)
;
