-- declare @MyStatusList varchar(max);

--declare @MyStatus table (
-- [Status_Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
-- [StatusDesc] [varchar](25) NULL
--)

--INSERT INTO @MyStatus VALUES ('Active')
--INSERT INTO @MyStatus VALUES ('OnHold')
--INSERT INTO @MyStatus VALUES ('Disabled')
--INSERT INTO @MyStatus VALUES ('Closed')

--SET @MyStatusList = ''
--SELECT @MyStatusList = ISNULL(@MyStatusList,'') + StatusDesc + ',' 
--from (SELECT DISTINCT StatusDesc FROM @MyStatus) x

--SET @MyStatusList = SUBSTRING(@MyStatusList, 1, LEN(@MyStatusList)-1) 
--SELECT @MyStatusList

-- http://www.sqlservercentral.com/articles/cursor/72538/

--Active,Closed,Disabled,OnHold

declare @ColumnList varchar(max) ; select @ColumnList = ''
select @ColumnList = isnull(@ColumnList,'')+c.name+', '
--select c.*
from (select distinct c.column_id, c.name from sys.objects o join sys.columns c on o.object_id = c.object_id where o.name = 'LoadTable') c
select @ColumnList = left(@ColumnList, len(@ColumnList)-2)
print @ColumnList


-- ID, ExtractDatabase, Sequence, SourceTable, DestTable, HasMapTable, MapTable, KeyField, DeleteKey, ImportType, DeleteTrans, UpdateTrans, InsertTrans, Enabled, SourceTableFilter, DestTableFilter, PurgeCondition, KeepMappingAfterDelete, StartNewTransaction, LastLoadDate
-- ID, ExtractDatabase, Sequence, SourceTable, DestTable, HasMapTable, MapTable, KeyField, DeleteKey, ImportType, DeleteTrans, UpdateTrans, InsertTrans, Enabled, SourceTableFilter, DestTableFilter, PurgeCondition, KeepMappingAfterDelete, StartNewTransaction, LastLoadDate
-- ID, ExtractDatabase, Sequence, SourceTable, DestTable, HasMapTable, MapTable, KeyField, DeleteKey, ImportType, DeleteTrans, UpdateTrans, InsertTrans, Enabled, SourceTableFilter, DestTableFilter, PurgeCondition, KeepMappingAfterDelete, StartNewTransaction, LastLoadDate



declare @ColumnList varchar(max) ; select @ColumnList = ''
select @ColumnList = isnull(@ColumnList,'')+c.name+', '
--select c.*
from (select c.name from sys.objects o join sys.columns c on o.object_id = c.object_id where o.name = 'CCStudent') c
select @ColumnList = left(@ColumnList, len(rtrim(@ColumnList))-1)
print @ColumnList

