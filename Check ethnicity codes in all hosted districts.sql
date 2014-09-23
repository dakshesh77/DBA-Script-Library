
-- sp_addlinkedserver [10.10.10.119]
-- sp_addlinkedserver [10.10.10.121]
-- sp_addlinkedserver [10.10.10.118]


set nocount on;
declare @svr nvarchar(50), @db nvarchar(50) ; 

-- drop table #Ethnicities 
create table #Ethnicities (Id int not null identity(1,1), DbName nvarchar(50) not null, EthnicityCode nvarchar(20) not null, EthnicityDesc nvarchar(80) not null)


-- select cast ('[10.10.10.118]' as nvarchar(50)) Server union all select '[10.10.10.119]' union all select '[10.10.10.121]'

print '[10.10.10.118]'

declare DB cursor for 
select name from [10.10.10.118].master.dbo.sysdatabases where name like '%_SC_EO' order by name

open DB

fetch DB into @db
while @@fetch_status = 0
begin

exec ('insert #Ethnicities (dbname, EthnicityCode, EthnicityDesc) 
select '''+@db+''', code, lookdesc from [10.10.10.118].'+@db+'.dbo.codedesclook where usageid = ''ethnicity''
')

fetch DB into @db
end
close DB
deallocate DB



print '[10.10.10.119]'



declare DB cursor for 
select name from [10.10.10.119].master.dbo.sysdatabases where name like '%_SC_EO' order by name

open DB

fetch DB into @db
while @@fetch_status = 0
begin

exec ('insert #Ethnicities (dbname, EthnicityCode, EthnicityDesc) 
select '''+@db+''', code, lookdesc from [10.10.10.119].'+@db+'.dbo.codedesclook where usageid = ''ethnicity''
')

fetch DB into @db
end
close DB
deallocate DB



print '[10.10.10.121]'



declare DB cursor for 
select name from [10.10.10.121].master.dbo.sysdatabases where name like '%_SC_EO' order by name

open DB

fetch DB into @db
while @@fetch_status = 0
begin

exec ('insert #Ethnicities (dbname, EthnicityCode, EthnicityDesc) 
select '''+@db+''', code, lookdesc from [10.10.10.121].'+@db+'.dbo.codedesclook where usageid = ''ethnicity''
')

fetch DB into @db
end
close DB
deallocate DB








/*

select * from #Ethnicities

select EthnicityCode, EthnicityDesc, count(*) tot
from #Ethnicities
group by EthnicityCode, EthnicityDesc
order by tot desc, EthnicityCode, EthnicityDesc


select t.*, t2.tot
from (
	select EthnicityCode, EthnicityDesc, count(*) tot
	from #Ethnicities
	group by EthnicityCode, EthnicityDesc
	) t2
join #Ethnicities t on t2.ethnicitycode = t.ethnicitycode and t2.EthnicityDesc = t.EthnicityDesc
where t2.tot < 80
order by t.dbname, t.EthnicityCode, t.EthnicityDesc


select * from #Ethnicities where EthnicityCode = 'C'




*/
