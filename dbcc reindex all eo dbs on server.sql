
set nocount on;
declare @svr nvarchar(50), @db nvarchar(50) ; 



--print '[10.10.10.118]'

declare DB cursor for 
select name from master.dbo.sysdatabases where name like '%_SC_EO' order by name

open DB

fetch DB into @db
while @@fetch_status = 0
begin

print convert(nvarchar, getdate())+'  =  '+@db
exec ('dbcc dbreindex (['+@db+'.dbo.StaffRights])')
exec ('dbcc dbreindex (['+@db+'.dbo.AccessMembers])')
exec ('dbcc dbreindex (['+@db+'.dbo.StudentUserRights])')

fetch DB into @db
end
close DB
deallocate DB


--
--print '[10.10.10.119]'
--
--
--declare DB cursor for 
--select name from sysdatabases where name like '%_SC_EO' order by name
--open DB
--fetch DB into @db
--while @@fetch_status = 0
--begin
--
--print convert(nvarchar, getdate())+'  =  '+@db
--exec ('dbcc dbreindex (['+@db+'.dbo.StaffRights])')
--exec ('dbcc dbreindex (['+@db+'.dbo.AccessMembers])')
--exec ('dbcc dbreindex (['+@db+'.dbo.StudentUserRights])')
--
--fetch DB into @db
--end
--close DB
--deallocate DB
--
--print '[10.10.10.121]'
--
--declare DB cursor for 
--select name from [10.10.10.121].master.dbo.sysdatabases where name like '%_SC_EO' order by name
--
--open DB
--
--fetch DB into @db
--while @@fetch_status = 0
--begin
--
--print convert(nvarchar, getdate())+'  =  '+@db
--exec ('dbcc dbreindex (['+@db+'.dbo.StaffRights])')
--exec ('dbcc dbreindex (['+@db+'.dbo.AccessMembers])')
--exec ('dbcc dbreindex (['+@db+'.dbo.StudentUserRights])')
--
--fetch DB into @db
--end
--close DB
--deallocate DB

