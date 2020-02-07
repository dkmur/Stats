# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like i.e. PrioQ.

With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will surely have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.


Use it at you own risk, because bare in mind this was all done by an idiot!



## Prerequisites
Activation of (raw)stats in MAD config.ini (statistic,game_stats,game_stats_raw).

Clone ``git clone https://github.com/dkmur/Stats.git``

## Creating database, tables and triggers

Create database and grant privileges:
```
create database pogodb;
grant all privileges on pogodb.* to MYSELF@localhost;
```

If you will use a different database name, start editing files from now on, else.....  

Create tables required:
```
cd /PATH_TO_Stats/ && mysql < tables.sql
``` 

Create triggers required:
```
cd /PATH_TO_Stats/ && mysql MAD_DB pokemon < triggers.sql
```

## Defining area's

## Crontab
optionally clear pokemon, raw stats, trs_spawn for questing hours

## Settings Stats

## Additional options
add stats to autostart or wtf I ever did  
delete pokemon + raw_stats  

Will require some editing :P  
poracle  
restart/update shit  
