use pogodb

select 
date(a.datetime) as 'Date      ',
time(a.datetime) as 'Time    ',
a.RPL 'RPL',
a.TRPL 'Trpl',
rpad(a.Worker,15,' ') 'worker  ',
a.Tmon 'Tmon',
round(a.IVmon/a.Tmon*100,2) '%IV',
a.Tloc 'Tloc',
round(a.LocNok/a.Tloc*100,2) 'LocFR',
a.Tp 'Tp',
round(a.TpNok/a.Tp*100,2) 'TpFR',
a.Wk 'Wk',
round(a.WkNok/a.Wk*100,2) 'WkFR',
a.Res 'Res',
a.Reb 'Reb'

from stats_worker a, Area b

where
a.Worker = b.Origin and
a.RPL = XXB and
date(a.datetime) >= curdate() - interval XXA day and
b.Area = 'XXC'
order by a.Worker, a.datetime
;
