use pogodb

select 
date(a.datetime) as 'Date      ',
time(a.datetime) as 'Time    ',
round(sum(a.RPL)/count(a.RPL),0) as 'RPL',
round(sum(a.TRPL)/count(a.TRPL),1) as 'Trpl',
count(a.Worker) 'devs',
sum(a.Res) 'Res',
sum(a.ResTot) 'ResTot',
sum(a.Reb) 'Reb',
sum(a.RebTot) 'RebTot'

from stats_worker a, Area b

where
a.Worker = b.Origin and
a.RPL = XXB and
date(a.datetime) >= curdate() - interval XXA day and
b.Area = 'XXC'

group by a.datetime
;
