set nocount on
declare @t varchar(50), @c varchar(50), @newdomain varchar(50) ;
select @newdomain = 'YourDomainHere'

declare M INSENSITIVE cursor for
select o.name, c.name
from sys.schemas s
join sys.objects o on s.schema_id = o.schema_id
join sys.columns c on o.object_id = c.object_id
join sys.types t on c.user_type_id = t.user_type_id
where s.name = 'dbo'
and o.type ='U'
and t.name like '%char%'
and c.name like '%email%'
and (c.name not like '%subj%' and c.name not like '%attr%')
order by o.name, c.name

OPEN M
fetch M into @t, @c
while @@Fetch_status = 0
Begin

print 'update '+@t+' set '+@c+' = substring('+@c+', 1, charindex(''@'', '+@c+'))+'''+@newdomain+''''

fetch M into @t, @c
End
close M
deallocate M
go


-- select UpdateEmailAddress from SystemSettings -- george.giddens@excent.com
-- select UpdateEmailAddress from SystemSettings -- george.giddens@YourDomainHere

-- update SystemSettings set UpdateEmailAddress = substring(UpdateEmailAddress, 1, charindex('@', UpdateEmailAddress))+'YourDomainHere'
