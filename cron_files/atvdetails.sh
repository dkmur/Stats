#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini


## update db for instance 1
if [ -z "$MAD_path_1" ]; then
        echo ""
	echo "No instance defined"
else
	echo "Inserting origins into table"
	echo ""
	mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVdetails (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
        echo "Starting jobs for instance 1"
	echo ""
	cp $PATH_TO_STATS/default_files/ATVdetails.json $MAD_path_1/personal_commands/
	curl -u $MADmin_username_1:$MADmin_password_1 "$MAD_url_1/delete_log"
	curl -u $MADmin_username_1:$MADmin_password_1 "$MAD_url_1/reload_jobs"
	curl -u $MADmin_username_1:$MADmin_password_1 "$MAD_url_1/install_file_all_devices?jobname=ATVdetails&type=jobType.CHAIN"
	echo ""
	echo "Wait timer started"
	sleep $job_wait
	echo ""
	echo "Start processing jobs instance 1"
#        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVdetails (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"

        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $STATS_DB -e "$1;"
        }
        while read -r origin _ ;do
        arch=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=ARCH=).*?(?= )')
        rgc=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC=).*?(?= )')
        pogodroid=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD=).*?(?= )')
        pogo=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PoGo=).*?(?= )')
        rom=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=ROM=).*?(?= )')
        pogo_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PoGo_Autoupdate=).*?(?= )')
        rgc_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_Autoupdate=).*?(?= )')
        pd_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_Autoupdate=).*?(?= )')
        pingreboot=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=Pingreboot=).*?(?= )')
        temperature=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=Temperature=).*?(?= )')
        Magisk=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=Magisk=).*?(?= )')
        Modules=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=Modules=).*?(?= Gmail)')
	MACw=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=MACw=).*?(?= )')
	MACe=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=MACe=).*?(?= )')
        IP=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=IP=).*?(?= )')
        Gmail=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=Gmail=).*?(?= )')
        PD_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_username=).*?(?= )')
        PD_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_password=).*?(?= )')
        PD_user_login=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_user_id=).*?(?= )')
        PD_auth_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_id=).*?(?= )')
        PD_auth_token=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_token=).*?(?= )')
        PD_post_destination=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination=).*?(?= )' | sed 's/, //')
        PD_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_boot_delay=).*?(?= )')
        PD_injection_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_preference_inject_after_seconds=).*?(?= )')
	PD_switch_disable_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_last_sent=).*?(?= )')
	PD_intentional_stop=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_intentional_stop=).*?(?= )')
	PD_switch_send_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_protos=).*?(?= )')
	PD_last_time_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_last_time_injected=).*?(?= )')
	PD_switch_disable_external_communication=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_external_communication=).*?(?= )')
	PD_last_pid_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_last_pid_injected=).*?(?= )')
	PD_switch_enable_oomadj=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_oomadj=).*?(?= )')
	PD_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_auth_header=).*?(?= )')
	PD_switch_send_raw_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_raw_protos=).*?(?= )')
	PD_switch_popup_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_popup_last_sent=).*?(?= )')
	PD_full_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_full_daemon=).*?(?= )')
        PD_disable_pogo_freeze_detection=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_disable_pogo_freeze_detection=).*?(?= )')
	PD_switch_enable_mock_location_patch=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_mock_location_patch=).*?(?= )')
	PD_last_system_patch_timestamp=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_last_system_patch_timestamp=).*?(?= )')
	PD_last_sys_inj=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_last_sys_inj=).*?(?= )')
	PD_default_mappging_mode=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_default_mappging_mode=).*?(?= )')
	PD_switch_setenforce=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_setenforce=).*?(?= )')
	PD_post_destination_raw=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination_raw=).*?(?= )')
	PD_session_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_session_id=).*?(?= )')
	PD_libfilename=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_libfilename=).*?(?= )')
	PD_latest_version_known=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=PD_latest_version_known=).*?(?= )')
        RGC_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_username=).*?(?= )')
        RGC_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_password=).*?(?= )')
        RGC_websocket_uri=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_websocket_uri=).*?(?= )')
        RGC_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_delay=).*?(?= )')
	RGC_mediaprojection_previously_started=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_mediaprojection_previously_started=).*?(?= )')
	RGC_suspended_mocking=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_suspended_mocking=).*?(?= )')
	RGC_reset_agps_once=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_once=).*?(?= )')
	RGC_overwrite_fused=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_overwrite_fused=).*?(?= )')
	RGC_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_switch_enable_auth_header=).*?(?= )')
	RGC_reset_agps_continuously=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_continuously=).*?(?= )')
	RGC_reset_google_play_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_google_play_services=).*?(?= )')
	RGC_last_location_longitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_longitude=).*?(?= )')
	RGC_last_location_altitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_altitude=).*?(?= )')
	RGC_last_location_latitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_latitude=).*?(?= )')
	RGC_boot_startup=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_startup=).*?(?= )')
	RGC_use_mock_location=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_use_mock_location=).*?(?= )')
	RGC_oom_adj_override=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_oom_adj_override=).*?(?= )')
	RGC_location_reporter_service_running=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_location_reporter_service_running=).*?(?= )')
	RGC_stop_location_provider_service=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_stop_location_provider_service=).*?(?= )')
	RGC_autostart_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=RGC_autostart_services=).*?(?= )')
	mitm=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=mitm=).*?(?= )')
        vmapper=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=vmapper=).*?(?= )')
	VM_bootdelay=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_bootdelay=).*?(?= )')
	VM_gzip=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_gzip=).*?(?= )')
	VM_betamode=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_betamode=).*?(?= )')
	VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
	VM_selinux=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_selinux=).*?(?= )')
	VM_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_daemon=).*?(?= )')
	VM_authpassword=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_authpassword=).*?(?= )')
	VM_authuser=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_authuser=).*?(?= )')
	VM_injector=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_injector=).*?(?= )')
	VM_authid=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_authid=).*?(?= )')
	VM_origin=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_origin=).*?(?= )')
	VM_postdest=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_postdest=).*?(?= )')
        VM_script=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VMscript=).*?(?= )')
        VM_Autoupdate=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_Autoupdate=).*?(?= )')
        VM_fridastarted=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_fridastarted=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_fridaver=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_fridaver=).*?(?= )')
        VM_openlucky=$(grep -w RGC_websocket_origin=$origin $MAD_path_1/update_log.json | tail -1 | grep -o -P '(?<=VM_openlucky=).*?(?= )')

        if [ "$rgc" != '' ]; then
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVdetails set arch = '$arch', rgc = '$rgc', mitm = '$mitm', pogodroid = '$pogodroid', vmapper = '$vmapper', pogo = '$pogo', rom = '$rom', magisk = '$Magisk', pogo_update = '$pogo_update', rgc_update = '$rgc_update', pd_update = '$pd_update', pingreboot = '$pingreboot', temperature = '$temperature', magisk_modules = '$Modules', MACw = '$MACw', MACe = '$MACe', ip = '$IP', gmail = '$Gmail', PD_auth_username = '$PD_auth_username', PD_auth_password = '$PD_auth_password', PD_user_login = '$PD_user_login', PD_auth_id = '$PD_auth_id', PD_auth_token = '$PD_auth_token', PD_post_destination = '$PD_post_destination', PD_boot_delay = '$PD_boot_delay', PD_injection_delay = '$PD_injection_delay', PD_switch_disable_last_sent = '$PD_switch_disable_last_sent', PD_intentional_stop = '$PD_intentional_stop', PD_switch_send_protos = '$PD_switch_send_protos', PD_last_time_injected = '$PD_last_time_injected', PD_switch_disable_external_communication = '$PD_switch_disable_external_communication', PD_last_pid_injected = '$PD_last_pid_injected', PD_switch_enable_oomadj = '$PD_switch_enable_oomadj', PD_switch_enable_auth_header = '$PD_switch_enable_auth_header', PD_switch_send_raw_protos = '$PD_switch_send_raw_protos', PD_switch_popup_last_sent = '$PD_switch_popup_last_sent', PD_full_daemon = '$PD_full_daemon', PD_switch_enable_mock_location_patch = '$PD_switch_enable_mock_location_patch', PD_last_system_patch_timestamp = '$PD_last_system_patch_timestamp', PD_last_sys_inj = '$PD_last_sys_inj', PD_default_mappging_mode = '$PD_default_mappging_mode', PD_switch_setenforce = '$PD_switch_setenforce', PD_post_destination_raw = '$PD_post_destination_raw', PD_session_id = '$PD_session_id', PD_libfilename = '$PD_libfilename', PD_latest_version_known = '$PD_latest_version_known', PD_disable_pogo_freeze_detection = '$PD_disable_pogo_freeze_detection', RGC_auth_username = '$RGC_auth_username', RGC_auth_password = '$RGC_auth_password', RGC_websocket_uri = '$RGC_websocket_uri', RGC_boot_delay = '$RGC_boot_delay', RGC_mediaprojection_previously_started = '$RGC_mediaprojection_previously_started', RGC_suspended_mocking = '$RGC_suspended_mocking', RGC_reset_agps_once = '$RGC_reset_agps_once', RGC_overwrite_fused = '$RGC_overwrite_fused', RGC_switch_enable_auth_header = '$RGC_switch_enable_auth_header', RGC_reset_agps_continuously = '$RGC_reset_agps_continuously', RGC_reset_google_play_services = '$RGC_reset_google_play_services', RGC_last_location_longitude = '$RGC_last_location_longitude', RGC_last_location_altitude = '$RGC_last_location_altitude', RGC_last_location_latitude = '$RGC_last_location_latitude', RGC_boot_startup = '$RGC_boot_startup', RGC_use_mock_location = '$RGC_use_mock_location', RGC_oom_adj_override = '$RGC_oom_adj_override',  RGC_location_reporter_service_running = '$RGC_location_reporter_service_running', RGC_stop_location_provider_service = '$RGC_stop_location_provider_service', RGC_autostart_services = '$RGC_autostart_services', VM_bootdelay = '$VM_bootdelay',  VM_gzip = '$VM_gzip', VM_betamode = '$VM_betamode', VM_patchedpid = '$VM_patchedpid', VM_selinux = '$VM_selinux', VM_daemon = '$VM_daemon', VM_authpassword = '$VM_authpassword', VM_authuser = '$VM_authuser', VM_injector = '$VM_injector', VM_authid = '$VM_authid', VM_origin = '$VM_origin', VM_postdest = '$VM_postdest', VM_script='$VM_script', VM_Autoupdate='$VM_Autoupdate', VM_fridastarted='$VM_fridastarted', VM_patchedpid='$VM_patchedpid', VM_fridaver='$VM_fridaver', VM_openlucky='$VM_openlucky' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
        fi
        done < <(query "select origin FROM ATVdetails where datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);")
