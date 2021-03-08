# Stats

This idiot once had the idea it would be good to analyze statistics in more detail in order to compare different area's, devices and measure the effect of parameter changes in order to properly tune the setup as well as creating the ability to evaluate functionality like PrioQ.

Available data:  
- interval period of 15, 60, 1440 and 10080 minutes  
- per device, area and network  
- locations handling (split between walk and teleport for #locations handled/success/failure/time required etc)  
- detection stats (mons,iv,raid,quest on device level)  
- mon stats (from table pokemon)  
- restart / reboot data  
- despawn time left  
- spawnpoint statistics (added, known, last scanned etc)  
- missing proto received minutes  

Additionally, not related to Stats, but you can optionally set:
- cleanup op spawnpoint definitions in case they are f..... up by CommDay or Spotlight (does not work anymore if you use redis server for MAD)
- move spawns discovered during quest scan outside mon area to seperate table and remove from trs_spawn
- cleanup of trs_spawn for spawnpoint not seen for X days or after X days endtimes are still unknown
- Remove spawnpoints ouside mon_mitm fences seen less then X times today
- remove pokestops that became a gym
- remove pokestops that have no quest scanned for X days
- weekly re-caculation of quest routes
- cleanup of MAD tables pokemon/detection/location
- backup relevant tables from MAD database
- delete gyms that have not been scanned for X days

With limited knowlegde, help from my best friend Google, the attitude "steal with pride" and some perseverance this is what I cooked up.

Surely it can be done more efficient and some will have a good laugh when looking this. 

Anyway/anyhow......like me.....steal with pride.....(ab)use it the way you see fit or just ignore it all together.  
  
If you want to keep updated on Stats or some other great tools https://discord.gg/vXnwgT5  
  
  
Use it at you own risk, because bare in mind this was all done by an idiot!

## Setting up

### 1 Prerequisites
- Activation of (raw)stats in MAD config.ini (statistic,game_stats,game_stats_raw) and ``game_stats_save_time`` at default 300s
- Mariadb > 10.2
- mysql strict mode disabled

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
Within Stats it is possible to assign devices to areas (towns) in order to analyze statistics per area providing the possibility to i.e. compare areas or test functionality like PrioQ in a specific area and analyze it's statistics. <br>
3 options are availabe: <br>
1. In case you only have one area/town or are simply to lazy to assign devices to an area :P follow steps in 3.1, where area ``world`` will be created.<br>
2. Recommended: Use MAD (sub)fences. Area's will be created based on MAD fences or subfences, 3.2. In case each walker contains max 1 mon_mitm area, device to area assignmented is automated.<br>
3. The "old" way, create an area file where you set your area coordinates and assign devices to each area manually. See 3.3<br>


#### 3.1 Quick setup
- in ``config.ini`` set ``FENCE=world``
- Execute ``./settings.run``, this will create required stats tables, triggers, sql queries, procedures and crontab file. <br>
- Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in Stats home. <br>
Note: when adding devices, remove ``world.ini`` in /areas and execute ``settings.run`` or add device origin to table ``Area`` manually

#### 3.2 Use MAD fences (RECOMMENDED)
- in ``config.ini`` set ``FENCE=MAD``
- make sure your geofence names are not imported into db and have a name like ``configs/geofences/paris.txt`` as this will fuckup creation of stats cron files!! ``!blame banana``
- Execute ``./settings.run``, this will create required stats tables, triggers, sql queries , procedures and crontab file <br>
- Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in Stats home. <br>
- If each walker only contains 1 mon_mitm area, set MAD_DEVICE_INSERT=true in config.ini for automatic assignment. Else assign devices (MAD origins) to the created area's (select Area from STATS_DB.Area;) manually, in mysql:<br>
```
insert into ##STATS_DB##.Area (Area,Origin) values
('Town1','Device01'),
('Town1','Device02'),
('Town2','Device01')
;
```
Note 1: The geofence name used in MADmin is the Area name within Stats. <br>
Note 2: in case a geofence consists of sub-fences these names will be stored in column ``Fence`` in stats_area.<br>
Note 3: if MAD_DEVICE_INSERT=false, make sure to add new devices to ``table Area`` when expanding setup. I never remove origins as I want to keep the data collected.<br>

#### 3.3 Manual Area definition
- in ``config.ini`` set ``FENCE=box``
- for each Area or Town you whish to define: in /areas create an area file, i.e. ``cp area.ini.example paris.ini`` and edit the settings <br>
- Execute ``./settings.run``, this will create required stats tables, triggers, sql queries , procedures and crontab file <br>
- Assign devices (MAD origins) to the created area's/towns on previous steps, in mysql:<br>
- Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in Stats home. <br>
```
insert into ##STATS_DB##.Area (Area,Origin) values
('Town1','Device01'),
('Town1','Device02'),
('Town2','Device01')
;
```
Note 1: make sure to add new devices to ``table Area`` when expanding setup. I never remove origins as I want to keep the data collected.<br>
Note 2: in case you stop scanning an area, remove the area.ini file in /areas and execute ``settings.run``<br>

### 4 Grafana (optional but recommended)
- Install Grafana, more details can be found at https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository or if you prefer to use docker <https://hub.docker.com/r/grafana/grafana>
- Create datasource on STATS_DB and MAD_DB
- Add datasource names to config.ini
- After executing settings.run, import the dashboards from /Stats/grafana by selecting ``+`` and then import (Templates 20 and 21 connect to MAD_DB dashboard, the rest to STATS_DB.


### 5 Starting Stats menu, in case you do not use grafana

Optionally, add stats to /usr/local/bin in order to start from any location:  
``sudo nano /usr/local/bin/stats`` add ``cd /PATHtoStats/ && ./stats.sh`` and save file  
``sudo chmod +x /usr/local/bin/stats``  
<br>
Run ``stats`` or ``./stats.sh``, but give it some time to fill the tables.<br>
<br>
Hopefully that's it.....else......blame someone else :)  


### 6 Updating

**Stats**
Steps to be taken to update Stats depend on changes made, to make sure that you covered them all:<br>
- git pull
- check for changes in config.ini.default located in folder /default_files and adapt config.ini accordingly
- execute ``./settings.run`` located in Stats root
- replace crontab with content of crontab.txt located in Stats root  

**Grafana**
remove template(s) (Dashboards - Manage , select templates and delete)
import template(s) (as described in last step for initial import in section 4)


### 7 Note

- Not all information stored in tables stats_worker and stats_area is included in Stats menu options or Grafana, adapt as you see fit. <br>



## Meaning of Stats columns (tables stats_area and stats_worker)


**RPL** Report Length Period : will be 15, 60, 1440 or 10080 minutes  
**TRPL** True RPL : doubt if that is still in use today but was once used to identify missing periods due too i.e. downtime  
**DevRPL** Device RPL : each device will store stats every 5 minutes, depending on missing periods this value might me lower then RPL  

**Spawnpoints** : from table Pokemon, number of spawnpoints first_scanned during RPL  
**DBspawns** : from trs_spawn, number of spawnpoints within area  
**DBspawns_event** : from trs_spawn and trs_event, number of spawnpoints within area that at start of period should be active according to trs_event  

**Spawn60** spawndef=15 so 60 minute spawn (events do mess this number up, cleanup after event is needed)  
**Spawn30** spawndef<>15 so most likely 30 minute spawn  
**%timeleft** average % of despawn time left  
**%5min** % of mons scanned within the first 5 minutes of spawntime  

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
  
**missingProtoMinute** every minute check lastProtoDateTime < now() - interval 1 minute and step the counter if true  

Or at least this is my understanding of them :)

