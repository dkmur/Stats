use pogodb

select 
date(datetime) as 'Date      ',
time(datetime) as 'Time    ',
RPL as 'RPL',
TRPL as 'Trpl',
rpad(Area,8,' ') as 'Area    ',
DBspawns as 'DB',
Spawn_add as 'Added',
Spawn_NULL 'Unknown',
Last_scanned_today_acc 'Today',
Last_scanned_1d '-1',
Last_scanned_2d '-2',
Last_scanned_3d '-3',
Last_scanned_7dp '-7'

from stats_area

where
RPL = XXB and
date(Datetime) >= curdate() - interval XXA day and
Area = 'XXC'
;
