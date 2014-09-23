create table #FixSeqNum (
Tbl varchar(100),
MaxSeq int)

set nocount on;
declare @tc table (
Tbl varchar(100),
Col varchar(100)
)

insert @tc values ('COSSupportingEvidenceTbl ', 'COSSESeqNum')
insert @tc values ('COSTeamTbl ', 'COSTeamSeqNum')
insert @tc values ('GoalTbl ', 'GoalSeqNum')
insert @tc values ('IEPBIPTbl ', 'IEPBIPSeqNum')
insert @tc values ('ObjProgTbl ', 'RecNum')
insert @tc values ('ObjTbl ', 'ObjSeqNum')
insert @tc values ('SEEMTemplateFieldTbl ', 'RecNum')
insert @tc values ('SEEMTemplateTbl ', 'TemplateID')
insert @tc values ('SEEMTbl ', 'SeemID')
insert @tc values ('SC_PlaceHistoryFactorsTbl ', 'PHFRecNum')
insert @tc values ('MessageTbl ', 'MessageID')
insert @tc values ('AccessRoles ', 'RoleID')

declare @t varchar(100), @c varchar(100)

declare T cursor for 
select q.TableName, col = c.name
from SeqNum q join 
sysobjects o on q.tablename = o.name left join
syscolumns c on o.id = c.id and (c.name = 'RecNum' or c.name like '%Seq' or c.name like '%SeqNum') left join 
systypes t on c.xusertype = t.xusertype 
where o.name not in ('SeqNum', 'GoalProgTbl', 'ServiceLogTbl', 'IEPLREDocTbl', 'IEPComplSSISData', 'Diagnosistbl', 'DomainSubTbl', 'GoalProgTbl') and o.Type = 'U'
and c.colstat & 1 != 1  -- not an identity column
and (c.name = 
	(select max(tc.col) from @tc tc where q.TableName = tc.Tbl and c.name = tc.Col)
	 or
	 q.TableName not in (select tbl from @tc )
	 )
order by TableName


open T
fetch T into @t, @c

while @@fetch_status = 0
begin

exec ('insert #FixSeqNum 
select '''+@t+''' Tbl, max('+@c+') Max'+@c+'  from '+@t)

fetch T into @t, @c
end
close T 
deallocate T


-- select * from #FixSeqNum 

update q set NextID = f..MaxSeq from #FixSeqNum f join SeqNum q on f.Tablename = q.Tablename 

drop table #FixSeqNum 