fi

## update db for instance 2
if [ -z "$MAD_path_2" ]; then
        echo ""
        echo "No 2nd instance defined"
else
        echo "Starting jobs for instance 2"
        echo ""
        cp $PATH_TO_STATS/default_files/ATVdetails.json $MAD_path_2/personal_commands/
	if [[ "$MAD_path_2" != "$MAD_path_1" ]]
	then
		curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_2/delete_log"
	fi
        curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_2/reload_jobs"
        curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_2/install_file_all_devices?jobname=ATVdetails&type=jobType.CHAIN"
        echo ""
        echo "Wait timer started"
        sleep $job_wait
        echo ""
        echo "Start processing jobs instance 2"
#        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVdetails (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"

        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $STATS_DB -e "$1;"
        }
        while read -r origin _ ;do
        arch=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=ARCH=).*?(?= )')
        rgc=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC=).*?(?= )')
        pogodroid=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD=).*?(?= )')
        pogo=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PoGo=).*?(?= )')
        rom=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=ROM=).*?(?= )')
        pogo_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PoGo_Autoupdate=).*?(?= )')
        rgc_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_Autoupdate=).*?(?= )')
        pd_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_Autoupdate=).*?(?= )')
        pingreboot=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=Pingreboot=).*?(?= )')
        temperature=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=Temperature=).*?(?= )')
        Magisk=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=Magisk=).*?(?= )')
        Modules=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=Modules=).*?(?= Gmail)')
        MACw=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=MACw=).*?(?= )')
        MACe=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=MACe=).*?(?= )')
        IP=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=IP=).*?(?= )')
        Gmail=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=Gmail=).*?(?= )')
        PD_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_username=).*?(?= )')
        PD_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_password=).*?(?= )')
        PD_user_login=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_user_id=).*?(?= )')
        PD_auth_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_id=).*?(?= )')
        PD_auth_token=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_token=).*?(?= )')
        PD_post_destination=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination=).*?(?= )' | sed 's/, //')
        PD_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_boot_delay=).*?(?= )')
        PD_injection_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_preference_inject_after_seconds=).*?(?= )')
        PD_switch_disable_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_last_sent=).*?(?= )')
        PD_intentional_stop=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_intentional_stop=).*?(?= )')
        PD_switch_send_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_protos=).*?(?= )')
        PD_last_time_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_last_time_injected=).*?(?= )')
        PD_switch_disable_external_communication=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_external_communication=).*?(?= )')
        PD_last_pid_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_last_pid_injected=).*?(?= )')
        PD_switch_enable_oomadj=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_oomadj=).*?(?= )')
        PD_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_auth_header=).*?(?= )')
        PD_switch_send_raw_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_raw_protos=).*?(?= )')
        PD_switch_popup_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_popup_last_sent=).*?(?= )')
        PD_full_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_full_daemon=).*?(?= )')
        PD_disable_pogo_freeze_detection=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_disable_pogo_freeze_detection=).*?(?= )')
        PD_switch_enable_mock_location_patch=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_mock_location_patch=).*?(?= )')
        PD_last_system_patch_timestamp=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_last_system_patch_timestamp=).*?(?= )')
        PD_last_sys_inj=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_last_sys_inj=).*?(?= )')
        PD_default_mappging_mode=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_default_mappging_mode=).*?(?= )')
        PD_switch_setenforce=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_setenforce=).*?(?= )')
        PD_post_destination_raw=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination_raw=).*?(?= )')
        PD_session_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_session_id=).*?(?= )')
        PD_libfilename=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_libfilename=).*?(?= )')
        PD_latest_version_known=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=PD_latest_version_known=).*?(?= )')
        RGC_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_username=).*?(?= )')
        RGC_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_password=).*?(?= )')
        RGC_websocket_uri=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_websocket_uri=).*?(?= )')
        RGC_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_delay=).*?(?= )')
        RGC_mediaprojection_previously_started=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_mediaprojection_previously_started=).*?(?= )')
        RGC_suspended_mocking=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_suspended_mocking=).*?(?= )')
        RGC_reset_agps_once=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_once=).*?(?= )')
        RGC_overwrite_fused=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_overwrite_fused=).*?(?= )')
        RGC_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_switch_enable_auth_header=).*?(?= )')
        RGC_reset_agps_continuously=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_continuously=).*?(?= )')
        RGC_reset_google_play_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_google_play_services=).*?(?= )')
        RGC_last_location_longitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_longitude=).*?(?= )')
        RGC_last_location_altitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_altitude=).*?(?= )')
        RGC_last_location_latitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_latitude=).*?(?= )')
        RGC_boot_startup=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_startup=).*?(?= )')
        RGC_use_mock_location=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_use_mock_location=).*?(?= )')
        RGC_oom_adj_override=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_oom_adj_override=).*?(?= )')
        RGC_location_reporter_service_running=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_location_reporter_service_running=).*?(?= )')
        RGC_stop_location_provider_service=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_stop_location_provider_service=).*?(?= )')
        RGC_autostart_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=RGC_autostart_services=).*?(?= )')
        mitm=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=mitm=).*?(?= )')
        vmapper=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=vmapper=).*?(?= )') 
        VM_bootdelay=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_bootdelay=).*?(?= )')
        VM_gzip=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_gzip=).*?(?= )')
        VM_betamode=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_betamode=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_selinux=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_selinux=).*?(?= )')
        VM_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_daemon=).*?(?= )')
        VM_authpassword=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_authpassword=).*?(?= )')
        VM_authuser=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_authuser=).*?(?= )')
        VM_injector=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_injector=).*?(?= )')
        VM_authid=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_authid=).*?(?= )')
        VM_origin=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_origin=).*?(?= )')
        VM_postdest=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_postdest=).*?(?= )')
        VM_script=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VMscript=).*?(?= )')
        VM_Autoupdate=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_Autoupdate=).*?(?= )')
        VM_fridastarted=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_fridastarted=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_fridaver=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_fridaver=).*?(?= )')
        VM_openlucky=$(grep -w RGC_websocket_origin=$origin $MAD_path_2/update_log.json | tail -1 | grep -o -P '(?<=VM_openlucky=).*?(?= )')

        if [ "$rgc" != '' ]; then
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVdetails set arch = '$arch', rgc = '$rgc', mitm = '$mitm', pogodroid = '$pogodroid', vmapper = '$vmapper', pogo = '$pogo', rom = '$rom', magisk = '$Magisk', pogo_update = '$pogo_update', rgc_update = '$rgc_update', pd_update = '$pd_update', pingreboot = '$pingreboot', temperature = '$temperature', magisk_modules = '$Modules', MACw = '$MACw', MACe = '$MACe', ip = '$IP', gmail = '$Gmail', PD_auth_username = '$PD_auth_username', PD_auth_password = '$PD_auth_password', PD_user_login = '$PD_user_login', PD_auth_id = '$PD_auth_id', PD_auth_token = '$PD_auth_token', PD_post_destination = '$PD_post_destination', PD_boot_delay = '$PD_boot_delay', PD_injection_delay = '$PD_injection_delay', PD_switch_disable_last_sent = '$PD_switch_disable_last_sent', PD_intentional_stop = '$PD_intentional_stop', PD_switch_send_protos = '$PD_switch_send_protos', PD_last_time_injected = '$PD_last_time_injected', PD_switch_disable_external_communication = '$PD_switch_disable_external_communication', PD_last_pid_injected = '$PD_last_pid_injected', PD_switch_enable_oomadj = '$PD_switch_enable_oomadj', PD_switch_enable_auth_header = '$PD_switch_enable_auth_header', PD_switch_send_raw_protos = '$PD_switch_send_raw_protos', PD_switch_popup_last_sent = '$PD_switch_popup_last_sent', PD_full_daemon = '$PD_full_daemon', PD_switch_enable_mock_location_patch = '$PD_switch_enable_mock_location_patch', PD_last_system_patch_timestamp = '$PD_last_system_patch_timestamp', PD_last_sys_inj = '$PD_last_sys_inj', PD_default_mappging_mode = '$PD_default_mappging_mode', PD_switch_setenforce = '$PD_switch_setenforce', PD_post_destination_raw = '$PD_post_destination_raw', PD_session_id = '$PD_session_id', PD_libfilename = '$PD_libfilename', PD_latest_version_known = '$PD_latest_version_known', PD_disable_pogo_freeze_detection = '$PD_disable_pogo_freeze_detection', RGC_auth_username = '$RGC_auth_username', RGC_auth_password = '$RGC_auth_password', RGC_websocket_uri = '$RGC_websocket_uri', RGC_boot_delay = '$RGC_boot_delay', RGC_mediaprojection_previously_started = '$RGC_mediaprojection_previously_started', RGC_suspended_mocking = '$RGC_suspended_mocking', RGC_reset_agps_once = '$RGC_reset_agps_once', RGC_overwrite_fused = '$RGC_overwrite_fused', RGC_switch_enable_auth_header = '$RGC_switch_enable_auth_header', RGC_reset_agps_continuously = '$RGC_reset_agps_continuously', RGC_reset_google_play_services = '$RGC_reset_google_play_services', RGC_last_location_longitude = '$RGC_last_location_longitude', RGC_last_location_altitude = '$RGC_last_location_altitude', RGC_last_location_latitude = '$RGC_last_location_latitude', RGC_boot_startup = '$RGC_boot_startup', RGC_use_mock_location = '$RGC_use_mock_location', RGC_oom_adj_override = '$RGC_oom_adj_override',  RGC_location_reporter_service_running = '$RGC_location_reporter_service_running', RGC_stop_location_provider_service = '$RGC_stop_location_provider_service', RGC_autostart_services = '$RGC_autostart_services', VM_bootdelay = '$VM_bootdelay',  VM_gzip = '$VM_gzip', VM_betamode = '$VM_betamode', VM_patchedpid = '$VM_patchedpid', VM_selinux = '$VM_selinux', VM_daemon = '$VM_daemon', VM_authpassword = '$VM_authpassword', VM_authuser = '$VM_authuser', VM_injector = '$VM_injector', VM_authid = '$VM_authid', VM_origin = '$VM_origin', VM_postdest = '$VM_postdest', VM_script='$VM_script', VM_Autoupdate='$VM_Autoupdate', VM_fridastarted='$VM_fridastarted', VM_patchedpid='$VM_patchedpid', VM_fridaver='$VM_fridaver', VM_openlucky='$VM_openlucky' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
        fi
        done < <(query "select origin FROM ATVdetails where datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);")
