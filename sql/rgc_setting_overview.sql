use pogodb

select "RemoteGpsController settings" as '';
select
datetime as 'datetime  ', rpad(ifnull(RGC_auth_username,'no_data '),8," ") as 'username', rpad(ifnull(RGC_auth_password,'no_data '),11," ") as 'password   ', rpad(ifnull(RGC_websocket_uri,'no_data '),37," ") as 'websocket_url                     ', count(origin) as '#devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, RGC_auth_username, RGC_auth_password, RGC_websocket_uri
;

select "RemoteGpsController settings" as '';
select
datetime as 'datetime  ', rpad(ifnull(RGC_boot_delay,'no_data '),10," ") as 'boot_delay', rpad(ifnull(RGC_mediaprojection_previously_started,'no_data '),9," ") as 'mediaProj', rpad(ifnull(RGC_suspended_mocking,'no_data '),8," ") as 'suspMock', rpad(ifnull(RGC_reset_agps_once,'no_data '),8," ") as 'resAgps1', rpad(ifnull(RGC_overwrite_fused,'no_data '),10," ") as 'overwFused', rpad(ifnull(RGC_switch_enable_auth_header,'no_data '),10," ") as 'enAuthHead', rpad(ifnull(RGC_reset_agps_continuously,'no_data '),10," ") as 'resetAgpsC', count(origin) as '#devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, RGC_boot_delay, RGC_mediaprojection_previously_started, RGC_suspended_mocking, RGC_reset_agps_once, RGC_overwrite_fused, RGC_switch_enable_auth_header, RGC_reset_agps_continuously
;

select "RemoteGpsController settings" as '';
select
datetime as 'datetime  ', rpad(ifnull(RGC_reset_google_play_services,'no_data '),10," ") as 'resetGplay', rpad(ifnull(RGC_boot_startup,'no_data '),9," ") as 'bootStart', rpad(ifnull(RGC_use_mock_location,'no_data '),7," ") as 'useMock', rpad(ifnull(RGC_oom_adj_override,'no_data '),10," ") as 'overOomadj', rpad(ifnull(RGC_location_reporter_service_running,'no_data '),9," ") as 'locRepRun', rpad(ifnull(RGC_stop_location_provider_service,'no_data '),15," ") as 'stopLocProv', rpad(ifnull(RGC_autostart_services,'no_data '),11," ") as 'autoService', count(origin) as '#devices'
from ATVdetails

where
date(datetime) = curdate() - interval XXA day

group by datetime, RGC_reset_google_play_services, RGC_boot_startup, RGC_use_mock_location, RGC_oom_adj_override, RGC_location_reporter_service_running, RGC_stop_location_provider_service, RGC_autostart_services
;
