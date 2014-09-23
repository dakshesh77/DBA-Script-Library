
Use Master
Go
RESTORE DATABASE Enrich_DC4_FL_Collier
FROM DISK = 'E:\SQL\Backup\Enrich\FL\Collier\Collier_Enrich_Staging_20130328.bak'
WITH MOVE 'TestView_Data' TO 'E:\SQL\Data\Enrich_DC4_FL_Collier.mdf',--adjust path
MOVE 'TestView_og' TO 'E:\SQL\Data\Enrich_DC4_FL_Collier.ldf' 











