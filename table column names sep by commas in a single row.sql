declare @cs varchar(max) ; set @cs = ''
select @cs = @cs+c.name+ case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '' else ', ' end
from sys.objects o
join sys.columns c on o.object_id = c.object_id 
where o.name = 'IepDatesSectionDef'
print @cs
