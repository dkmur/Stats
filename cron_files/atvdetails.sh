#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $PATH_TO_STATS/logs
touch $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
start=$(date '+%Y%m%d %H:%M:%S')

deleteLog(){
curl --fail --silent --show-error -u $atvMADmin_user:$atvMADmin_password "$atvMAD_url/delete_log"
}

runJobs(){
cp $PATH_TO_STATS/default_files/ATVdetails.json $atvMAD_path/personal_commands/
curl --fail --silent --show-error -u $atvMADmin_user:$atvMADmin_password "$atvMAD_url/reload_jobs"
curl --fail --silent --show-error -u $atvMADmin_user:$atvMADmin_password "$atvMAD_url/install_file_all_devices?jobname=ATVdetails&type=jobType.CHAIN"
}

query(){
mysql -u$SQL_user -p$SQL_password -NB -h$DB_IP -P$DB_PORT $STATS_DB -e "$1;"
}

processJobs(){
        while read -r origin _ ;do
        arch=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=ARCH=).*?(?= )')
        productmodel=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=productmodel=).*?(?= )')
        rgc=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC=).*?(?= )')
        pogodroid=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD=).*?(?= )')
        pogo=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PoGo=).*?(?= )')
        rom=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=ROM=).*?(?= )')
        pogo_update=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PoGo_Autoupdate=).*?(?= )')
        rgc_update=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_Autoupdate=).*?(?= )')
        pd_update=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_Autoupdate=).*?(?= )')
        pingreboot=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=Pingreboot=).*?(?= )')
        temperature=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=Temperature=).*?(?= )')
        Magisk=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=Magisk=).*?(?= )')
        Modules=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=Modules=).*?(?= Gmail)')
        MACw=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=MACw=).*?(?= )')
        MACe=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=MACe=).*?(?= )')
        IP=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=devIP=).*?(?= )')
        exIP=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=exIP=).*?(?= )')
        hostname=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=hostname=).*?(?= )')
        Gmail=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=Gmail=).*?(?= )')
        PD_auth_username=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_username=).*?(?= )')
        PD_auth_password=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_password=).*?(?= )')
        PD_user_login=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_user_id=).*?(?= )')
        PD_auth_id=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_id=).*?(?= )')
        PD_auth_token=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_auth_token=).*?(?= )')
        PD_post_destination=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination=).*?(?= )' | sed 's/, //')
        PD_boot_delay=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_boot_delay=).*?(?= )')
        PD_injection_delay=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_preference_inject_after_seconds=).*?(?= )')
        PD_switch_disable_last_sent=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_last_sent=).*?(?= )')
        PD_intentional_stop=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_intentional_stop=).*?(?= )')
        PD_switch_send_protos=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_protos=).*?(?= )')
        PD_last_time_injected=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_last_time_injected=).*?(?= )')
        PD_switch_disable_external_communication=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_disable_external_communication=).*?(?= )')
        PD_last_pid_injected=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_last_pid_injected=).*?(?= )')
        PD_switch_enable_oomadj=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_oomadj=).*?(?= )')
        PD_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_auth_header=).*?(?= )')
        PD_switch_send_raw_protos=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_send_raw_protos=).*?(?= )')
        PD_switch_popup_last_sent=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_popup_last_sent=).*?(?= )')
        PD_full_daemon=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_full_daemon=).*?(?= )')
        PD_disable_pogo_freeze_detection=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_disable_pogo_freeze_detection=).*?(?= )')
        PD_switch_enable_mock_location_patch=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_enable_mock_location_patch=).*?(?= )')
        PD_last_system_patch_timestamp=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_last_system_patch_timestamp=).*?(?= )')
        PD_last_sys_inj=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_last_sys_inj=).*?(?= )')
        PD_default_mappging_mode=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_default_mappging_mode=).*?(?= )')
        PD_switch_setenforce=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_switch_setenforce=).*?(?= )')
        PD_post_destination_raw=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_post_destination_raw=).*?(?= )')
        PD_session_id=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_session_id=).*?(?= )')
        PD_libfilename=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_libfilename=).*?(?= )')
        PD_latest_version_known=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=PD_latest_version_known=).*?(?= )')
        RGC_auth_username=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_username=).*?(?= )')
        RGC_auth_password=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_auth_password=).*?(?= )')
        RGC_websocket_uri=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_websocket_uri=).*?(?= )')
        RGC_boot_delay=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_delay=).*?(?= )')
        RGC_mediaprojection_previously_started=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_mediaprojection_previously_started=).*?(?= )')
        RGC_suspended_mocking=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_suspended_mocking=).*?(?= )')
        RGC_reset_agps_once=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_once=).*?(?= )')
        RGC_overwrite_fused=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_overwrite_fused=).*?(?= )')
        RGC_switch_enable_auth_header=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_switch_enable_auth_header=).*?(?= )')
        RGC_reset_agps_continuously=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_agps_continuously=).*?(?= )')
        RGC_reset_google_play_services=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_reset_google_play_services=).*?(?= )')
        RGC_last_location_longitude=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_longitude=).*?(?= )')
        RGC_last_location_altitude=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_altitude=).*?(?= )')
        RGC_last_location_latitude=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_last_location_latitude=).*?(?= )')
        RGC_boot_startup=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_boot_startup=).*?(?= )')
        RGC_use_mock_location=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_use_mock_location=).*?(?= )')
        RGC_oom_adj_override=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_oom_adj_override=).*?(?= )')
        RGC_location_reporter_service_running=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_location_reporter_service_running=).*?(?= )')
        RGC_stop_location_provider_service=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_stop_location_provider_service=).*?(?= )')
        RGC_autostart_services=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=RGC_autostart_services=).*?(?= )')
        mitm=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=mitm=).*?(?= )')
        vmapper=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=vmapper=).*?(?= )')
        VM_bootdelay=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_bootdelay=).*?(?= )')
        VM_gzip=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_gzip=).*?(?= )')
        VM_betamode=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_betamode=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_selinux=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_selinux=).*?(?= )')
        VM_daemon=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_daemon=).*?(?= )')
        VM_authpassword=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_authpassword=).*?(?= )')
        VM_authuser=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_authuser=).*?(?= )')
        VM_injector=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_injector=).*?(?= )')
        VM_authid=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_authid=).*?(?= )')
