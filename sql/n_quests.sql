use pogodb

select 
date(a.datetime) as 'Date      ',
time(a.datetime) as 'Time    ',
round(sum(a.RPL)/count(a.RPL),0) as 'RPL',
round(sum(a.TRPL)/count(a.TRPL),1) as 'Trpl',
count(a.Worker) 'devs',
sum(Quest) 'Quests'

from stats_worker a

where
a.RPL = XXB and
date(a.datetime) >= curdate() - interval XXA day

group by a.datetime
;
