/*
	Script purpose:  Backup the Dev proxy databases for one BOCES-type client and restore the backups as Prod Proxy databases
	
	There are some assumptions built into this script, mainly, that the database names will follow current convention, for example: Enrich_CLIENT_Dev_PROXY

	Instructions:  
	Verify that the Prod Proxy dbs have not already been created
		1. set @client = to the name of the client as the database is named.  ex: for db Enrich_NorthEastBoces_Dev client is NorthEastBoces
		2. set output to Text instead of Grid (type Ctrl-T)
		3. run query from 
			create table #Proxy_backup_restore 
				to 
			 ------------ run up to here (search for this text below)
		4. copy the output of the query from the results pane
		5. paste the resulting queries in SSMS query pane
		6. run the resulting query
		7. drop table #Proxy_backup_restore
*/

-- drop table #Proxy_backup_restore 
create table #Proxy_backup_restore (
DevProxyDb	varchar(100),
ProdProxyDb	varchar(100),
BackupFilePath	varchar(200),
DataFileName	varchar(100),
LogFileName	varchar(100),
ProdDataFilePath	varchar(255),
ProdLogFilePath		varchar(255)
)

declare @db varchar(100), 
	@dt char(8), 
	@client varchar(50), 
	@devdb varchar(100)
select @dt = convert(char(4), DATEPART(yy, getdate()))+right('0'+convert(varchar(2), DATEPART(mm, getdate())), 2)+right('0'+convert(varchar(2), DATEPART(dd, getdate())), 2)
-- ================================================================================================================
									set @client = 'Mountain'
-- ================================================================================================================
set @devdb = 'Enrich_'+@client+'_Dev'

-- truncate table #Proxy_backup_restore 
insert #Proxy_backup_restore (DevProxyDb, ProdProxyDb, BackupFilePath)
select 
	name,
	replace(name, '_Dev', '_Prod'),
	'D:\Backup\'+@client+'\'+name+'_'+@dt+'.bak' 