fi

## update db for instance 3
if [ -z "$MAD_path_3" ]; then
        echo ""
        echo "No 3rd instance defined"
else
        echo "Starting jobs for instance 3"
        echo ""
        cp $PATH_TO_STATS/default_files/ATVdetails.json $MAD_path_3/personal_commands/
        if [[ "$MAD_path_3" != "$MAD_path_1" ]]
        then
                curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_3/delete_log"
        fi
        curl -u $MADmin_username_3:$MADmin_password_3 "$MAD_url_3/reload_jobs"
        curl -u $MADmin_username_3:$MADmin_password_3 "$MAD_url_3/install_file_all_devices?jobname=ATVdetails&type=jobType.CHAIN"
        echo ""
        echo "Wait timer started"
        sleep $job_wait
        echo ""
        echo "Start processing jobs instance 3"
#        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVdetails (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"

        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $STATS_DB -e "$1;"
        }
        while read -r origin _ ;do
        arch=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=ARCH=).*?(?= )')
        rgc=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC=).*?(?= )')
        pogodroid=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD=).*?(?= )')
        pogo=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PoGo=).*?(?= )')
        rom=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=ROM=).*?(?= )')
        pogo_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PoGo_Autoupdate=).*?(?= )')
        rgc_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_Autoupdate=).*?(?= )')
        pd_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_Autoupdate=).*?(?= )')
        pingreboot=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=Pingreboot=).*?(?= )')
        temperature=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=Temperature=).*?(?= )')
        Magisk=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=Magisk=).*?(?= )')
        Modules=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=Modules=).*?(?= Gmail)')
        MACw=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=MACw=).*?(?= )')
        MACe=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=MACe=).*?(?= )')
        IP=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=IP=).*?(?= )')
        Gmail=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=Gmail=).*?(?= )')
        PD_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_username=).*?(?= )')
        PD_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_password=).*?(?= )')
        PD_user_login=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_user_id=).*?(?= )')
        PD_auth_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_id=).*?(?= )')
        PD_auth_token=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_token=).*?(?= )')
        PD_post_destination=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination=).*?(?= )' | sed 's/, //')
        PD_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_boot_delay=).*?(?= )')
        PD_injection_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_preference_inject_after_seconds=).*?(?= )')
        PD_switch_disable_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_last_sent=).*?(?= )')
        PD_intentional_stop=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_intentional_stop=).*?(?= )')
        PD_switch_send_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_protos=).*?(?= )')
        PD_last_time_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_last_time_injected=).*?(?= )')
        PD_switch_disable_external_communication=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_external_communication=).*?(?= )')
        PD_last_pid_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_last_pid_injected=).*?(?= )')
        PD_switch_enable_oomadj=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_oomadj=).*?(?= )')
        PD_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_auth_header=).*?(?= )')
        PD_switch_send_raw_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_raw_protos=).*?(?= )')
        PD_switch_popup_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_popup_last_sent=).*?(?= )')
        PD_full_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_full_daemon=).*?(?= )')
        PD_disable_pogo_freeze_detection=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_disable_pogo_freeze_detection=).*?(?= )')
        PD_switch_enable_mock_location_patch=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_mock_location_patch=).*?(?= )')
        PD_last_system_patch_timestamp=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_last_system_patch_timestamp=).*?(?= )')
        PD_last_sys_inj=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_last_sys_inj=).*?(?= )')
        PD_default_mappging_mode=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_default_mappging_mode=).*?(?= )')
        PD_switch_setenforce=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_setenforce=).*?(?= )')
        PD_post_destination_raw=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination_raw=).*?(?= )')
        PD_session_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_session_id=).*?(?= )')
        PD_libfilename=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_libfilename=).*?(?= )')
        PD_latest_version_known=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=PD_latest_version_known=).*?(?= )')
        RGC_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_username=).*?(?= )')
        RGC_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_password=).*?(?= )')
        RGC_websocket_uri=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_websocket_uri=).*?(?= )')
        RGC_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_delay=).*?(?= )')
        RGC_mediaprojection_previously_started=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_mediaprojection_previously_started=).*?(?= )')
        RGC_suspended_mocking=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_suspended_mocking=).*?(?= )')
        RGC_reset_agps_once=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_once=).*?(?= )')
        RGC_overwrite_fused=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_overwrite_fused=).*?(?= )')
        RGC_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_switch_enable_auth_header=).*?(?= )')
        RGC_reset_agps_continuously=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_continuously=).*?(?= )')
        RGC_reset_google_play_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_google_play_services=).*?(?= )')
        RGC_last_location_longitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_longitude=).*?(?= )')
        RGC_last_location_altitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_altitude=).*?(?= )')
        RGC_last_location_latitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_latitude=).*?(?= )')
        RGC_boot_startup=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_startup=).*?(?= )')
        RGC_use_mock_location=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_use_mock_location=).*?(?= )')
        RGC_oom_adj_override=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_oom_adj_override=).*?(?= )')
        RGC_location_reporter_service_running=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_location_reporter_service_running=).*?(?= )')
        RGC_stop_location_provider_service=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_stop_location_provider_service=).*?(?= )')
        RGC_autostart_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=RGC_autostart_services=).*?(?= )')
        mitm=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=mitm=).*?(?= )')
        vmapper=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=vmapper=).*?(?= )') 
        VM_bootdelay=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_bootdelay=).*?(?= )')
        VM_gzip=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_gzip=).*?(?= )')
        VM_betamode=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_betamode=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_selinux=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_selinux=).*?(?= )')
        VM_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_daemon=).*?(?= )')
        VM_authpassword=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_authpassword=).*?(?= )')
        VM_authuser=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_authuser=).*?(?= )')
        VM_injector=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_injector=).*?(?= )')
        VM_authid=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_authid=).*?(?= )')
        VM_origin=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_origin=).*?(?= )')
        VM_postdest=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_postdest=).*?(?= )')
        VM_script=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VMscript=).*?(?= )')
        VM_Autoupdate=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_Autoupdate=).*?(?= )')
        VM_fridastarted=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_fridastarted=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_fridaver=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_fridaver=).*?(?= )')
        VM_openlucky=$(grep -w RGC_websocket_origin=$origin $MAD_path_3/update_log.json | tail -1 | grep -o -P '(?<=VM_openlucky=).*?(?= )')

        if [ "$rgc" != '' ]; then
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVdetails set arch = '$arch', rgc = '$rgc', mitm = '$mitm', pogodroid = '$pogodroid', vmapper = '$vmapper', pogo = '$pogo', rom = '$rom', magisk = '$Magisk', pogo_update = '$pogo_update', rgc_update = '$rgc_update', pd_update = '$pd_update', pingreboot = '$pingreboot', temperature = '$temperature', magisk_modules = '$Modules', MACw = '$MACw', MACe = '$MACe', ip = '$IP', gmail = '$Gmail', PD_auth_username = '$PD_auth_username', PD_auth_password = '$PD_auth_password', PD_user_login = '$PD_user_login', PD_auth_id = '$PD_auth_id', PD_auth_token = '$PD_auth_token', PD_post_destination = '$PD_post_destination', PD_boot_delay = '$PD_boot_delay', PD_injection_delay = '$PD_injection_delay', PD_switch_disable_last_sent = '$PD_switch_disable_last_sent', PD_intentional_stop = '$PD_intentional_stop', PD_switch_send_protos = '$PD_switch_send_protos', PD_last_time_injected = '$PD_last_time_injected', PD_switch_disable_external_communication = '$PD_switch_disable_external_communication', PD_last_pid_injected = '$PD_last_pid_injected', PD_switch_enable_oomadj = '$PD_switch_enable_oomadj', PD_switch_enable_auth_header = '$PD_switch_enable_auth_header', PD_switch_send_raw_protos = '$PD_switch_send_raw_protos', PD_switch_popup_last_sent = '$PD_switch_popup_last_sent', PD_full_daemon = '$PD_full_daemon', PD_switch_enable_mock_location_patch = '$PD_switch_enable_mock_location_patch', PD_last_system_patch_timestamp = '$PD_last_system_patch_timestamp', PD_last_sys_inj = '$PD_last_sys_inj', PD_default_mappging_mode = '$PD_default_mappging_mode', PD_switch_setenforce = '$PD_switch_setenforce', PD_post_destination_raw = '$PD_post_destination_raw', PD_session_id = '$PD_session_id', PD_libfilename = '$PD_libfilename', PD_latest_version_known = '$PD_latest_version_known', PD_disable_pogo_freeze_detection = '$PD_disable_pogo_freeze_detection', RGC_auth_username = '$RGC_auth_username', RGC_auth_password = '$RGC_auth_password', RGC_websocket_uri = '$RGC_websocket_uri', RGC_boot_delay = '$RGC_boot_delay', RGC_mediaprojection_previously_started = '$RGC_mediaprojection_previously_started', RGC_suspended_mocking = '$RGC_suspended_mocking', RGC_reset_agps_once = '$RGC_reset_agps_once', RGC_overwrite_fused = '$RGC_overwrite_fused', RGC_switch_enable_auth_header = '$RGC_switch_enable_auth_header', RGC_reset_agps_continuously = '$RGC_reset_agps_continuously', RGC_reset_google_play_services = '$RGC_reset_google_play_services', RGC_last_location_longitude = '$RGC_last_location_longitude', RGC_last_location_altitude = '$RGC_last_location_altitude', RGC_last_location_latitude = '$RGC_last_location_latitude', RGC_boot_startup = '$RGC_boot_startup', RGC_use_mock_location = '$RGC_use_mock_location', RGC_oom_adj_override = '$RGC_oom_adj_override',  RGC_location_reporter_service_running = '$RGC_location_reporter_service_running', RGC_stop_location_provider_service = '$RGC_stop_location_provider_service', RGC_autostart_services = '$RGC_autostart_services', VM_bootdelay = '$VM_bootdelay',  VM_gzip = '$VM_gzip', VM_betamode = '$VM_betamode', VM_patchedpid = '$VM_patchedpid', VM_selinux = '$VM_selinux', VM_daemon = '$VM_daemon', VM_authpassword = '$VM_authpassword', VM_authuser = '$VM_authuser', VM_injector = '$VM_injector', VM_authid = '$VM_authid', VM_origin = '$VM_origin', VM_postdest = '$VM_postdest', VM_script='$VM_script', VM_Autoupdate='$VM_Autoupdate', VM_fridastarted='$VM_fridastarted', VM_patchedpid='$VM_patchedpid', VM_fridaver='$VM_fridaver', VM_openlucky='$VM_openlucky' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
        fi
        done < <(query "select origin FROM ATVdetails where datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);")
