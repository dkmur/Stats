use pogodb

select
rpad(worker,15,' ') as 'Worker         ',
date(datetime) as 'Date      ',
time(datetime) as 'Time    ',
RPL as 'RPL',
TRPL 'Trpl',
Tloc,
LocOk,
LocNok,
round(LocNok/Tloc*100,2) 'LocFR',
Tp,
TpOk,
TpNok,
round(TpNok/Tp*100,2) 'TpFR',
round(TpSt/TpOk,1) 'TpT',
Wk,
WkOk,
WkNok,
round(WkNok/Wk*100,2) 'WkFR',
round(WkSt/WkOk,1) 'WkT',
Res,
Reb

from stats_worker

where
RPL = 1440 and
date(datetime) >= curdate() - interval 1 day
order by LocNok/Tloc*100 DESC
limit 20
;