from sys.databases where name like @devdb+'[_]%' and name not in (select DevProxyDb from #Proxy_backup_restore) order by name


set nocount on;
select 'update bu set 
	datafilename = (select name from '+DevProxyDb+'.sys.database_files where Type = 0),
	logfilename = (select name from '+DevProxyDb+'.sys.database_files where Type = 1),
	ProdDataFilePath = (select replace(physical_name, ''_Dev_'', ''_Prod_'') from '+DevProxyDb+'.sys.database_files where Type = 0),
	ProdLogFilePath = (select replace(physical_name, ''_Dev_'', ''_Prod_'') from '+DevProxyDb+'.sys.database_files where Type = 1)
from #Proxy_backup_restore bu
where DevProxyDb = '''+DevProxyDb+'''

'
from #Proxy_backup_restore 


-- backup and restore
select 'BACKUP DATABASE ['+DevProxyDb+'] 
	TO  DISK = N'''+BackupFilePath+''' 
	WITH NOFORMAT, NOINIT,  
	NAME = N'''+DevProxyDb+'-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

RESTORE DATABASE ['+replace(DevProxyDb, '_Dev_', '_Prod_')+'] 
	FROM  DISK = N'''+BackupFilePath+'''
	WITH  FILE = 1,
	MOVE N'''+DataFileName+''' TO N'''+ProdDataFilePath+''',
	MOVE N'''+LogFileName+''' TO N'''+ProdLogFilePath+''',
	NOUNLOAD, REPLACE, STATS = 10


'
from #Proxy_backup_restore


------------------------------ run up to here

------------------------------ paste results below this line

/*
BACKUP DATABASE [Enrich_Mountain_Dev_Aspen] 
	TO  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Aspen_20130805.bak' 
	WITH NOFORMAT, NOINIT,  
	NAME = N'Enrich_Mountain_Dev_Aspen-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

RESTORE DATABASE [Enrich_Mountain_Prod_Aspen] 
	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Aspen_20130805.bak'
	WITH  FILE = 1,
	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Aspen.mdf',
	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Aspen_1.ldf',
	NOUNLOAD, REPLACE, STATS = 10


BACKUP DATABASE [Enrich_Mountain_Dev_Garfield16] 
	TO  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Garfield16_20130805.bak' 
	WITH NOFORMAT, NOINIT,  
	NAME = N'Enrich_Mountain_Dev_Garfield16-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

RESTORE DATABASE [Enrich_Mountain_Prod_Garfield16] 
	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Garfield16_20130805.bak'
	WITH  FILE = 1,
	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Garfield16.mdf',
	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Garfield16.ldf',
	NOUNLOAD, REPLACE, STATS = 10


BACKUP DATABASE [Enrich_Mountain_Dev_Lake] 
	TO  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Lake_20130805.bak' 
	WITH NOFORMAT, NOINIT,  
	NAME = N'Enrich_Mountain_Dev_Lake-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

RESTORE DATABASE [Enrich_Mountain_Prod_Lake] 
	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Lake_20130805.bak'
	WITH  FILE = 1,
	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Lake.mdf',
	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Lake_1.ldf',
	NOUNLOAD, REPLACE, STATS = 10


BACKUP DATABASE [Enrich_Mountain_Dev_Summit] 
	TO  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Summit_20130805.bak' 
	WITH NOFORMAT, NOINIT,  
	NAME = N'Enrich_Mountain_Dev_Summit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

RESTORE DATABASE [Enrich_Mountain_Prod_Summit] 
	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Summit_20130805.bak'
	WITH  FILE = 1,
	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Summit.mdf',
	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Summit_1.ldf',
	NOUNLOAD, REPLACE, STATS = 10

*/








---- just the restore
--select 'RESTORE DATABASE ['+replace(DevProxyDb, '_Dev_', '_Prod_')+'] 
--	FROM  DISK = N'''+BackupFilePath+'''
--	WITH  FILE = 1,
--	MOVE N'''+DataFileName+''' TO N'''+ProdDataFilePath+''',
--	MOVE N'''+LogFileName+''' TO N'''+ProdLogFilePath+''',
--	NOUNLOAD,
--	REPLACE,
--	STATS = 10

--'
--from #Proxy_backup_restore






--RESTORE DATABASE [Enrich_Mountain_Prod_Aspen] 
--	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Aspen_20130805.bak'
--	WITH  FILE = 1,
--	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Aspen.mdf',
--	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Aspen_1.ldf',
--	NOUNLOAD,
--	REPLACE,
--	STATS = 10

--RESTORE DATABASE [Enrich_Mountain_Prod_Garfield16] 
--	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Garfield16_20130805.bak'
--	WITH  FILE = 1,
--	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Garfield16.mdf',
--	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Garfield16.ldf',
--	NOUNLOAD,
--	REPLACE,
--	STATS = 10

--RESTORE DATABASE [Enrich_Mountain_Prod_Lake] 
--	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Lake_20130805.bak'
--	WITH  FILE = 1,
--	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Lake.mdf',
--	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Lake_1.ldf',
--	NOUNLOAD,
--	REPLACE,
--	STATS = 10

--RESTORE DATABASE [Enrich_Mountain_Prod_Summit] 
--	FROM  DISK = N'D:\Backup\Mountain\Enrich_Mountain_Dev_Summit_20130805.bak'
--	WITH  FILE = 1,
--	MOVE N'Enrich_Data' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Summit.mdf',
--	MOVE N'Enrich_Log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\Enrich_Mountain_Prod_Summit_1.ldf',
--	NOUNLOAD,
--	REPLACE,
--	STATS = 10




--declare DB cursor for 
--select name from sys.databases where name like 'Enrich[_]%'+@client+'[_]Dev[_]%' order by name

--open DB
--fetch DB into @db

--while @@FETCH_STATUS = 0
--begin

--set @backupfilepath = 'D:\Backup\'+@client+'\'+@db+'_'+@dt+'.bak'

--print @backupfilepath




--print 'BACKUP DATABASE ['+@db+'] 
--	TO  DISK = N''D:\Backup\'+@client+'\'+@db+'_'+@dt+'.bak'' 
--	WITH NOFORMAT, NOINIT,  
--	NAME = N'''+@db+'-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

--'

--fetch DB into @db
--end
--close DB
--deallocate DB

--select * from #Proxy_backup_restore

--drop table #Proxy_backup_restore



/*

RESTORE DATABASE [Enrich_Prod] 
	FROM  DISK = N'E:\SQL\2012\MSSQL11.SQL2012\MSSQL\Backup\CO\Eagle\Enrich_Eagle_Dev_20130731.bak'
	WITH  FILE = 1,
	MOVE N'TestView_Data' TO N'N:\Enrich_Prod\Enrich_Prod_Data.mdf',
	MOVE N'TestView_Log' TO N'O:\Enrich_Prod\Enrich_Prod_log.ldf',
	NOUNLOAD,
	REPLACE,
	STATS = 10

-- query to find the data file logical name and data full file path 

select name, physical_name, type from Enrich_Mountain_Dev_Aspen.sys.database_files 


*/