fi

## update db for instance 4
if [ -z "$MAD_path_4" ]; then
        echo ""
        echo "No 4th instance defined"
else
        echo "Starting jobs for instance 4"
        echo ""
        cp $PATH_TO_STATS/default_files/ATVdetails.json $MAD_path_4/personal_commands/
        if [[ "$MAD_path_4" != "$MAD_path_1" ]]
        then
                curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_4/delete_log"
        fi
        curl -u $MADmin_username_4:$MADmin_password_4 "$MAD_url_4/reload_jobs"
        curl -u $MADmin_username_4:$MADmin_password_4 "$MAD_url_4/install_file_all_devices?jobname=ATVdetails&type=jobType.CHAIN"
        echo ""
        echo "Wait timer started"
        sleep $job_wait
        echo ""
        echo "Start processing jobs instance 4"
#        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVdetails (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"

        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $STATS_DB -e "$1;"
        }
        while read -r origin _ ;do
        arch=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=ARCH=).*?(?= )')
        rgc=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC=).*?(?= )')
        pogodroid=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD=).*?(?= )')
        pogo=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PoGo=).*?(?= )')
        rom=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=ROM=).*?(?= )')
        pogo_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PoGo_Autoupdate=).*?(?= )')
        rgc_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_Autoupdate=).*?(?= )')
        pd_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_Autoupdate=).*?(?= )')
        pingreboot=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=Pingreboot=).*?(?= )')
        temperature=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=Temperature=).*?(?= )')
        Magisk=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=Magisk=).*?(?= )')
        Modules=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=Modules=).*?(?= Gmail)')
        MACw=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=MACw=).*?(?= )')
        MACe=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=MACe=).*?(?= )')
        IP=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=IP=).*?(?= )')
        Gmail=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=Gmail=).*?(?= )')
        PD_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_username=).*?(?= )')
        PD_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_password=).*?(?= )')
        PD_user_login=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_user_id=).*?(?= )')
        PD_auth_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_id=).*?(?= )')
        PD_auth_token=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_token=).*?(?= )')
        PD_post_destination=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination=).*?(?= )' | sed 's/, //')
        PD_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_boot_delay=).*?(?= )')
        PD_injection_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_preference_inject_after_seconds=).*?(?= )')
        PD_switch_disable_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_last_sent=).*?(?= )')
        PD_intentional_stop=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_intentional_stop=).*?(?= )')
        PD_switch_send_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_protos=).*?(?= )')
        PD_last_time_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_last_time_injected=).*?(?= )')
        PD_switch_disable_external_communication=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_external_communication=).*?(?= )')
        PD_last_pid_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_last_pid_injected=).*?(?= )')
        PD_switch_enable_oomadj=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_oomadj=).*?(?= )')
        PD_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_auth_header=).*?(?= )')
        PD_switch_send_raw_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_raw_protos=).*?(?= )')
        PD_switch_popup_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_popup_last_sent=).*?(?= )')
        PD_full_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_full_daemon=).*?(?= )')
        PD_disable_pogo_freeze_detection=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_disable_pogo_freeze_detection=).*?(?= )')
        PD_switch_enable_mock_location_patch=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_mock_location_patch=).*?(?= )')
        PD_last_system_patch_timestamp=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_last_system_patch_timestamp=).*?(?= )')
        PD_last_sys_inj=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_last_sys_inj=).*?(?= )')
        PD_default_mappging_mode=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_default_mappging_mode=).*?(?= )')
        PD_switch_setenforce=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_setenforce=).*?(?= )')
        PD_post_destination_raw=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination_raw=).*?(?= )')
        PD_session_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_session_id=).*?(?= )')
        PD_libfilename=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_libfilename=).*?(?= )')
        PD_latest_version_known=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=PD_latest_version_known=).*?(?= )')
        RGC_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_username=).*?(?= )')
        RGC_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_password=).*?(?= )')
        RGC_websocket_uri=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_websocket_uri=).*?(?= )')
        RGC_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_delay=).*?(?= )')
        RGC_mediaprojection_previously_started=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_mediaprojection_previously_started=).*?(?= )')
        RGC_suspended_mocking=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_suspended_mocking=).*?(?= )')
        RGC_reset_agps_once=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_once=).*?(?= )')
        RGC_overwrite_fused=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_overwrite_fused=).*?(?= )')
        RGC_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_switch_enable_auth_header=).*?(?= )')
        RGC_reset_agps_continuously=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_continuously=).*?(?= )')
        RGC_reset_google_play_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_google_play_services=).*?(?= )')
        RGC_last_location_longitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_longitude=).*?(?= )')
        RGC_last_location_altitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_altitude=).*?(?= )')
        RGC_last_location_latitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_latitude=).*?(?= )')
        RGC_boot_startup=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_startup=).*?(?= )')
        RGC_use_mock_location=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_use_mock_location=).*?(?= )')
        RGC_oom_adj_override=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_oom_adj_override=).*?(?= )')
        RGC_location_reporter_service_running=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_location_reporter_service_running=).*?(?= )')
        RGC_stop_location_provider_service=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_stop_location_provider_service=).*?(?= )')
        RGC_autostart_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=RGC_autostart_services=).*?(?= )')
        mitm=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=mitm=).*?(?= )')
        vmapper=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=vmapper=).*?(?= )') 
        VM_bootdelay=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_bootdelay=).*?(?= )')
        VM_gzip=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_gzip=).*?(?= )')
        VM_betamode=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_betamode=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_selinux=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_selinux=).*?(?= )')
        VM_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_daemon=).*?(?= )')
        VM_authpassword=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_authpassword=).*?(?= )')
        VM_authuser=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_authuser=).*?(?= )')
        VM_injector=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_injector=).*?(?= )')
        VM_authid=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_authid=).*?(?= )')
        VM_origin=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_origin=).*?(?= )')
        VM_postdest=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_postdest=).*?(?= )')
        VM_script=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VMscript=).*?(?= )')
        VM_Autoupdate=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_Autoupdate=).*?(?= )')
        VM_fridastarted=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_fridastarted=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_fridaver=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_fridaver=).*?(?= )')
        VM_openlucky=$(grep -w RGC_websocket_origin=$origin $MAD_path_4/update_log.json | tail -1 | grep -o -P '(?<=VM_openlucky=).*?(?= )')

        if [ "$rgc" != '' ]; then
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVdetails set arch = '$arch', rgc = '$rgc', mitm = '$mitm', pogodroid = '$pogodroid', vmapper = '$vmapper', pogo = '$pogo', rom = '$rom', magisk = '$Magisk', pogo_update = '$pogo_update', rgc_update = '$rgc_update', pd_update = '$pd_update', pingreboot = '$pingreboot', temperature = '$temperature', magisk_modules = '$Modules', MACw = '$MACw', MACe = '$MACe', ip = '$IP', gmail = '$Gmail', PD_auth_username = '$PD_auth_username', PD_auth_password = '$PD_auth_password', PD_user_login = '$PD_user_login', PD_auth_id = '$PD_auth_id', PD_auth_token = '$PD_auth_token', PD_post_destination = '$PD_post_destination', PD_boot_delay = '$PD_boot_delay', PD_injection_delay = '$PD_injection_delay', PD_switch_disable_last_sent = '$PD_switch_disable_last_sent', PD_intentional_stop = '$PD_intentional_stop', PD_switch_send_protos = '$PD_switch_send_protos', PD_last_time_injected = '$PD_last_time_injected', PD_switch_disable_external_communication = '$PD_switch_disable_external_communication', PD_last_pid_injected = '$PD_last_pid_injected', PD_switch_enable_oomadj = '$PD_switch_enable_oomadj', PD_switch_enable_auth_header = '$PD_switch_enable_auth_header', PD_switch_send_raw_protos = '$PD_switch_send_raw_protos', PD_switch_popup_last_sent = '$PD_switch_popup_last_sent', PD_full_daemon = '$PD_full_daemon', PD_switch_enable_mock_location_patch = '$PD_switch_enable_mock_location_patch', PD_last_system_patch_timestamp = '$PD_last_system_patch_timestamp', PD_last_sys_inj = '$PD_last_sys_inj', PD_default_mappging_mode = '$PD_default_mappging_mode', PD_switch_setenforce = '$PD_switch_setenforce', PD_post_destination_raw = '$PD_post_destination_raw', PD_session_id = '$PD_session_id', PD_libfilename = '$PD_libfilename', PD_latest_version_known = '$PD_latest_version_known', PD_disable_pogo_freeze_detection = '$PD_disable_pogo_freeze_detection', RGC_auth_username = '$RGC_auth_username', RGC_auth_password = '$RGC_auth_password', RGC_websocket_uri = '$RGC_websocket_uri', RGC_boot_delay = '$RGC_boot_delay', RGC_mediaprojection_previously_started = '$RGC_mediaprojection_previously_started', RGC_suspended_mocking = '$RGC_suspended_mocking', RGC_reset_agps_once = '$RGC_reset_agps_once', RGC_overwrite_fused = '$RGC_overwrite_fused', RGC_switch_enable_auth_header = '$RGC_switch_enable_auth_header', RGC_reset_agps_continuously = '$RGC_reset_agps_continuously', RGC_reset_google_play_services = '$RGC_reset_google_play_services', RGC_last_location_longitude = '$RGC_last_location_longitude', RGC_last_location_altitude = '$RGC_last_location_altitude', RGC_last_location_latitude = '$RGC_last_location_latitude', RGC_boot_startup = '$RGC_boot_startup', RGC_use_mock_location = '$RGC_use_mock_location', RGC_oom_adj_override = '$RGC_oom_adj_override',  RGC_location_reporter_service_running = '$RGC_location_reporter_service_running', RGC_stop_location_provider_service = '$RGC_stop_location_provider_service', RGC_autostart_services = '$RGC_autostart_services', VM_bootdelay = '$VM_bootdelay',  VM_gzip = '$VM_gzip', VM_betamode = '$VM_betamode', VM_patchedpid = '$VM_patchedpid', VM_selinux = '$VM_selinux', VM_daemon = '$VM_daemon', VM_authpassword = '$VM_authpassword', VM_authuser = '$VM_authuser', VM_injector = '$VM_injector', VM_authid = '$VM_authid', VM_origin = '$VM_origin', VM_postdest = '$VM_postdest', VM_script='$VM_script', VM_Autoupdate='$VM_Autoupdate', VM_fridastarted='$VM_fridastarted', VM_patchedpid='$VM_patchedpid', VM_fridaver='$VM_fridaver', VM_openlucky='$VM_openlucky' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
        fi
        done < <(query "select origin FROM ATVdetails where datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);")
