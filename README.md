# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to compare different area's, devices and measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like i.e. PrioQ.

Available data:  
- interval period of 15, 60, 1440 and 10080 minutes  
- per device, area and network  
- locations handling (split between walk and teleport for #locations handled/success/failure/time required etc)  
- detection stats (mons,iv,raid,quest on device level)  
- mon stats (from table pokemon)  
- restart / reboot data  
- despawn time left  
- spawnpoint statistics (added, known, last scanned etc)  


With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.


Use it at you own risk, because bare in mind this was all done by an idiot!

## Setting up

### Prerequisites
- Activation of (raw)stats in MAD config.ini (statistic,game_stats,game_stats_raw).

- Get Stats ``git clone https://github.com/dkmur/Stats.git && cd Stats/ && cp config.ini.example config.ini``

### Creating database, tables, triggers and file prep

- In mysql create stats database and grant privileges. i.e.:  
```
create database ##STATS_DB##;
grant all privileges on ##STATS_DB##.* to ##MYSELF##@localhost;
```  
- Edit settings in file ``config.ini``. Make sure SQL_user has privileges to both STATS_DB and MAD_DB  
- for each Area or Town you whish to define: in /areas i.e. ``cp area.ini.example paris.ini`` and edit the settings  
- Execute ``./settings.run``, this will create required stats tables, triggers, sql queries and crontab file    

### Assign devices to area

Time to link workers/origin as defined in MAD to the created area's/towns above, in mysql:
```
insert into ##STATS_DB##.Area (Area,Origin) values
('Town1','Device01'),
('Town1','Device02'),
('Town2','Device01')
;
```

### Crontab

Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in Stats home.


### Starting Stats menu

Optionally, add stats to /usr/local/bin in order to start from any location:  
``sudo nano /usr/local/bin/stats`` add /PATHtoStats/stats.sh and save file  
``sudo chmod +x /usr/local/bin/stats``  

Run stats or ./stats.sh, but give it some time to fill the tables.

Hopefully that's it.....else......blame someone else :)  


### Some other stuff, not MAD stats related

I left some stuff in there about poracle settings and restarting/updating.......should you wish to use it......it will require adaptations  
- I run quests between 2am and 6am, so all spawpoints discovered between those hours are dumped into seperate table and removed from trs_spawn as well as everything not seen for the last 5 days, see Crontab example  
- query ``pokemon_hourly.sql`` contains cleanup queries for tables pokemon, trs_detect_raw and trs_location_raw. They are disbled by default as it will have an impact on representation of stats in MADmin. I choose to enable them, by removing ``--``, in order to keep tables small/cleaned up  
- for the rest......maybe someday I look into it.... 


### Note

Not all information stored in tables stats_worker and stats_area is included in Stats menu options, adapt as you see fit.  



## Meaning of Stats columns


**RPL** Report Length Period : will be 15, 60, 1440 or 10080 minutes  
**TRPL** True RPL : doubt if that is still in use today but was once used to identify missing periods due too i.e. downtime  
**DevRPL** Device RPL : each device will store stats every 5 minutes, depending on missing periods this value might me lower then RPL  

**Spawn60** spawndef=15 so 60 minute spawn (events do mess this number up, cleanup after event is needed)  
**Spawn30** spawndef<>15 so most likely 30 minute spawn  
**%timeleft** average % of despawn time left  

**Tmon** total mons scanned based on worker stats so not table pokemon  
**Tloc** total locations (route position) scanned  
**LocOk** number of correctly handled locations  
**LocNok** as above but incorrectly handled  
**LocFR** Location Failure Rate : % route positions incorrectly handled  

**Tp** number of TelePorts when changing route position  
**TpOk** successfull handled locations when teleporting  
**TpNok** as above but unsuccessfull  
**TpFr** TelePort Failure Rate  
**TpT** Teleport Time : average time required after expiration of post_teleport_delay until gmo is received  

**Wk** Waking to next route position counter  
**TkOk** successfull handled locations when walking  
**TkNok** as above but unsuccessfull  
**WkT** Walk Time : average time required after expiration of post_walk_delay until gmo is received  
**WkFr** Walk Failure Rate  

**Res** number of pogo restarts  
**Reb** number of device reboots  

Or at least this is my understanding of them :)

