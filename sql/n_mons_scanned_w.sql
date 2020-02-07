use pogodb

select 
date(a.datetime) as 'Date      ',
time(a.datetime) as 'Time    ',
round(sum(a.RPL)/count(a.RPL),0) as 'RPL',
round(sum(a.TRPL)/count(a.TRPL),1) 'Trpl',
count(a.Worker) 'devs',
sum(a.Tmon) 'Tmon',
sum(a.IVmon) 'IVmon',
sum(a.Mon) 'Mon',
round(sum(a.IVmon)/sum(a.Tmon)*100,2) '%IV',
sum(a.Shiny) 'Shiny',
sum(a.Res) 'Res',
sum(a.Reb) 'Reb'

from 
stats_worker a

where
a.RPL = XXB and
date(a.datetime) >= curdate() - interval XXA day

group by a.datetime
;
