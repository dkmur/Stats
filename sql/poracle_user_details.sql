create temporary table rmdb.tmp200
as(
select count(*) as 'totMon'
from poracle.humans a, poracle.monsters b
where
a.name = 'XXA' and
a.id = b.id
);

create temporary table rmdb.tmp201
as(
select count(*) as 'totQuest'
from poracle.humans a, poracle.quest b
where
a.name = 'XXA' and
a.id = b.id
);

create temporary table rmdb.tmp202
as(
select count(*) as 'totIncident'
from poracle.humans a, poracle.incident b
where
a.name = 'XXA' and
a.id = b.id
);

create temporary table rmdb.tmp203
as(
select count(*) as 'totRaid'
from poracle.humans a, poracle.raid b
where
a.name = 'XXA' and
a.id = b.id
);

create temporary table rmdb.tmp204
as(
select count(*) as 'totEgg'
from poracle.humans a, poracle.egg b
where
a.name = 'XXA' and
a.id = b.id
);

select
rpad(a.name,10,' ') as 'Name      ',
a.alerts_sent as 'Alerts',
rpad(a.area,20,' ') as 'Area               ',
a.enabled,
rpad(a.latitude,10,' ') as 'Latitude  ',
rpad(a.longitude,10,' ') as 'longitude ',
b.totMon as 'Mon',
c.totQuest as 'Quest',
d.totIncident as 'TR',
e.totRaid as 'Raids',
f.totEgg as 'Egg'
from
poracle.humans a,
rmdb.tmp200 b,
rmdb.tmp201 c,
rmdb.tmp202 d,
rmdb.tmp203 e,
rmdb.tmp204 f
where
name = 'XXA'
;

drop table rmdb.tmp200;
drop table rmdb.tmp201;
drop table rmdb.tmp202;
drop table rmdb.tmp203;
drop table rmdb.tmp204;
