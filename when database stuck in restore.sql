
sp_resetstatus Enrich_DC3_FL_Polk

Use Enrich_DC3_FL_Polk

dbcc checkdb


RESTORE DATABASE Enrich_DC3_FL_Polk
WITH RECOVERY

select * from Setup order by installdate desc

--alter table SystemSettings
--add DistrictLogoID uniqueidentifier null

use master 
go
-- when stuck restoring
RESTORE DATABASE Enrich_DC4_FL_Collier
   FROM DISK = 'E:\SQL\Backup\Enrich\FL\Collier\Enrich_Staging_20121217_0639.bak'
   WITH REPLACE,RECOVERY

--Processed 191536 pages for database 'Enrich_DC4_FL_Collier', file 'TestView_Data' on file 1.
--Processed 3 pages for database 'Enrich_DC4_FL_Collier', file 'TestView_Log' on file 1.
--RESTORE DATABASE successfully processed 191539 pages in 61.751 seconds (24.232 MB/sec).


-- when stuck restoring
RESTORE DATABASE MyDatabase
   FROM DISK = 'MyDatabase.bak'
   WITH REPLACE,RECOVERY
--   

-- when a hidden process cannot be killed
EXEC sp_dboption N'Marion1_EO', N'offline', N'true'
-- then use SSMS gui to bring it back online