#        VM_origin=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_origin=).*?(?= )')
        VM_postdest=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_postdest=).*?(?= )')
        VM_script=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VMscript=).*?(?= )')
        VM_Autoupdate=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_Autoupdate=).*?(?= )')
        VM_fridastarted=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_fridastarted=).*?(?= )')
        VM_patchedpid=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_patchedpid=).*?(?= )')
        VM_fridaver=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_fridaver=).*?(?= )')
        VM_openlucky=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_openlucky=).*?(?= )')
        VM_rebootminutes=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_rebootminutes=).*?(?= )')
        VM_deviceid=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_deviceid=).*?(?= )')
        VM_55vmapper=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=55VMapper=).*?(?= )')
        VM_websocketurl=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_websocketurl=).*?(?= )')
        VM_catchPokemon=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_catchPokemon=).*?(?= )')
        VM_catchRare=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_catchRare=).*?(?= )')
        VM_launcherver=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_launcherver=).*?(?= )')
        VM_rawpostdest=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_rawpostdest=).*?(?= )')
        VM_lat=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_lat=).*?(?= )')
        VM_lon=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_lon=).*?(?= )')
        VM_overlay=$(grep -w RGC_websocket_origin=$origin $atvMAD_path/update_log.json | tail -1 | grep -o -P '(?<=VM_overlay=).*?(?= )')

        if [ "$rgc" != '' ]; then
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVgeneral set 55vmapper = '$VM_55vmapper', arch = '$arch', productmodel = '$productmodel', rgc = '$rgc', mitm = '$mitm', pogodroid = '$pogodroid', vmapper = '$vmapper', pogo = '$pogo', rom = '$rom', magisk = '$Magisk', pogo_update = '$pogo_update', rgc_update = '$rgc_update', pd_update = '$pd_update', pingreboot = '$pingreboot', temperature = '$temperature', magisk_modules = '$Modules', MACw = '$MACw', MACe = '$MACe', ip = '$IP', ex_ip = '$exIP', hostname = '$hostname', gmail = '$Gmail', vm_script='$VM_script', vm_update='$VM_Autoupdate' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVpd set auth_username = '$PD_auth_username', auth_password = '$PD_auth_password', user_login = '$PD_user_login', auth_id = '$PD_auth_id', auth_token = '$PD_auth_token', post_destination = '$PD_post_destination', boot_delay = '$PD_boot_delay', injection_delay = '$PD_injection_delay', switch_disable_last_sent = '$PD_switch_disable_last_sent', intentional_stop = '$PD_intentional_stop', switch_send_protos = '$PD_switch_send_protos', last_time_injected = '$PD_last_time_injected', switch_disable_external_communication = '$PD_switch_disable_external_communication', last_pid_injected = '$PD_last_pid_injected', switch_enable_oomadj = '$PD_switch_enable_oomadj', switch_enable_auth_header = '$PD_switch_enable_auth_header', switch_send_raw_protos = '$PD_switch_send_raw_protos', switch_popup_last_sent = '$PD_switch_popup_last_sent', full_daemon = '$PD_full_daemon', switch_enable_mock_location_patch = '$PD_switch_enable_mock_location_patch', last_system_patch_timestamp = '$PD_last_system_patch_timestamp', last_sys_inj = '$PD_last_sys_inj', default_mappging_mode = '$PD_default_mappging_mode', switch_setenforce = '$PD_switch_setenforce', post_destination_raw = '$PD_post_destination_raw', session_id = '$PD_session_id', libfilename = '$PD_libfilename', latest_version_known = '$PD_latest_version_known', disable_pogo_freeze_detection = '$PD_disable_pogo_freeze_detection' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVrgc set auth_username = '$RGC_auth_username', auth_password = '$RGC_auth_password', websocket_uri = '$RGC_websocket_uri', boot_delay = '$RGC_boot_delay', mediaprojection_previously_started = '$RGC_mediaprojection_previously_started', suspended_mocking = '$RGC_suspended_mocking', reset_agps_once = '$RGC_reset_agps_once', overwrite_fused = '$RGC_overwrite_fused', switch_enable_auth_header = '$RGC_switch_enable_auth_header', reset_agps_continuously = '$RGC_reset_agps_continuously', reset_google_play_services = '$RGC_reset_google_play_services', last_location_longitude = '$RGC_last_location_longitude', last_location_altitude = '$RGC_last_location_altitude', last_location_latitude = '$RGC_last_location_latitude', boot_startup = '$RGC_boot_startup', use_mock_location = '$RGC_use_mock_location', oom_adj_override = '$RGC_oom_adj_override',  location_reporter_service_running = '$RGC_location_reporter_service_running', stop_location_provider_service = '$RGC_stop_location_provider_service', autostart_services = '$RGC_autostart_services' WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
                mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "UPDATE ATVvm set bootdelay = '$VM_bootdelay',  gzip = '$VM_gzip', betamode = '$VM_betamode', patchedpid = '$VM_patchedpid', selinux = '$VM_selinux', daemon = '$VM_daemon', authpassword = '$VM_authpassword', authuser = '$VM_authuser', injector = '$VM_injector', authid = '$VM_authid', postdest = '$VM_postdest', fridastarted='$VM_fridastarted', patchedpid='$VM_patchedpid', fridaver='$VM_fridaver', openlucky='$VM_openlucky', rebootminutes='$VM_rebootminutes', deviceid='$VM_deviceid', websocketurl='$VM_websocketurl', catchPokemon = '$VM_catchPokemon', catchRare = '$VM_catchRare', launcherver = '$VM_launcherver', rawpostdest = '$VM_rawpostdest', lat = '$VM_lat', lon = '$VM_lon', overlay = '$VM_overlay'  WHERE origin = '$origin' and datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600);"
        fi
        done < <(query "select origin FROM ATVgeneral where datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600) and arch is NULL;")
}


