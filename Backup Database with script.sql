
-- create and set variables for Customer, instance and Path.  Consider COPY_ONLY.


declare @filedate varchar(13) ; select @filedate = replace(replace(replace(convert(varchar, getdate(), 120), '-', ''), ':', ''), ' ', '_')
exec ('BACKUP DATABASE [Enrich_Production] 
TO  DISK = N''S:\ENRICH\Data\BACKUP\Collier_Enrich_Produuction_'+@filedate+'.bak''
WITH  COPY_ONLY, 
NOFORMAT, 
NOINIT,  
NAME = N''Enrich_Production-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10')

