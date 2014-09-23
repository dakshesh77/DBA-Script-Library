

-- this script leaves a LOT to be desired, but if needed it may be a start

-- drop table #TMP

SELECT  
  cast('' as varchar(4000)) AS COLNAMES ,
  cast('' as varchar(4000)) AS CreateStatement ,
  OBJECT_NAME(I.ID) AS TABLENAME,
  I.ID AS TABLEID,
  I.INDID AS INDEXID,
  I.NAME AS INDEXNAME,
  DropStatement = 
	CASE 
	WHEN cast(case when pk.CONSTRAINT_NAME is null then 0 else 1 end as bit) = 0 THEN
		CASE when cast(case when uq.CONSTRAINT_NAME is null then 0 else 1 end as bit) = 1 THEN
			'ALTER TABLE '+OBJECT_NAME(I.ID)+' DROP CONSTRAINT ' + uq.CONSTRAINT_NAME
		ELSE
			'Drop index '+OBJECT_NAME(I.ID)+'.'+i.Name
		END
	ELSE
		'ALTER TABLE '+OBJECT_NAME(I.ID)+' DROP CONSTRAINT ' + I.NAME
	END,
  I.STATUS,
  IsPK = cast(case when pk.CONSTRAINT_NAME is null then 0 else 1 end as bit),
  IsUniqueConstraint = cast(case when uq.CONSTRAINT_NAME is null then 0 else 1 end as bit),
  INDEXPROPERTY (I.ID,I.NAME,'ISUNIQUE') AS ISUNIQUE,
  INDEXPROPERTY (I.ID,I.NAME,'ISCLUSTERED') AS ISCLUSTERED,
  INDEXPROPERTY (I.ID,I.NAME,'INDEXFILLFACTOR') AS INDEXFILLFACTOR
  INTO #TMP
  FROM SYSINDEXES I
  join sysobjects o on i.id = o.id
  left join INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk on i.name = pk.CONSTRAINT_NAME and pk.CONSTRAINT_TYPE = 'PRIMARY KEY'
  left join INFORMATION_SCHEMA.TABLE_CONSTRAINTS uq on i.name = uq.CONSTRAINT_NAME and uq.CONSTRAINT_TYPE = 'UNIQUE'
  WHERE I.INDID > 0 AND I.INDID < 255 AND (I.STATUS & 64)=0
  and o.type = 'U'
--uncomment below to eliminate PK or UNIQUE indexes;
--what i call 'normal' indexes
  --AND   INDEXPROPERTY (I.ID,I.NAME,'ISUNIQUE')       =0
  --AND   INDEXPROPERTY (I.ID,I.NAME,'ISCLUSTERED') =0

-- and INDEXPROPERTY (I.ID,I.NAME,'ISUNIQUE') <> cast(case when pk.CONSTRAINT_NAME is null then 0 else 1 end as bit)


select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 




--select * from #TMP
set nocount on;
DECLARE @ISQL VARCHAR(4000), @TABLEID INT, @INDEXID INT, @MAXTABLELENGTH INT, @MAXINDEXLENGTH INT
  --USED FOR FORMATTING ONLY
    SELECT @MAXTABLELENGTH=MAX(LEN(TABLENAME)) FROM #TMP
    SELECT @MAXINDEXLENGTH=MAX(LEN(INDEXNAME)) FROM #TMP

    DECLARE C1 CURSOR FOR
      SELECT TABLEID,INDEXID FROM #TMP  
    OPEN C1
      FETCH NEXT FROM C1 INTO @TABLEID,@INDEXID
        WHILE @@FETCH_STATUS <> -1
          BEGIN
	SET @ISQL = ''
	SELECT @ISQL=@ISQL + ISNULL(c.NAME,'') + ',' 
	FROM SYSINDEXES I
	JOIN SYSINDEXKEYS k ON I.ID = k.ID AND I.INDID = k.INDID
	JOIN SYSCOLUMNS c ON k.ID = c.ID AND k.COLID  = c.COLID
	WHERE I.INDID between 1 AND 254
	AND (I.STATUS & 64)=0
	AND I.ID = @TABLEID AND I.INDID = @INDEXID
	ORDER BY c.COLID
	
	UPDATE #TMP SET COLNAMES=@ISQL WHERE TABLEID=@TABLEID AND INDEXID=@INDEXID

	FETCH NEXT FROM C1 INTO @TABLEID, @INDEXID
         END
      CLOSE C1
      DEALLOCATE C1

  --AT THIS POINT, THE 'COLNAMES' COLUMN HAS A TRAILING COMMA
  UPDATE #TMP SET COLNAMES=LEFT(COLNAMES,LEN(COLNAMES) -1)


	UPDATE #TMP set CreateStatement = 
  --SELECT  
    
CASE WHEN IsPK = 0 THEN
    replace ('CREATE ' 
    + CASE WHEN ISUNIQUE     = 1 THEN ' UNIQUE ' ELSE ' ' END 
    + CASE WHEN ISCLUSTERED = 1 THEN ' CLUSTERED ' ELSE ' ' END 
    + ' INDEX [' + INDEXNAME + ']' 
    -- + SPACE(@MAXINDEXLENGTH - LEN(INDEXNAME))
    +' ON [' + TABLENAME + '] '
    -- + SPACE(@MAXTABLELENGTH - LEN(TABLENAME)) 
    + '(' + COLNAMES + ')' 
    + CASE WHEN INDEXFILLFACTOR = 0 THEN ''  ELSE  ' WITH FILLFACTOR = ' + CONVERT(VARCHAR(10),INDEXFILLFACTOR)   END, '  ', ' ') --AS SQL
ELSE
	'ALTER TABLE ' + TABLENAME + ' ADD CONSTRAINT ' + INDEXNAME + ' PRIMARY KEY ('+COLNAMES+')'
END
    --FROM #TMP



   SELECT * FROM #TMP
   DROP TABLE #TMP
go
