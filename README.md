# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to compare different area's, devices and measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like PrioQ and nearby scanning.

Available data:  
- interval period of 15, 60, 1440 and 10080 minutes  
- per device, area and network  
- locations handling (split between walk and teleport for #locations handled/success/failure/time required etc)  
- detection stats (mons,iv,raid,quest on device level)  
- mon stats (from table pokemon)  
- quest stats  
- restart / reboot data  
- despawn time left  
- spawnpoint statistics (added, known, last scanned etc)  
- missing proto received minutes  

Additionally, not related to Stats, but you can optionally set:
- cleanup op spawnpoint definitions in case they are f..... up by CommDay or Spotlight  
- move spawns discovered during quest scan outside mon area to seperate table and remove from trs_spawn
- cleanup of trs_spawn for spawnpoint not seen for X days or after X days endtimes are still unknown
- Remove spawnpoints ouside mon_mitm fences seen less then X times today
- remove pokestops that became a gym
- remove pokestops that have no quest scanned for X days
- weekly re-caculation of quest routes
- cleanup of MAD tables pokemon/detection/location
- backup relevant tables from MAD database
- delete gyms that have not been scanned for X days
- process of MAD logs to db

With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.  
  
If you want to keep updated on Stats or some other great tools https://discord.gg/vXnwgT5  
  
  
Use it at you own risk, because bare in mind this was all done by an idiot!

## Setting up

### 1 Prerequisites
- Activation of (raw)stats in MAD config.ini (statistic,game_stats,game_stats_raw) and ``game_stats_save_time`` at default 300s
- Mariadb 10.5
- Mariadb to be installed on server Stats is running on
- mysql strict mode disabled (should be done already for MAD)
- Make sure ``jq`` is installed else,  ``sudo apt-get install jq``<BR>
- Make sure unzip is installed <BR>

### 2 Initial setup

- Clone Stats and copy config file: <br>``git clone https://github.com/dkmur/Stats.git && cd Stats/ && cp default_files/config.ini.example config.ini``
- Create stats database and grant privileges to user (make sure not to use ``$`` in password and, no, not going to escape it). i.e.:  
```
create database ##STATS_DB##;
grant all privileges on ##STATS_DB##.* to ##MYSELF##@localhost;
flush privileges;
```  
- Edit settings in file ``config.ini``.  
- Make sure SQL_user has privileges on both STATS_DB and MAD_DB.  

### 3 Define areas and add devices
Recommended way, making use of MAD mon_mitm fences.
- fill out MAD instance and database details in ``config.ini``
- check any other settings in config.ini and set to your preference  
- note: for really old setups, make sure your geofence names are not imported into db and have a name like ``configs/geofences/paris.txt`` as this will fuckup creation of stats cron files!! ``!blame banana``  
- Execute ``./settings.run``, this will create required stats tables, triggers, sql queries , procedures and crontab file <br>
- Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in Stats home. <br>
  
**Verify**  
1 settings.run executed without errors<br>
2 cron logging is done to /Stats/logs/, check it<br>
<br>
<br>
Adding devices:  
- If each walker only contains 1 mon_mitm area, set MAD_DEVICE_INSERT=true in config.ini for automatic assignment.  
- Else assign devices (MAD origins) to the created area's, table Area, manually, in mysql:<br>
```
insert into ##STATS_DB##.Area (Area,Origin) values
('Town1','Device_town1_01'),
('Town1','Device_town1_02'),
('Town2','Device_town2_01')
;
```
Note 1: The geofence name used in MADmin is the Area name within Stats. <br>
Note 2: in case a geofence consists of sub-fences these names will be stored in column ``Fence`` in stats_area.<br>
Note 3: if MAD_DEVICE_INSERT=false, make sure to add new devices to ``table Area`` when expanding setup. I never remove origins as I want to keep the data collected.<br>

### 4 Grafana
- Install Grafana, more details can be found at https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository or if you prefer to use docker <https://hub.docker.com/r/grafana/grafana>
- Create datasource on STATS_DB and MAD_DB
- Add datasource names to config.ini
- After executing settings.run, import the dashboards from /Stats/grafana by selecting ``+`` and then import (Templates 20 and 21 connect to MAD_DB dashboard, the rest to STATS_DB).


### 6 Updating

**Stats**
Steps to be taken to update Stats depend on changes made, to make sure that you covered them all:<br>
- git pull
- check for changes in config.ini.default located in folder /default_files and adapt config.ini accordingly
- execute ``./settings.run`` located in Stats root
- replace crontab with content of crontab.txt located in Stats root  
<br>
**Grafana**
remove template(s) (Dashboards - Manage , select templates and delete)
import template(s) (as described in last step for initial import in section 4)


## Meaning of Stats columns (tables stats_area and stats_worker)


**RPL** Report Length Period : will be 15, 60, 1440 or 10080 minutes  
**TRPL** True RPL : doubt if that is still in use today but was once used to identify missing periods due too i.e. downtime  
**DevRPL** Device RPL : each device will store stats every 5 minutes, depending on missing periods this value might me lower then RPL  

**Spawnpoints** : from table Pokemon, number of spawnpoints first_scanned during RPL  
**DBspawns** : from trs_spawn, number of spawnpoints within area  
**DBspawns_event** : from trs_spawn and trs_event, number of spawnpoints within area that at start of period should be active according to trs_event  

**Spawn60** : spawndef=15 so 60 minute spawn (events do mess this number up, cleanup after event is needed)  
**Spawn30** : spawndef<>15 so most likely 30 minute spawn  
**%timeleft** : average % of despawn time left  
**%5min** : % of mons scanned within the first 5 minutes of spawntime  

**Tmon** : total mons scanned based on worker stats so not table pokemon  
**Tloc** : total locations (route position) scanned  
**LocOk** : number of correctly handled locations  
**LocNok** : as above but incorrectly handled  
**LocFR** : Location Failure Rate : % route positions incorrectly handled  

**Tp** : number of TelePorts when changing route position  
**TpOk** : successfull handled locations when teleporting  
**TpNok** : as above but unsuccessfull  
**TpFr** : TelePort Failure Rate  
**TpT** : Teleport Time : average time required after expiration of post_teleport_delay until gmo is received  

**Wk** : Waking to next route position counter  
**TkOk** : successfull handled locations when walking  
**TkNok** : as above but unsuccessfull  
**WkT** : average time required after expiration of post_walk_delay until gmo is received  
**WkFr** : Walk Failure Rate  

**Res** : number of pogo restarts  
**Reb** : number of device reboots  
  
**missingProtoMinute** : every minute check lastProtoDateTime < now() - interval 1 minute and step the counter if true  

Or at least this is my understanding of them :)

