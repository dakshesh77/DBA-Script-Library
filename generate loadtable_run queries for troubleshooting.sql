--select name, * from VC3ETL.ExtractDatabase
set nocount on;

select 'print ''-- Sequence : '+ convert(varchar(3), t.sequence) +' '+t.SourceTable+isnull(' to '+t.DestTable,'')+'''
exec VC3ETL.LoadTable_Run '''+convert(varchar(36), t.ID)+''', '''', 1, 0 
'
from vc3etl.LoadTable t
where ExtractDatabase = '004B264C-83C2-4BC9-8140-8BEE09B7FD06'
and enabled = 1
order by Sequence
