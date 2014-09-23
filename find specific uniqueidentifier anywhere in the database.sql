
set nocount on;

create table #UQ_tables_and_columns (
query varchar(max)
)


declare @t varchar(50), @c varchar(50), @id varchar(36), @q varchar(max) ; select @q = 'dummy', @id = 'BE5355B2-05E1-49FF-9A1B-22F762C0790B'

declare U cursor for
select o.name, c.name
from sys.schemas s join
sys.objects o on s.schema_id = o.schema_id join 
sys.columns c on o.object_id = c.object_id join
sys.types t on c.user_type_id = t.user_type_id 
where s.name = 'dbo'
and o.name not like '%[_]%'
and o.type = 'U'
-- and t.name = 'uniqueidentifier' 
and (t.name = 'uniqueidentifier' or t.name = 'varchar' and c.max_length = 150)
order by o.name, c.column_id

open U 
fetch U into @t, @c 

while @@FETCH_STATUS = 0
begin

select @q = '
if exists (select 1 from '+@t+' where '+@c+' = '''+@id+''')
insert #UQ_tables_and_columns values (''select * from '+@t+' where '+@c+' = '''''+@id+''''''')

'
exec (@q)

fetch U into @t, @c 
end
close U
deallocate U


select * from #UQ_tables_and_columns 
drop table #UQ_tables_and_columns 
