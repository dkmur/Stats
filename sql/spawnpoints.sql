use pogodb

select 
date(datetime) as 'Date      ',
time(datetime) as 'Time    ',
round(avg(RPL))  as 'RPL',
round(avg(TRPL)) as 'Trpl',
rpad(Area,12,' ') as 'Area    ',
sum(DBspawns) as 'DB',
sum(Spawn_add) as 'Added',
sum(Spawn_NULL) 'Unknown',
sum(Last_scanned_today_acc) 'Today',
sum(Last_scanned_1d) '-1',
sum(Last_scanned_2d) '-2',
sum(Last_scanned_3d) '-3',
sum(Last_scanned_7dp) '-7'

from stats_area

where
RPL = XXB and
date(Datetime) >= curdate() - interval XXA day and
Area = 'XXC'
group by datetime, Area
;
