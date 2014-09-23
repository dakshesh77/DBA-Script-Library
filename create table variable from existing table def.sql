-- SQL 2000
select c.name, t.name+
	case when t.name like '%char%' then '('+convert(varchar, c.prec)+')' else '' end+
	case when c.isnullable = 0 then '	NOT NULL,' else ',' end
from sysobjects o
left join syscolumns c on o.id = c.id
left join systypes t on c.xusertype = t.xusertype
where o.name = 'ReportCCErrorCheck' -- and c.name = 'sourcetbl'
order by c.colorder



-- SQL 2005
select c.name, t.name+
	case when t.name like '%char%' then '('+convert(varchar, c.max_length)+')' else '' end+
	case when c.is_nullable = 0 then '	NOT NULL,' else ',' end
	from sys.schemas s 
left join sys.objects o on s.schema_id = o.schema_id
left join sys.columns c on o.object_id = c.object_id
left join sys.types t on c.user_type_id = t.user_type_id
where s.name = 'dbo'
and o.name = 'PrgStatus' -- and c.name = 'sourcetbl'
order by c.column_id


