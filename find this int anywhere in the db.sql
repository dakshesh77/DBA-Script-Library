set nocount on;
declare @s varchar(100), @t varchar(100), @c varchar(100), @txt varchar(100) ;

select @txt = '995'
-- select @txt = '''%%'''

declare TC cursor for
select s.name, o.name, c.name
	-- , t.name, c.max_length
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id join
sys.columns c on o.object_id = c.object_id join
sys.types t on c.user_type_id = t.user_type_id 
where o.type = 'U'
and t.name = 'int' 
and s.name = 'dbo'

open TC

fetch TC into @s, @t, @c 

while @@FETCH_STATUS = 0
begin

exec ('if exists (select 1 from '+@s+'.'+@t+' where ['+@c+'] = '+@txt+')
begin
	print ''select * from '+@t+' where '+@c+' = '+@txt+'''
	-- select * from '+@s+'.'+@t+' where ['+@c+'] = '+@txt+'
end
')
--print 'if exists (select 1 from '+@s+'.'+@t+' where ['+@c+'] like '''+@txt+''')
--select * from '+@s+'.'+@t+' where ['+@c+'] like '''+@txt+'''

--'


fetch TC into @s, @t, @c 
end
close TC
deallocate TC





select * from AssessmentTest where AssessmentID = 995


