set nocount on;
declare @s varchar(100), @t varchar(100), @c varchar(100), @txt varchar(100) ;

select @txt = 'Evaluating'
-- select @txt = '''%%'''

declare TC cursor for
select s.name, o.name, c.name
	-- , t.name, c.max_length
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id join
sys.columns c on o.object_id = c.object_id join
sys.types t on c.user_type_id = t.user_type_id 
where o.type = 'U'
and ((t.name like '%varchar%' and c.max_length >= 20) or t.name like '%text%') -- change max length if necessary
and s.name = 'dbo'
-- and (s.name = 'dbo' and o.name not like '%[_]%')

open TC

fetch TC into @s, @t, @c 

while @@FETCH_STATUS = 0
begin

exec ('if exists (select 1 from '+@s+'.'+@t+' where ['+@c+'] like '''+@txt+''')
begin
	print '''+@s+'.'+@t+'''
	select * from '+@s+'.'+@t+' where ['+@c+'] like '''+@txt+'''
end
')
--print 'if exists (select 1 from '+@s+'.'+@t+' where ['+@c+'] like '''+@txt+''')
--select * from '+@s+'.'+@t+' where ['+@c+'] like '''+@txt+'''

--'


fetch TC into @s, @t, @c 
end
close TC
deallocate TC