fi


## update db for instance 5
if [ -z "$MAD_path_5" ]; then
        echo ""
        echo "No 5th instance defined"
else
        echo "Starting jobs for instance 5"
        echo ""
        cp $PATH_TO_STATS/default_files/ATVdetails.json $MAD_path_5/personal_commands/
        if [[ "$MAD_path_5" != "$MAD_path_1" ]]
        then
                curl -u $MADmin_username_2:$MADmin_password_2 "$MAD_url_5/delete_log"
        fi
        curl -u $MADmin_username_5:$MADmin_password_5 "$MAD_url_5/reload_jobs"
        curl -u $MADmin_username_5:$MADmin_password_5 "$MAD_url_5/install_file_all_devices?jobname=ATVdetails&type=jobType.CHAIN"
        echo ""
        echo "Wait timer started"
        sleep $job_wait
        echo ""
        echo "Start processing jobs instance 5"
#        mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVdetails (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"

        query(){
        mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $STATS_DB -e "$1;"
        }
        while read -r origin _ ;do
        arch=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=ARCH=).*?(?= )')
        rgc=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC=).*?(?= )')
        pogodroid=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD=).*?(?= )')
        pogo=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PoGo=).*?(?= )')
        rom=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=ROM=).*?(?= )')
        pogo_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PoGo_Autoupdate=).*?(?= )')
        rgc_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_Autoupdate=).*?(?= )')
        pd_update=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_Autoupdate=).*?(?= )')
        pingreboot=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=Pingreboot=).*?(?= )')
        temperature=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=Temperature=).*?(?= )')
        Magisk=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=Magisk=).*?(?= )')
        Modules=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=Modules=).*?(?= Gmail)')
        MACw=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=MACw=).*?(?= )')
        MACe=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=MACe=).*?(?= )')
        IP=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=IP=).*?(?= )')
        Gmail=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=Gmail=).*?(?= )')
        PD_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_username=).*?(?= )')
        PD_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_password=).*?(?= )')
        PD_user_login=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_user_id=).*?(?= )')
        PD_auth_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_id=).*?(?= )')
        PD_auth_token=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_token=).*?(?= )')
        PD_post_destination=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination=).*?(?= )' | sed 's/, //')
        PD_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_boot_delay=).*?(?= )')
        PD_injection_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_preference_inject_after_seconds=).*?(?= )')
        PD_switch_disable_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_last_sent=).*?(?= )')
        PD_intentional_stop=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_intentional_stop=).*?(?= )')
        PD_switch_send_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_protos=).*?(?= )')
        PD_last_time_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_last_time_injected=).*?(?= )')
        PD_switch_disable_external_communication=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_external_communication=).*?(?= )')
        PD_last_pid_injected=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_last_pid_injected=).*?(?= )')
        PD_switch_enable_oomadj=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_oomadj=).*?(?= )')
        PD_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_auth_header=).*?(?= )')
        PD_switch_send_raw_protos=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_raw_protos=).*?(?= )')
        PD_switch_popup_last_sent=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_popup_last_sent=).*?(?= )')
        PD_full_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_full_daemon=).*?(?= )')
        PD_disable_pogo_freeze_detection=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_disable_pogo_freeze_detection=).*?(?= )')
        PD_switch_enable_mock_location_patch=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_mock_location_patch=).*?(?= )')
        PD_last_system_patch_timestamp=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_last_system_patch_timestamp=).*?(?= )')
        PD_last_sys_inj=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_last_sys_inj=).*?(?= )')
        PD_default_mappging_mode=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_default_mappging_mode=).*?(?= )')
        PD_switch_setenforce=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_setenforce=).*?(?= )')
        PD_post_destination_raw=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination_raw=).*?(?= )')
        PD_session_id=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_session_id=).*?(?= )')
        PD_libfilename=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_libfilename=).*?(?= )')
        PD_latest_version_known=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=PD_latest_version_known=).*?(?= )')
        RGC_auth_username=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_username=).*?(?= )')
        RGC_auth_password=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_password=).*?(?= )')
        RGC_websocket_uri=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_websocket_uri=).*?(?= )')
        RGC_boot_delay=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_delay=).*?(?= )')
        RGC_mediaprojection_previously_started=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_mediaprojection_previously_started=).*?(?= )')
        RGC_suspended_mocking=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_suspended_mocking=).*?(?= )')
        RGC_reset_agps_once=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_once=).*?(?= )')
        RGC_overwrite_fused=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_overwrite_fused=).*?(?= )')
        RGC_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_switch_enable_auth_header=).*?(?= )')
        RGC_reset_agps_continuously=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_continuously=).*?(?= )')
        RGC_reset_google_play_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_google_play_services=).*?(?= )')
        RGC_last_location_longitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_longitude=).*?(?= )')
        RGC_last_location_altitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_altitude=).*?(?= )')
        RGC_last_location_latitude=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_latitude=).*?(?= )')
        RGC_boot_startup=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_startup=).*?(?= )')
        RGC_use_mock_location=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_use_mock_location=).*?(?= )')
        RGC_oom_adj_override=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_oom_adj_override=).*?(?= )')
        RGC_location_reporter_service_running=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_location_reporter_service_running=).*?(?= )')
        RGC_stop_location_provider_service=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_stop_location_provider_service=).*?(?= )')
        RGC_autostart_services=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=RGC_autostart_services=).*?(?= )')
        mitm=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=mitm=).*?(?= )')
        vmapper=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=vmapper=).*?(?= )') 
        VM_bootdelay=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_bootdelay=).*?(?= )')
        VM_gzip=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_gzip=).*?(?= )')
        VM_betamode=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_betamode=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_selinux=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_selinux=).*?(?= )')
        VM_daemon=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_daemon=).*?(?= )')
        VM_authpassword=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_authpassword=).*?(?= )')
        VM_authuser=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_authuser=).*?(?= )')
        VM_injector=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_injector=).*?(?= )')
        VM_authid=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_authid=).*?(?= )')
        VM_origin=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_origin=).*?(?= )')
        VM_postdest=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_postdest=).*?(?= )')
        VM_script=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VMscript=).*?(?= )')
        VM_Autoupdate=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_Autoupdate=).*?(?= )')
        VM_fridastarted=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_fridastarted=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_fridaver=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_fridaver=).*?(?= )')
        VM_openlucky=$(grep -w RGC_websocket_origin=$origin $MAD_path_5/update_log.json | tail -1 | grep -o -P '(?<=VM_openlucky=).*?(?= )')

        if [ "$rgc" != '' ]; then
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVdetails set arch = '$arch', rgc = '$rgc', mitm = '$mitm', pogodroid = '$pogodroid', vmapper = '$vmapper', pogo = '$pogo', rom = '$rom', magisk = '$Magisk', pogo_update = '$pogo_update', rgc_update = '$rgc_update', pd_update = '$pd_update', pingreboot = '$pingreboot', temperature = '$temperature', magisk_modules = '$Modules', MACw = '$MACw', MACe = '$MACe', ip = '$IP', gmail = '$Gmail', PD_auth_username = '$PD_auth_username', PD_auth_password = '$PD_auth_password', PD_user_login = '$PD_user_login', PD_auth_id = '$PD_auth_id', PD_auth_token = '$PD_auth_token', PD_post_destination = '$PD_post_destination', PD_boot_delay = '$PD_boot_delay', PD_injection_delay = '$PD_injection_delay', PD_switch_disable_last_sent = '$PD_switch_disable_last_sent', PD_intentional_stop = '$PD_intentional_stop', PD_switch_send_protos = '$PD_switch_send_protos', PD_last_time_injected = '$PD_last_time_injected', PD_switch_disable_external_communication = '$PD_switch_disable_external_communication', PD_last_pid_injected = '$PD_last_pid_injected', PD_switch_enable_oomadj = '$PD_switch_enable_oomadj', PD_switch_enable_auth_header = '$PD_switch_enable_auth_header', PD_switch_send_raw_protos = '$PD_switch_send_raw_protos', PD_switch_popup_last_sent = '$PD_switch_popup_last_sent', PD_full_daemon = '$PD_full_daemon', PD_switch_enable_mock_location_patch = '$PD_switch_enable_mock_location_patch', PD_last_system_patch_timestamp = '$PD_last_system_patch_timestamp', PD_last_sys_inj = '$PD_last_sys_inj', PD_default_mappging_mode = '$PD_default_mappging_mode', PD_switch_setenforce = '$PD_switch_setenforce', PD_post_destination_raw = '$PD_post_destination_raw', PD_session_id = '$PD_session_id', PD_libfilename = '$PD_libfilename', PD_latest_version_known = '$PD_latest_version_known', PD_disable_pogo_freeze_detection = '$PD_disable_pogo_freeze_detection', RGC_auth_username = '$RGC_auth_username', RGC_auth_password = '$RGC_auth_password', RGC_websocket_uri = '$RGC_websocket_uri', RGC_boot_delay = '$RGC_boot_delay', RGC_mediaprojection_previously_started = '$RGC_mediaprojection_previously_started', RGC_suspended_mocking = '$RGC_suspended_mocking', RGC_reset_agps_once = '$RGC_reset_agps_once', RGC_overwrite_fused = '$RGC_overwrite_fused', RGC_switch_enable_auth_header = '$RGC_switch_enable_auth_header', RGC_reset_agps_continuously = '$RGC_reset_agps_continuously', RGC_reset_google_play_services = '$RGC_reset_google_play_services', RGC_last_location_longitude = '$RGC_last_location_longitude', RGC_last_location_altitude = '$RGC_last_location_altitude', RGC_last_location_latitude = '$RGC_last_location_latitude', RGC_boot_startup = '$RGC_boot_startup', RGC_use_mock_location = '$RGC_use_mock_location', RGC_oom_adj_override = '$RGC_oom_adj_override',  RGC_location_reporter_service_running = '$RGC_location_reporter_service_running', RGC_stop_location_provider_service = '$RGC_stop_location_provider_service', RGC_autostart_services = '$RGC_autostart_services', VM_bootdelay = '$VM_bootdelay',  VM_gzip = '$VM_gzip', VM_betamode = '$VM_betamode', VM_patchedpid = '$VM_patchedpid', VM_selinux = '$VM_selinux', VM_daemon = '$VM_daemon', VM_authpassword = '$VM_authpassword', VM_authuser = '$VM_authuser', VM_injector = '$VM_injector', VM_authid = '$VM_authid', VM_origin = '$VM_origin', VM_postdest = '$VM_postdest', VM_script='$VM_script', VM_Autoupdate='$VM_Autoupdate', VM_fridastarted='$VM_fridastarted', VM_patchedpid='$VM_patchedpid', VM_fridaver='$VM_fridaver', VM_openlucky='$VM_openlucky' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
        fi
        done < <(query "select origin FROM ATVdetails where datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);")
fi
