select '@'+c.name+'	'+t.name+case when t.name like '%char%' then '('+convert(varchar(10), c.max_length)+')' else '' end + case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '' else ',' end
from sys.objects o
join sys.columns c on o.object_id = c.object_id 
join sys.types t on c.user_type_id = t.user_type_id
where o.name = 'PrgItemDef'
