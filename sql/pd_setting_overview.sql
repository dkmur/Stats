use pogodb

select "PogoDroid settings" as '';
select
date as 'date      ', rpad(ifnull(PD_auth_username,'no_data '),8," ") as 'username', rpad(ifnull(PD_auth_password,'no_data '),11," ") as 'password   ', rpad(ifnull(PD_user_login,'no_data '),20," ") as 'login               ' ,rpad(ifnull(PD_auth_token,'no_data '),18," ") as 'auth_token        ', rpad(ifnull(PD_post_destination,'no_data '),37," ") as 'post_destination                     ', count(origin) as '#devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, PD_auth_username, PD_auth_password, PD_user_login, PD_auth_token, PD_post_destination
;

select "PogoDroid settings" as '';
select
date as 'date      ', rpad(ifnull(PD_boot_delay,'no_data '),10," ") as 'boot_delay', rpad(ifnull(PD_injection_delay,'no_data '),15," ") as 'injection_delay', rpad(ifnull(PD_switch_disable_last_sent,'no_data '),8," ") as 'lastSend', rpad(ifnull(PD_intentional_stop,'no_data '),10," ") as 'intentStop', rpad(ifnull(PD_switch_send_protos,'no_data '),9," ") as 'sendProto' ,rpad(ifnull(PD_switch_disable_external_communication,'no_data '),11," ") as 'disExtComms', rpad(ifnull(PD_switch_enable_oomadj,'no_data '),8," ") as 'enOomadj', rpad(ifnull(PD_switch_enable_auth_header,'no_data '),10," ") as 'enAuthHead', count(origin) as '#devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, PD_boot_delay, PD_injection_delay, PD_switch_disable_last_sent, PD_intentional_stop, PD_switch_send_protos, PD_switch_disable_external_communication, PD_switch_enable_oomadj, PD_switch_enable_auth_header;

select "PogoDroid settings" as '';
select
date as 'date      ', rpad(ifnull(PD_switch_send_raw_protos,'no_data '),11," ") as 'sendRawProto', rpad(ifnull(PD_switch_popup_last_sent,'no_data '),11," ") as 'popLastSend', rpad(ifnull(PD_full_daemon,'no_data '),10," ") as 'fullDaemon', rpad(ifnull(PD_switch_enable_mock_location_patch,'no_data '),6," ") as 'enMock', rpad(ifnull(PD_default_mappging_mode,'no_data '),10," ") as 'defMapMode', rpad(ifnull(PD_switch_setenforce,'no_data '),10," ") as 'setEnforce', rpad(ifnull(PD_disable_pogo_freeze_detection,'no_data '),13," ") as 'disPogoFreeze', count(origin) as '#devices'
from ATVdetails

where
date = curdate() - interval XXA day

group by date, PD_switch_send_raw_protos, PD_switch_popup_last_sent, PD_full_daemon, PD_switch_enable_mock_location_patch, PD_default_mappging_mode, PD_switch_setenforce, PD_disable_pogo_freeze_detection
;
