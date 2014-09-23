
declare @db varchar(100) ; -- testing select @db = 'Enrich_CO_CDE_Template'

declare DB cursor for 
select name from sys.databases where name like 'Enrich[_]%' order by name

open DB
fetch DB into @db

while @@FETCH_STATUS = 0
begin

print 'BACKUP DATABASE ['+@db+'] TO  DISK = N''D:\Backup\20120411 pre-selectlists update\'+@db+'_20120411.bak'' WITH NOFORMAT, NOINIT,  NAME = N'''+@db+'-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

fetch DB into @db
end
close DB
deallocate DB
