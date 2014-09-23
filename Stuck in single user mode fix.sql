select * from setup order by InstallDate desc
ALTER DATABASE Enrich_DC4_FL_Collier_SQL2012 SET MULTI_USER WITH ROLLBACK IMMEDIATE




use master
go
declare @kill_spid varchar(20)
-- Find spid of user connection to database test
select @kill_spid= max(spid) from master.dbo.sysprocesses
where dbid in ( select dbid from sysdatabases where name = 'Enrich_DC4_FL_Collier_SQL2012' )

select [Connection to Kill] = @kill_spid

-- Kill connection to db Enrich_DC4_FL_Collier_SQL2012
exec ('kill '+@kill_spid )
go
-- set DB test ofline
alter database Enrich_DC4_FL_Collier_SQL2012 set offline with rollback immediate
go
-- Bring DB test online in multi user mode
alter database Enrich_DC4_FL_Collier_SQL2012 set online, multi_user with rollback immediate
go
use Enrich_DC4_FL_Collier_SQL2012
select Current_DB = db_name()
go
use master



