set nocount on
declare @tablename varchar(30)
declare TABLES_cursor cursor for
select o.name from sysobjects o, syscolumns c where o.id = c.id and o.type = 'U' and c.name = 'email'
OPEN TABLES_cursor
fetch next from Tables_cursor into @tablename
while @@Fetch_status = 0
Begin
exec ('update '+@tablename +' set email = substring(email, 1, charindex(''@'', email))+''hss.email''')
	fetch next from Tables_cursor into @tablename
End
close tables_cursor
deallocate tables_cursor
go

update staff set loginpwd = 'admin1' where loginname = 'admin'

