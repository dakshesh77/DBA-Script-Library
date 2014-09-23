declare @t varchar(100)
declare T cursor for 
select name from sysobjects where type = 'U' order by name
open T
fetch T into @t
while @@fetch_status = 0
begin
exec ('select '''+@t+''' Tablename, count(*) as Rows from '+@t)
fetch T into @t
end
close T
deallocate T
