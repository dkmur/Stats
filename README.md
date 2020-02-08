# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like i.e. PrioQ.

With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.


Use it at you own risk, because bare in mind this was all done by an idiot!



## Prerequisites
Activation of (raw)stats in MAD config.ini (statistic,game_stats,game_stats_raw).

Get Stats ``git clone https://github.com/dkmur/Stats.git && cd /Stats/``

## Creating database, tables and triggers

Create database and grant privileges:
```
create database pogodb;
grant all privileges on pogodb.* to MYSELF@localhost;
```

If you will use a different database name, start editing files from now on, else.....  

Create tables, will not work for mariadb 10.1:``mysql pogodb < tables.sql`` 

Create triggers:``mysql **YOUR_MAD_DB** < triggers.sql``

## Defining area's/towns

For each area or town you want to define:  
1 copy all 3 ``.sql.default`` files and replace ``town`` with it's repective (area)name, leave out ``.default``  
``example cp 15_town_area.sql.default 15_paris_area.sql``  
2 edit each file and put in the correct information for ``@area``, ``@LatMax``, ``@LatMin``, ``@LonMin``, ``@LonMax``


Time to link workers/origin as defined in MAD to the created area's/towns above, in mysql:
```
insert into pogodb.Area (Area,Origin) values
('Town1','Device01'),
('Town1','Device02'),
('Town2','Device01')
;
```
## Set MAD database name

assuming Stats is located in /home/USER/Stats/  
``cd cd /home/USER/Stats//sql_cron/ && sed -i 's/rmdb/YOUR_MAD_DB/g' *.sql``  

## Crontab

Edit crontab ``crontab -e`` and insert
```
## Cleanup and backup
5 * * * * mysql < /PATHtoStats/sql_cron/pokemon_hourly.sql
7 1 * * * mysql < /PATHtoStats/sql_cron/pokemon_daily.sql
## Area stats
0 * * * * cd /PATHtoStats/sql_cron/ && mysql < 15_TOWN1_area.sql && mysql < 15_TOWN2_area.sql && ETC
15 * * * * cd /PATHtoStats/sql_cron/ && mysql < 15_TOWN1_area.sql && mysql < 15_TOWN2_area.sql && ETC
30 * * * * cd /PATHtoStats/sql_cron/ && mysql < 15_TOWN1_area.sql && mysql < 15_TOWN2_area.sql && ETC
45 * * * * cd /PATHtoStats/sql_cron/ && mysql < 15_TOWN1_area.sql && mysql < 15_TOWN2_area.sql && ETC
0 * * * * cd /PATHtoStats/sql_cron/ && mysql < 60_TOWN1_area.sql && mysql < 60_TOWN2_area.sql && ETC
1 0 * * * cd /PATHtoStats/sql_cron/ && mysql < 1440_TOWN1_area.sql && mysql < 1440_TOWN2_area.sql && ETC
10 0 * * 1 mysql < /PATHtoStats/sql_cron/10080_area.sql
## Worker stats
2 * * * * mysql < /PATHtoStats/sql_cron/15_worker.sql
17 * * * * mysql < /PATHtoStats/sql_cron/15_worker.sql
32 * * * * mysql < /PATHtoStats/sql_cron/15_worker.sql
47 * * * * mysql < /PATHtoStats/sql_cron/15_worker.sql
4 * * * * mysql < /PATHtoStats/sql_cron/60_worker.sql
7 0 * * * mysql < /PATHtoStats/sql_cron/1440_worker.sql
9 0 * * 1 mysql < /PATHtoStats/sql_cron/10080_worker.sql
## Cleanup spawnpoints discovered during Quest hours
# 13 6 * * 1 mysql < /PATHtoStats/sql_cron/quest_spawn_cleanup.sql
```
**Note 1:** adjust ``PATHtoStats`` and edit/include all previously defined area's/towns in section ``Area stats`` where TOWNx is mentioned  
**Note 2:** check the 3 delete sections in query ``pokemon_hourly.sql`` as this will have an effect on representation of stats in MADmin. I choose to keep table pokemon small/cleaned up else, edit the file and comment them out by putting ``--`` in front of each line. 



## Settings Stats

assuming Stats is located in /home/USER/Stats/  
``cd /home/USER/Stats/ && sed -i 's/pathToStats/\/home\/USER\/Stats\//g' *.sh``  
``cd /home/USER/Stats/progs/ && sed -i 's/pathToStats/\/home\/USER\/Stats\//g' *.sh``  
``cd /home/USER/Stats/progs/ && sed -i 's/AllAreas/YOUR_DEFINED_S_AREAS/g' *.sh``  
``cd /home/USER/Stats/progs/ && sed -i 's/DefaultArea/YOUR_PREFFERED_DEFAULT_AREA/g' *.sh``  

add stats to /usr/local/bin in order to start from any location:  
``sudo nano /usr/local/bin/stats`` add /PATHtoStats/stats.sh and save file  
``sudo chmod +x /usr/local/bin/stats``  

Hopefully that's it.....else......blame someone else :)  


## Optionally

I left some stuff in there about poracle and restarting/updating.......should you wish to use it......it will require adaptations  
1 poracle V3  ``cd /home/USER/Stats/sql/ && sed -i 's/poracle/PORACLE_DB_NAME/g' *`` 
2 I run quests between 2am and 6am, so all spawpoints discovered between those hours are dumped into seperate table and removed from trs_spawn as well as everything not seen for the last 5 days, see Crontab example  
3 for the rest......maybe someday I look into it....  


## Notes

Not all information stored in tables stats_worker and stats_area are included in Stats menu options.  
Pretty sure after making these changes you wil never be able to pull any change from here hence this most likely won't be updated :P
