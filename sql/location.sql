use pogodb

select 
date(a.datetime) as 'Date      ',
time(a.datetime) as 'Time    ',
round(sum(a.RPL)/count(a.RPL),0) as 'RPL',
round(sum(a.TRPL)/count(a.TRPL),1) as 'Trpl',
count(a.Worker) 'devs',
sum(a.Tloc) 'Tloc',
sum(a.LocOk) 'LocOk',
sum(a.LocNok) 'LocNok',
round(sum(a.LocNok)/sum(a.Tloc)*100,2) 'LocFR',
sum(Tp) 'Tp',
sum(TpOk) 'TpOk',
sum(TpNok) 'TpNok',
round(sum(a.TpNok)/sum(a.Tp)*100,2) 'TpFR',
round(sum(a.TpSt)/sum(a.TpOk),1) 'TpT',
sum(a.Wk) 'Wk',
sum(a.WkOk) 'WkOk',
sum(a.WkNok) 'WkNok',
round(sum(a.WkNok)/sum(a.Wk)*100,2) 'WkFR',
round(sum(a.WkSt)/sum(a.WkOk),1) 'WkT',
sum(a.Res) 'Res',
sum(a.Reb) 'Reb'

from stats_worker a, Area b

where
a.Worker = b.Origin and
a.RPL = XXB and
date(a.datetime) >= curdate() - interval XXA day and
b.Area = 'XXC'

group by a.datetime
;
