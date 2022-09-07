-- Weekly aggregation of worker data

-- Settings For 10080min data 

select @Datetime := concat(date(curdate() - interval weekday(curdate()) + 7 day),' ','00:00:00');

INSERT INTO stats_worker (Datetime,RPL, TRPL, Worker, Tmon, IVmon, Mon, Quest, Raid, Tloc,LocOk,LocNok,LocFR,Tp,TpOk,TpNok,TpFR,TpSt,Wk,WkOk,WkNok,WkFR,WkSt,Shiny,Res,Reb,ResTot,RebTot,missingProtoMinute)
select
@Datetime,
'10080',
sum(TRPL),
Worker,
sum(Tmon),
sum(IVmon),
sum(Mon),
sum(Quest),
sum(Raid),
sum(Tloc),
sum(LocOk),
sum(LocNok),
sum(LocNok)/(sum(Tloc)+0.000001)*100,
sum(Tp),
sum(TpOk),
sum(TpNok),
sum(TpNok)/(sum(Tp)+0.000001)*100,
sum(tpSt),
sum(Wk),
sum(WkOk),
sum(WkNok),
sum(WkNok)/(sum(Wk)+0.000001)*100,
sum(WkSt),
sum(Shiny),
sum(Res),
sum(Reb),
max(ResTot),
max(RebTot),
sum(missingProtoMinute)

from stats_worker
where Datetime >= date(curdate() - interval weekday(curdate()) + 7 day) and RPL = 1440
group by Worker
;
