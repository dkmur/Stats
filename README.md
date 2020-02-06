# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like i.e. PrioQ.

With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will surely have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.


Use it at you own risk, because bare in mind this was all done by an idiot!



## Prerequisites
Ofcourse MAD scanning fully setup but also activation of (raw)stats in config.ini (statistic,game_stats,game_stats_raw).



## Creating databases, tables and triggers

Tables I use are:  
1 pogodb : for aggregated stats on worker/area level for different reporting periods  
2 mons : copy of table Pokemon with added columns first_scanned and is_shiny for current day and permanent storage    

If you choose to use different names, start editing files from now on, else in mysql:
```
create database pogodb;
create database mons;
```

Make sure to grant privileges to all 3 tables for your user account:
```
grant all privileges on pogodb.* to MYSELF@localhost;
grant all privileges on mons.* to MYSELF@localhost;
```

Create tables required:
```
cd /PATH_TO_STATS/ && mysql < tables.sql
``` 

Create triggers required:
```
cd /PATH_TO_STATS/ && mysql MAD_DB pokemon < triggers.sql
```

## Defining area's

## Crontab
optionally clear pokemon, raw stats, trs_spawn for questing hours

## Settings Stats
