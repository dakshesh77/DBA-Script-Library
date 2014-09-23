RESTORE DATABASE [Enrich_Prod] 
	FROM  DISK = N'E:\SQL\Backup\Enrich\CO\Aurora\Aurora_Enrich_DB_3419_20120528.bak' 
	WITH  FILE = 1,  
	MOVE N'TestView_Data' TO N'N:\Enrich_Prod\Enrich_Prod_Data.mdf',  
	MOVE N'TestView_Log' TO N'O:\Enrich_Prod\Enrich_Prod_log.ldf',  
	NOUNLOAD,  
	REPLACE,  
	STATS = 10





