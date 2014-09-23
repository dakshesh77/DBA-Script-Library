/*
	Find any city, state or zipcode field that is not null and change the city state or zip to that of the 
	local district headquarters.

*/

set nocount on;
declare @t varchar(50), @c varchar(50), @newcity varchar(100), @newstate char(2), @newzip varchar(20) ; 
select 
	@newcity = 'YourCityHere',
	@newstate = 'FL',
	@newzip = '31111-1111'

declare A INSENSITIVE cursor for
select o.name, c.name
from sys.schemas s
join sys.objects o on s.schema_id = o.schema_id
join sys.columns c on o.object_id = c.object_id
join sys.types t on c.user_type_id = t.user_type_id
where s.name = 'dbo'
and o.type ='U'
and t.name like '%char%'
and (
	(
	(c.name like '%State%' and c.max_length = 2)
	or
	c.name like '%city%'
	or
	c.name like '%zip%'
	)
	and c.name not like '%ethnicity%'
	and c.name not like '%statement%'
	)
order by o.name, c.name
-- order by case when c.name like '%city%' then 1 when c.name like '%state%' then 2 when c.name like '%zip%' then 3 else 4 end, t.name, c.name, o.name

open A

fetch A into @t, @c

while @@fetch_status = 0
begin

-- print 'select '+@c+' from dbo.'+@t+' where '+@c+' is not null'
print 'update '+@t+' set '+@c+' = '''+case 
		when @c like '%City%' then @newcity 
		when @c like '%State%' then @newstate
		when @c like '%Zip%' then @newzip
		end+''' where isnull('+@c+', '''') <> '''''

fetch A into @t, @c
end

close A
deallocate A
go

