declare @t nvarchar(50), @g uniqueidentifier; select @g = gstudentid from student where studentid = '61745'

declare T cursor for 
select right(o.name, len(o.name)-2) IEPTbl
from sysobjects o
join syscolumns c on o.id = c.id
where o.name like 'IC%'
and o.name not like '%Goal%' and o.name not like '%Obj%' and o.name not like '%Error%'
and c.name = 'GStudentId'

open T
fetch T into @t
while @@fetch_status = 0
begin

exec ('select top 1 * from '+@t+' where isnull(del_flag,0)=0')

fetch T into @t
end
close T
deallocate T


IF  EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[ICIEPTransferTbl]') AND name = N'PK_ICIEPTransferTbl')
ALTER TABLE [dbo].[ICIEPTransferTbl] DROP CONSTRAINT [PK_ICIEPTransferTbl]


