exec sp_dboption 'Enrich_DC3_FL_Polk', 'single user', 'FALSE';

--Msg 5064, Level 16, State 1, Line 1
--Changes to the state or options of database 'Enrich_Dev' cannot be made at this time. The database is in single-user mode, and a user is currently connected to it.
--Msg 5069, Level 16, State 1, Line 1
--ALTER DATABASE statement failed.
--sp_dboption command failed.

select d.name, d.dbid, spid, login_time, nt_domain, nt_username, loginame
  from sysprocesses p inner join sysdatabases d on p.dbid = d.dbid
 where d.name = 'Enrich_DC3_FL_Polk'
go

kill 52
