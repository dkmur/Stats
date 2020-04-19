use pogodb

select 
date(a.datetime) as 'Date      ',
time(a.datetime) as 'Time    ',
round(sum(a.RPL)/count(a.RPL),0) as 'RPL',
round(sum(a.TRPL)/count(a.TRPL),1) as 'Trpl',
rpad(b.Area,12,' ') 'area   ',
count(a.Worker) 'devs',
sum(a.Tmon) 'Tmon',
round(sum(a.IVmon)/sum(a.Tmon)*100,2) '%IV',
sum(a.Tloc) 'Tloc',
round(sum(a.LocNok)/sum(a.Tloc)*100,2) 'LocFR',
sum(Tp) 'Tp',
round(sum(a.TpNok)/sum(a.Tp)*100,2) 'TpFR',
sum(a.Wk) 'Wk',
round(sum(a.WkNok)/sum(a.Wk)*100,2) 'WkFR',
sum(a.Res) 'Res',
sum(a.Reb) 'Reb'


from stats_worker a, Area b

where
a.RPL = XXB and
date(a.datetime) >= curdate() - interval XXA day and
a.worker = b. origin

group by b.Area, a.datetime
order by b.area, a.datetime
;
