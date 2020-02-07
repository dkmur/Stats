use pogodb

select 
date(Datetime) as 'Date      ',
time(Datetime) as 'Time    ',
RPL as 'RPL',
round(sum(TRPL)/count(TRPL),1) as 'Trpl',
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
date(Datetime) >= curdate() - interval XXA day

group by Datetime
;