if ! "$atvdetailsWH"
then
  ## update db for instance 1
  if [ -z "$MAD_path_1" ]; then
        echo ""
        echo "No instance defined"
  else
        echo "Inserting origins into table"
        echo ""
	mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVgeneral (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
	mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVrgc (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
	mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVpd (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
	mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVvm (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
        echo ""
        atvMAD_path=$MAD_path_1
        atvMADmin_user=$MADmin_username_1
        atvMADmin_password=$MADmin_password_1
        atvMAD_url=$MAD_url_1
        deleteLog
        runJobs
        echo "Starting jobs for instance 1"
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 1"
        processJobs
  fi

  ## update db for instance 2
  if [ -z "$MAD_path_2" ]; then
        echo ""
        echo "No 2nd instance defined"
  else
        atvMAD_path=$MAD_path_2
        atvMADmin_user=$MADmin_username_2
        atvMADmin_password=$MADmin_password_2
        atvMAD_url=$MAD_url_2
        if [[ "$MAD_path_2" != "$MAD_path_1" ]]
        then
          deleteLog
        fi
        echo ""
        echo "Starting jobs for instance 2"
        runJobs
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 2"
        processJobs
  fi

  ## update db for instance 3
  if [ -z "$MAD_path_3" ]; then
        echo ""
        echo "No 3rd instance defined"
  else
        atvMAD_path=$MAD_path_3
        atvMADmin_user=$MADmin_username_3
        atvMADmin_password=$MADmin_password_3
        atvMAD_url=$MAD_url_3
        if [[ "$MAD_path_3" != "$MAD_path_1" ]]
        then
          deleteLog
        fi
        echo ""
        echo "Starting jobs for instance 3"
        runJobs
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 3"
        processJobs
  fi

  ## update db for instance 4
  if [ -z "$MAD_path_4" ]; then
        echo ""
        echo "No 4th instance defined"
  else
        atvMAD_path=$MAD_path_4
        atvMADmin_user=$MADmin_username_4
        atvMADmin_password=$MADmin_password_4
        atvMAD_url=$MAD_url_4
        if [[ "$MAD_path_4" != "$MAD_path_1" ]]
        then
          deleteLog
        fi
        echo ""
        echo "Starting jobs for instance 4"
        runJobs
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 4"
        processJobs
  fi

  ## update db for instance 5
  if [ -z "$MAD_path_5" ]; then
        echo ""
        echo "No 5th instance defined"
  else
        atvMAD_path=$MAD_path_5
        atvMADmin_user=$MADmin_username_5
        atvMADmin_password=$MADmin_password_5
        atvMAD_url=$MAD_url_5
        if [[ "$MAD_path_5" != "$MAD_path_1" ]]
        then
          deleteLog
        fi
        echo ""
        echo "Starting jobs for instance 5"
        runJobs
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 5"
        processJobs
  fi

  ## update db for instance 6
  if [ -z "$MAD_path_6" ]; then
        echo ""
        echo "No 6th instance defined"
  else
        atvMAD_path=$MAD_path_6
        atvMADmin_user=$MADmin_username_6
        atvMADmin_password=$MADmin_password_6
        atvMAD_url=$MAD_url_6
        if [[ "$MAD_path_6" != "$MAD_path_1" ]]
        then
          deleteLog
        fi
        echo ""
        echo "Starting jobs for instance 6"
        runJobs
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 6"
        processJobs
  fi

  ## update db for instance 7
  if [ -z "$MAD_path_7" ]; then
        echo ""
        echo "No 7th instance defined"
  else
        atvMAD_path=$MAD_path_7
        atvMADmin_user=$MADmin_username_7
        atvMADmin_password=$MADmin_password_7
        atvMAD_url=$MAD_url_7
        if [[ "$MAD_path_7" != "$MAD_path_1" ]]
        then
          deleteLog
        fi
        echo ""
        echo "Starting jobs for instance 7"
        runJobs
        echo ""
        echo "Wait timer started, $job_wait_atv"
        sleep $job_wait_atv
        echo ""
        echo "Start processing jobs instance 7"
        processJobs
  fi

else
  # copy from table ATVsummary
  echo "Inserting origins into table"
  echo ""
  mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVgeneral (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
  mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "insert ignore into ATVvm (datetime,origin) select SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600), name from $MAD_DB.settings_device;"
  echo "Updating data"
  echo ""
  mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "update ATVgeneral a join ATVsummary b on a.origin = b.origin set a.arch=b.arch, a.productmodel=b.productmodel, a.vm_script=b.vm_script, a.42vmapper=b.42vmapper, a.55vmapper=b.55vmapper, a.pogo=b.pogo,a.vmapper=b.vmapper, a.pogo_update=b.pogo_update, a.vm_update=b.vm_update, a.temperature=b.temperature, a.magisk=b.magisk, a.magisk_modules=b.magisk_modules, a.MACw=b.MACw, a.MACe=b.MACe, a.ip=b.ip, a.ex_ip=b.ext_ip, a.diskSysPct=b.diskSysPct, a.diskDataPct=b.diskDataPct, a.numPogo=b.numPogo where a.datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600) and b.timestamp > now() - interval 6 hour;"
  mysql $STATS_DB -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT -N -e "update ATVvm a join ATVsummary b on a.origin = b.origin set a.bootdelay=b.bootdelay, a.gzip=b.gzip, a.betamode=b.betamode, a.selinux=b.selinux, a.daemon=b.daemon, a.authpassword=b.authpassword, a.authuser=b.authuser, a.injector=b.injector, a.authid=b.authid, a.postdest=b.postdest, a.fridastarted=b.fridastarted, a.patchedpid=b.patchedpid, a.fridaver=b.fridaver, a.openlucky=b.openlucky, a.rebootminutes=b.rebootminutes, a.deviceid=b.deviceid, a.websocketurl=b.websocketurl, a.catchPokemon=b.catchPokemon, a.catchRare=b.catchRare, a.launcherver=b.launcherver, a.rawpostdest=b.rawpostdest, a.lat=b.lat, a.lon=b.lon, a.overlay=b.overlay where a.datetime = SEC_TO_TIME((TIME_TO_SEC(time(now())) DIV 3600) * 3600) and b.timestamp > now() - interval 6 hour;"
fi

echo ""
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] ATVdetails processing" >> $PATH_TO_STATS/logs/log_$(date '+%Y%m').log
echo "All done !"
