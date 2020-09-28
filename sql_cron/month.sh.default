#!/bin/bash
yearmonth=$(date --date="yesterday" +"%Y_%m")

mysqldump --no-data userpass pogodb pokemon_history > PATH_TO_STATS/pokemon_history_structure.sql 
mysql userpass pogodb -e "alter table pogodb.pokemon_history RENAME mons.pokemon_history_$yearmonth"
mysql userpass pogodb < PATH_TO_STATS/pokemon_history_structure.sql
rm PATH_TO_STATS/pokemon_history_structure.sql
