





select * from UserProfile


select o.name from sys.objects o where type = 'U' and name like '%role%'





select * from SecurityRole


SELECT T.name AS TableName, 
	C.name AS ColumnName 
FROM syscolumns C 
INNER JOIN sysobjects T 
ON T.id = C.id
WHERE C.is_identity = 1

select o.name, c.*
from sysobjects o
join syscolumns c on o.id = c.id
where o.type = 'U'
and o.name = 'ccstudent'

SELECT c.table_name Tbl, c.column_name Col, c.ordinal_position ColumnNumber, c.data_type DataType 
FROM INFORMATION_SCHEMA.COLUMNS c (NOLOCK)
join SeqNum q on c.table_name = q.TableName
where COLUMNPROPERTY (OBJECT_ID(c.Table_Name),c.Column_Name,'IsIdentity') = 1
order by c.table_name





-- tables with identity columns 
SELECT c.table_name Tbl, isnull(c.column_name,'') IdentityColumn, c.ordinal_position ColumnNumber, c.data_type DataType, R RowCnt
FROM INFORMATION_SCHEMA.COLUMNS c (NOLOCK)
join #RowCounts rc on c.table_name = rc.tbl
join SeqNum q on c.table_name = q.TableName
where COLUMNPROPERTY (OBJECT_ID(c.Table_Name),c.Column_Name,'IsIdentity') = 1
and rc.R > 0
order by c.table_name














set nocount on;
create table #RowCounts (tbl varchar(50), R int)

declare @t varchar(100)
declare T cursor for 
select name from sysobjects where type = 'U' order by name
open T
fetch T into @t
while @@fetch_status = 0
begin
exec ('insert #RowCounts select '''+@t+''' Tablename, count(*) as Rows from '+@t)
fetch T into @t
end
close T
deallocate T

set nocount off;
-- tables with identity columns 

select c.Tbl, isnull(i.IdentityColumn, '') IdCol, isnull(convert(varchar(3), i.ColumnNumber),'') IdColNbr, isnull(i.DataType,'') IdDataType, c.R RowCnt, q.NextID SeqNumID
from #RowCounts c
join SeqNum q on c.tbl = q.TableName
left join (
	SELECT c.table_name Tbl, isnull(c.column_name,'') IdentityColumn, c.ordinal_position ColumnNumber, c.data_type DataType
	FROM INFORMATION_SCHEMA.COLUMNS c (NOLOCK)
	where COLUMNPROPERTY (OBJECT_ID(c.Table_Name),c.Column_Name,'IsIdentity') = 1
	) i on c.Tbl = i.Tbl
where c.R > 0
order by c.Tbl


drop table #RowCounts 










-- don't count these
--select * from #RowCounts where R = 0







