

DECLARE @DataDictionary table( 
RowID [int] identity(1,1) primary key 
,TableName [varchar](200) 
, ColumnName [varchar](200) 
, OrdinalPosition int 
, ColumnDefault [varchar](200) 
, IsNullable [bit] 
, DataType [varchar](20) 
, CharacterMaximumLength int 
, IsIdentity [varchar](5) --[bit] 
, IsPrimaryKey [bit] 
, IsForeignKey [bit] 
, ReferencedTableName [varchar](200) 
, ReferencedColumnName [varchar](200) 
, ObjectDescription [varchar](500) 
) 


DECLARE @TableList table( 
RowID [int] identity(1,1) primary key 
,TableCatalog [varchar](200) 
,TableSchema [varchar](200) 
,TableName [varchar](200) 
,TableType [varchar](20) 
,ObjectDescription [varchar](500) 
) 

DECLARE 
@RowNumber int 
, @RowCount int 
, @TableName varchar(255) 
, @ObjectDescription varchar(500) 


--create a temp table to hold the primary keys 
--can't do INSERT EXEC with a table variable 
IF object_id('tempdb..#PkColumns') is not null 
BEGIN 
DROP TABLE #PkColumns 
END 

CREATE TABLE #PkColumns ( 
RowID [int] identity(1,1) primary key 
,table_Qualifier varchar(255) NOT NULL 
, owner_name varchar(255) NOT NULL 
, table_name varchar(255) NOT NULL 
, column_name varchar(255) NOT NULL 
, key_seq varchar(255) NOT NULL 
, Pk_Name varchar(255) NOT NULL 
) 


--load the table list 
INSERT @TableList 
( 
TableCatalog 
,TableSchema 
,TableName 
,TableType 
,ObjectDescription 
) 

SELECT 
t.Table_Catalog 
,t.Table_Schema 
,t.Table_Name 
,t.Table_Type 
, CAST(IsNULL(e.value,'') as varchar(500)) 

FROM 
INFORMATION_SCHEMA.TABLES t 
LEFT JOIN ::FN_LISTEXTENDEDPROPERTY 
( 
'MS_Description' --standard description property 
,'user' 
,'dbo' 
,'table' --parent object type 
, @TableName -- parent object name 
, NULL --child object type 
, NULL --child object name from above	
) e 
ON t.Table_Name = e.objname 

WHERE 
t.Table_Type = 'BASE TABLE' 

SELECT @RowCount = Count(*) from @TableList 


--loop through the tables 
SET @RowNumber = 1 
WHILE @RowNumber <= @RowCount 
BEGIN 

SELECT 
@TableName = TableName 
,@ObjectDescription = ObjectDescription 
FROM 
@TableList 
WHERE 
RowID = @RowNumber 


--clear primary keys table 
DELETE #PkColumns 

--insert the primary key records retrieved by the system stored procedure 
INSERT #PkColumns 
EXEC	sp_pkeys @table_name= @TableName 


--insert the table name and description for header purposes 
INSERT @DataDictionary 
( 
TableName 
, ColumnName 
, OrdinalPosition 
, ColumnDefault 
, IsNullable 
, DataType 
, CharacterMaximumLength 
, IsIdentity 
, IsPrimaryKey 
, IsForeignKey 
, ReferencedTableName 
, ReferencedColumnName 
, ObjectDescription 
) 

VALUES 
( 
@TableName --TableName 
, '' --ColumnName 
, 0 --OrdinalPosition 
, '' --ColumnDefault 
, 0 --IsNullable 
, '' --DataType 
, 0 --CharacterMaximumLength 
, 0 --IsIdentity 
, 0 --IsPrimaryKey 
, 0 --IsForeignKey 
, '' --ReferencedTableName 
, '' --ReferencedColumnName 
, @ObjectDescription --ObjectDescription 
) 

--insert the column schema information 
INSERT @DataDictionary 
( 
TableName 
, ColumnName 
, OrdinalPosition 
, ColumnDefault 
, IsNullable 
, DataType 
, CharacterMaximumLength 
, IsIdentity 
, IsPrimaryKey 
, IsForeignKey 
, ReferencedTableName 
, ReferencedColumnName 
, ObjectDescription 
) 

SELECT 
t.table_name 
, c.column_name 
, c.ordinal_position 
, IsNULL(c.column_default, '') 
, CASE WHEN c.is_nullable = 'Yes' THEN 1 ELSE 0 END 
, c.data_type 
, IsNULL(c.character_maximum_length, '') 
, (SELECT COLUMNPROPERTY 
( 
OBJECT_ID(t.table_name) 
,c.Column_Name,'IsIdentity' 
) 
) AS IsIdentity 
, CASE WHEN pk.column_name IS NULL THEN 0 
ELSE 1 
END AS IsPrimaryKey 
, CASE WHEN Fkey.REFERENCED_TABLE_NAME IS NULL THEN 0 
ELSE 1 
END AS IsForeignKey 
, IsNULL(Fkey.REFERENCED_TABLE_NAME, '') 
, IsNULL(Fkey.Referenced_Column_Name, '') 
, CAST(IsNULL(e.value,'') as varchar(500)) as 'ColumnDescription' 

FROM 
information_schema.tables t 
INNER JOIN information_schema.columns C 
ON t.table_name = c.table_name 
LEFT OUTER JOIN [#PkColumns] Pk 
ON PK.column_Name = c.column_Name 
LEFT OUTER JOIN 
( 
SELECT 
CASE WHEN OBJECTPROPERTY(CONSTID, 'CNSTISDISABLED') = 0 
THEN 'Enabled' 
ELSE 'Disabled' END 
AS Status 
, OBJECT_NAME(CONSTID) AS Constraint_Name 
, OBJECT_NAME(FKEYID) AS Table_Name 
, COL_NAME(FKEYID, FKEY) AS Column_Name 
, OBJECT_NAME(RKEYID) AS Referenced_Table_Name 
, COL_NAME(RKEYID, RKEY) AS Referenced_Column_Name 
FROM 
SYSFOREIGNKEYS 
) As Fkey 
ON c.table_name = Fkey.table_name 
AND c.column_Name = Fkey.Column_Name 

LEFT JOIN ::FN_LISTEXTENDEDPROPERTY 
( 
'MS_Description' --standard description property 
,'user' 
,'dbo' 
,'table' --parent object type 
, @TableName -- parent object name from above 
, 'column' -- child object type	
, NULL -- child object name from above 
) e 
ON c.Column_Name = e.objname 


WHERE 
t.table_name = @TableName 

ORDER BY 
c.ordinal_position 


SET @RowNumber = @RowNumber + 1 

END --end table loop	

--drop the temp table 
DROP TABLE #PkColumns 

SELECT * 

FROM 
@DataDictionary d 

ORDER BY 
d.TableName 
, d.OrdinalPosition 
