
begin tran

declare @s varchar(150), @o varchar(150), @c varchar(150), @TossID varchar(36), @KeepID varchar(36), @g varchar(36) ; -- select @g = '4A3CAFC3-9431-4845-8AD9-167E30E47DDA'

select @TossID = '', @KeepID = ''

--this cursor will check for the existance of the specific EnumValue ID everywhere it exists in the database (as a GUID) and update it to the new value
-- this operation is especially important to update the SIS import MAP table DestID
declare G cursor for 
select TossID, KeepID from @MAP

open G
fetch G into @TossID, @KeepID

while @@fetch_status = 0
begin

set @g = @TossID

	declare OC cursor for 
	select s.name, o.name, c.name
	from sys.schemas s join
	sys.objects o on s.schema_id = o.schema_id join 
	sys.columns c on o.object_id = c.object_id join
	sys.types t on c.user_type_id = t.user_type_id
	where o.type = 'U'
	and t.name = 'uniqueidentifier'
	and o.name <> 'EnumValue' -- don't touch this!
--	and o.name not in ('ServiceDef', 'IepServiceDef', 'MAP_ServiceDefID')
	order by o.name, c.name

	open OC
	fetch OC into @s, @o, @c

	while @@FETCH_STATUS = 0
	begin

	exec ('if exists (select 1 from '+@s+'.'+@o+' o where '+@c+' = '''+@g+''')
	print ''update x set '+@c+' = '''''+@KeepID+''''' from '+@s+'.'+@o+' x where '+@c+' = '''''+@TossID+''''' ''  ')
	

	fetch OC into @s, @o, @c
	end

	close OC
	deallocate OC

print ''

fetch G into @TossID, @KeepID
end
close G
deallocate G


-- rollback tran

-- commit tran



