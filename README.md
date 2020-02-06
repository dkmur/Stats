# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like i.e. PrioQ.

With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will surely have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.

Use it at you own risk, because bare in mind this was all done by an idiot!



## Prerequisites
Ofcourse MAD scanning setup but also activation of (raw)stats in config.ini (statistic,game_stats,game_stats_raw).



## Creating database and tables

Tables I use are:
1 pogodb : for aggregated stats on worker/area level for different reporting periods
2 pokemon_history_temp : copy of table Pokemon with added columns first_scanned and is_shiny for current day
3 pokemon_history : final destination, for future reference or whatever, of data from table pokemon_history_temp

If you choose to use different names, start editing files from now on, else in mysql:
```
create database pogodb;
create database pokemon_history_temp;
create database pokemon_history;
```

Make sure to grant privileges to all 3 tables for your user account:
```
grant all privileges on pogodb.* to MYSELF@localhost;
grant all privileges on pokemon_history_temp.* to MYSELF@localhost;
grant all privileges on pokemon_history.* to MYSELF@localhost;
```

create tables required:
```
cd /PATH_TO_STATS/ && mysql < tables.sql
``` 
