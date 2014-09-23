
/*

-----------------------------------------------------------------------  Run the code below to see the report catalogue on a database server (Devserver is a good choice).  The more EO dbs on the server the better.

set nocount on
create table #TEMP_reports (STID int, ST char(2), RID int, ReportName varchar(50))
declare @StateDB varchar(75), @qry varchar(4000), @stid int, @prevStateDB varchar(75), @qry2 varchar(4000), @orderby2 varchar(1000)
select @stid = 1, @orderby2 = 'case when ', @qry2 = 'select r.rid, r.reportname, 
'
declare StateDBs cursor for
select name from master..sysdatabases where name like '%Convert'
order by left(right(name,9),2)

open StateDBs
fetch StateDBs into @StateDB

while @@fetch_status = 0
begin

select @qry = 'insert #TEMP_reports
select '+convert(varchar(3), @stid)+', '''+left(right(@statedb,9),2)+''', ReportID, Name from '+@StateDB+'..Report'

select @qry2 = @qry2 +'	sum(case ST when '''+left(right(@statedb,9),2)+''' then 1 else 0 end) '+left(right(@statedb,9),2)+',
'

select @orderby2 = @orderby2 + ' sum(case ST when '''+left(right(@statedb,9),2)+''' then 1 else 0 end) + '

exec (@qry)

select @stid = @stid+1
fetch StateDBs into @StateDB

end
close StateDBs
deallocate StateDBs

select @qry2 = left(@qry2, len(rtrim(@qry2))-3)
select @orderby2 = left(@orderby2, len(rtrim(@orderby2))-1)+' > 1 then 2 else 1 end desc, reportname'

exec (@qry2 +'
from #TEMP_reports r
group by r.rid, r.reportname
order by r.rid, r.reportname')


exec (@qry2 +'
from #TEMP_reports r
group by r.rid, r.reportname
order by '+@orderby2)

select @orderby2 = replace(@orderby2, 'reportname', 'rid')

exec (@qry2 +'
from #TEMP_reports r
group by r.rid, r.reportname
order by '+@orderby2)

drop table #TEMP_reports 

----------------------------------------------------------------------- Choose the report id for the report you want to copy from the query above and add that report id to the where clause below (where reportid = xxxx)
----------------------------------------------------------------------- Type Control-T (text output mode) and run the query on the database where the report exists (DevMAConvert, for example)

declare @null varchar(4), @qry varchar(4000) ; select @null = 'NULL'

set nocount on
select @qry = 
'set nocount on 
declare @delete bit, @insert bit, @ReportId int, @ReportGroupId int, @Name varchar(50), @Active bit, @StudentList bit, @StaffList bit, @DateRange smallint, @Special varchar(150), @Diploma bit, @SpecialDefault bit, @Extra varchar(150), @Sort1 varchar(30), @Sort2 varchar(30), @Sort3 varchar(30), @Sort4 varchar(30), @Filter1 varchar(50), @Filter2 varchar(50), @DisplayName nvarchar(50), @Area nvarchar(50), @Description nvarchar(1000), @SchoolList bit, @GradeList bit
select @delete = 0, @insert = 1, '+
'@ReportId = '+convert(varchar(255),ReportId)+', '+
'@ReportGroupId = '+convert(varchar(255),ReportGroupId)+', '+
'@Name = '''+Name+''''+', '+
'@Active = '+convert(varchar(255),Active)+', '+
'@StudentList = '+convert(varchar(255),StudentList)+', '+
'@StaffList = '+convert(varchar(255),StaffList)+', '+
'@DateRange = '+convert(varchar(255),DateRange)+', '+
'@Special = '+isnull(''''+Special+'''', 'NULL') +''+', '+
'@Diploma = '+convert(varchar(255),Diploma)+', '+
'@SpecialDefault = '+convert(varchar(255),SpecialDefault)+', '+
'@Extra = '+isnull(''''+Extra+'''', 'NULL') +''+', '+
'@Sort1 = '+isnull(''''+Sort1+'''', 'NULL') +''+', '+
'@Sort2 = '+isnull(''''+Sort2+'''', 'NULL') +''+', '+
'@Sort3 = '+isnull(''''+Sort3+'''', 'NULL') +''+', '+
'@Sort4 = '+isnull(''''+Sort4+'''', 'NULL') +''+', '+
'@Filter1 = '+isnull(''''+Filter1+'''', 'NULL') +''+', '+
'@Filter2 = '+isnull(''''+Filter2+'''', 'NULL') +''+', '+
'@DisplayName = '+isnull(''''+DisplayName+'''', 'NULL') +''+', '+
'@Area = '+isnull(''''+Area+'''', 'NULL') +''+', '+
'@SchoolList = '+convert(varchar(255),SchoolList)+', '+
'@GradeList = '+convert(varchar(255),GradeList)+', '+
'@Description = '+isnull(''''+Description+'''', 'NULL') +''
from report
where reportid = 2145		---- enter the appropriate reportid

select @qry

----------------------------------------------------------------------- Copy the output from the above query and paste below where indicated, the paste the entire output in the state or common.sql file, as appropriate

--====================================================================== Paste output from above between these lines ======================================================================

set nocount on 
declare @delete bit, @insert bit, @ReportId int, @ReportGroupId int, @Name varchar(50), @Active bit, @StudentList bit, @StaffList bit, @DateRange smallint, @Special varchar(150), @Diploma bit, @SpecialDefault bit, @Extra varchar(150), @Sort1 varchar(30), @Sort2 varchar(30), @Sort3 varchar(30), @Sort4 varchar(30), @Filter1 varchar(50), @Filter2 varchar(50), @DisplayName nvarchar(50), @Area nvarchar(50), @Description nvarchar(1000), @SchoolList bit, @GradeList bit
select @delete = 0, @insert = 1, @ReportId = 2147, @ReportGroupId = 1, @Name = 'IEPTransportSvc', @Active = 1, @StudentList = 0, @StaffList = 0, @DateRange = 1, @Special = NULL, @Diploma = 0, @SpecialDefault = 1, @Extra = NULL, @Sort1 = NULL, @Sort2 = NULL, @Sort3 = NULL, @Sort4 = NULL, @Filter1 = NULL, @Filter2 = NULL, @DisplayName = 'IEP Transportation Services', @Area = 'Current Data', @SchoolList = 0, @GradeList = 0, @Description = 'Excel Extract to assist districts in identifying Active students who on a specific date had Transportation on their IEP.

Though two dates are entered on this parameter form, only the first date is used to filter report data.'


--====================================================================== Paste output from above between these lines ======================================================================


if exists (select 1 from report where reportid = @reportid and name = @name)  --- we don't have the reportid and name combination we want to insert, so check them individually
begin
	print 'Report already exists in the report table.  Assume record is to be updated.  Delete this report so we can reinsert it'
	select @delete = 1
end
else
	if exists (select 1 from report where reportid = @reportid)
begin
	print 'A report with the ReportID '+convert(varchar(5), @reportid)+' exists, but with a different Name than '+@name+'.  Report not inserted.  Please investigate.'
	select @insert = 0
end
else
	if exists (select 1 from report where name = @name)
begin
	print 'A report with the name '+@name+' exists, but with a different ReportID than '+convert(varchar(5), @reportid)+'.  Report not inserted.  Please investigate.'
	select @insert = 0
end
else
begin
	print 'This report does not exist in the report table.'
end

if (@delete = 1)
	begin 
	print 'Delete report'
	delete report where reportid = @reportid and name = @name
	end
if (@insert  = 1)
begin
	print 'Insert report'
	insert report (ReportId,ReportGroupId,Name,Active,StudentList,StaffList,DateRange,Special,Diploma,SpecialDefault,Extra,Sort1,Sort2,Sort3,Sort4,Filter1,Filter2,DisplayName,Area,Description,SchoolList,GradeList)
	values (@ReportId, @ReportGroupId, @Name, @Active, @StudentList, @StaffList, @DateRange, @Special, @Diploma, @SpecialDefault, @Extra, @Sort1, @Sort2, @Sort3, @Sort4, @Filter1, @Filter2, @DisplayName, @Area, @Description, @SchoolList, @GradeList)
end
-- Add a go when placing in State or Common.sql file --


*/




