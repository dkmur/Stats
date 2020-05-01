use pogodb

select 
rpad(worker,15,' ') 'Worker   ',
date(datetime) as 'Date      ',
sum(Quest) as '#Quest',
round(count(RPL)/4,2) as '#hours'

from stats_worker

where
RPL = 15 and
Quest > 0 and
date(datetime) >= curdate() - interval XXA day

group by worker,date(datetime)

order by worker,date(datetime)
;
