
-- run this script on a database that has the exact version that needs to be copied to the database of an instance of Enrich whose version is out of sync with the application after a manual db upgrade

set nocount on;
declare @t table (seq int, sch varchar(50), tbl varchar(50), clm varchar(50))
insert @t values (1, 'VC3TaskScheduler', 'ScheduledTaskSchedule', 'ID')
--insert @t values (2, 'VC3TaskScheduler', 'ScheduledTask')
insert @t values (3, 'dbo', 'Setup', 'InstallScheduleID')

declare @cmap table (ot varchar(50),nt varchar(50))
insert @cmap values ('bit', 'varchar(10)')
insert @cmap values ('text', 'varchar(max)')
insert @cmap values ('datetime', 'varchar(50)')
insert @cmap values ('int', 'varchar(10)')
insert @cmap values ('uniqueidentifier', 'varchar(36)')

declare @col varchar(50), @otyp varchar(20), @ntyp varchar(20), @size varchar(10), @nul bit, @clm varchar(50),
	@sch varchar(50), @tbl varchar(50),
	@versionNumber varchar(20), @InstallScheduleID uniqueidentifier,
	@tv varchar(100), @cfix varchar(100),
	@qry varchar(max), 
	@nulbeg varchar(50), @nulend varchar(50), @fulbeg varchar(50), @fulend varchar(50)
	; 

select @versionNumber = '8.2.6.3874'
select @InstallScheduleID = InstallScheduleID from Setup where VersionNumber = @versionNumber
select 
	@nulbeg = '+isnull(''''''''', 
	@nulend = ', ''NULL'')+', 
	@fulbeg = '''''', 
	@fulend = '+'''''', '''

declare T cursor for 
select sch, tbl, clm from @t order by seq

open T
fetch T into @sch, @tbl, @clm

while @@FETCH_STATUS = 0
begin

	set @qry = 'select replace(''insert '+@sch+'.'+@tbl+' values ('''

	declare CTS cursor for 
	select 
		Col = c.name, oTyp = t.name, nTyp = isnull(m.nt, 'varchar(50)'), 
		Size = case when t.name like '%char%' then '('+convert(varchar, c.max_length)+')' when t.name like '%text%' then '' else '' end,
		c.is_nullable
	from sys.schemas s 
	left join sys.objects o on s.schema_id = o.schema_id
	left join sys.columns c on o.object_id = c.object_id
	left join sys.types t on c.user_type_id = t.user_type_id
	left join @cmap m on t.name = m.ot
	where s.name = @sch
	and o.name = @tbl -- and c.name = 'sourcetbl'
	order by c.column_id

	open CTS
	fetch CTS into @col, @otyp, @ntyp, @size, @nul

	while @@FETCH_STATUS = 0
	begin

--	select * from VC3TaskScheduler.ScheduledTaskSchedule where ID = @InstallScheduleID
--	select * from VC3TaskScheduler.ScheduledTask where ScheduleID = @InstallScheduleID
--	select * from Setup where InstallScheduleID = @InstallScheduleID
	
	set @cfix = 
			''+case @nul when 0 then @fulbeg else @nulbeg end+'' 
			+'+convert('+@ntyp+', '+@col+
			')'+case @nul when 0 then @fulend else ''+@nulend+''''''', ''' end

	set @qry = @qry + @cfix

	fetch CTS into @col, @otyp, @ntyp, @size, @nul
	end
	close CTS
	deallocate CTS

	print left(@qry, len(@qry)-patindex('%,%', reverse(@qry)))+')'', ''NULL'''','', ''NULL,'') from '+@sch+'.'+@tbl+' where '+@clm+' = '''+convert(varchar(36), @InstallScheduleID)+''''

fetch T into @sch, @tbl, @clm
end
close T
deallocate T

-- Take the output of the above query and run it on an already updated database (sample below):
select replace('insert VC3TaskScheduler.ScheduledTaskSchedule values ('''+convert(varchar(36), ID)+''', '''+convert(varchar(36), TaskTypeID)+''', '+isnull(''''+convert(varchar(max), Parameters), 'NULL')+''', '''+convert(varchar(10), IsEnabled)+''', '+isnull(''''+convert(varchar(50), EnabledDate), 'NULL')+''', '+isnull(''''+convert(varchar(50), LastRunTime), 'NULL')+''', '''+convert(varchar(10), FrequencyAmount)+''', '''+convert(varchar(50), FrequencyTypeID)+''', '+isnull(''''+convert(varchar(10), YearTrigger), 'NULL')+''', '+isnull(''''+convert(varchar(10), MonthTrigger), 'NULL')+''', '+isnull(''''+convert(varchar(10), DayTrigger), 'NULL')+''', '+isnull(''''+convert(varchar(10), HourTrigger), 'NULL')+''', '+isnull(''''+convert(varchar(10), MinuteTrigger), 'NULL')+''', '''+convert(varchar(10), MonTrigger)+''', '''+convert(varchar(10), TuesTrigger)+''', '''+convert(varchar(10), WedsTrigger)+''', '''+convert(varchar(10), ThursTrigger)+''', '''+convert(varchar(10), FriTrigger)+''', '''+convert(varchar(10), SatTrigger)+''', '''+convert(varchar(10), SunTrigger)+''')', 'NULL'',', 'NULL,') from VC3TaskScheduler.ScheduledTaskSchedule where ID = 'D614930D-162A-410C-A3B4-B013534D3C66'
select replace('insert dbo.Setup values ('''+convert(varchar(50), VersionNumber)+''', '''+convert(varchar(50), DownloadDate)+''', '''+convert(varchar(36), InstallScheduleID)+''', '+isnull(''''+convert(varchar(max), ReleaseNotes), 'NULL')+''', '+isnull(''''+convert(varchar(50), InstallDate), 'NULL')+''')', 'NULL'',', 'NULL,') from dbo.Setup where InstallScheduleID = 'D614930D-162A-410C-A3B4-B013534D3C66'


-- IF the update has already been scheduled on the target database, run a script like the following on the target database.     
-- note:  we need to get the scheduleID for this version and update the setup record and sts record
declare @Setup table (
VersionNumber	varchar(20) NOT NULL,
DownloadDate	datetime NOT NULL,
InstallScheduleID	uniqueidentifier NOT NULL,
ReleaseNotes	text,
InstallDate	datetime
)
begin tran
-- insert VC3TaskScheduler.ScheduledTaskSchedule values ('D614930D-162A-410C-A3B4-B013534D3C66', '9E307113-0C89-4FF7-AD9C-36B63B74F7E1', '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">Version</Key>      <Value xsi:type="xsd:string">8.2.6.3874</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>', '0', NULL, NULL, '1', 'D', NULL, NULL, NULL, '10', '21', '0', '0', '0', '0', '0', '0', '0')

insert @Setup values ('8.2.6.3874', 'Oct 30 2012 10:21AM', 'D614930D-162A-410C-A3B4-B013534D3C66', 'Enrich Version 8.2.6.3874 New: - Security roles have been updated to better support students who attend multiple schools. School administrators can now view students who attend classes at their school, but whose home school is a different school. - The security role definition page provides updated descriptions of each security zone.  - Security roles have been updated to better support multi-district environments and programs:    - Advanced search page limits users to see only students in their own district. This also affects student group creation which uses the advanced search tool.   - Program summary reports filter students based on users'' school or district security roles. - Several performance improvements to better support large districts with concurrent usage of programs. These changes should reduce the amount of memory and CPU utilized. Additional performance improvements are pending in an upcoming release. - Added API to allow 3rd party applications to provide direct, secure links to specific screens within Enrich.  - [IEP - Colorado] Added CO-specific accommodations and related questions on IEP. - [IEP] Added Staff ID field to user profile for use in state reports.   Fixed: - [Assess] MAP Fall 2012 import may have omitted Language scores if using Web based MAP and Common Core standards, because  scores are listed differently between the Combined Data File and the raw data file (used by original MAP).   If your district uses Web based MAP and Common Core goals, we recommend that you re-import your Fall 2012 MAP file to ensure that the Language scores are all included.  Specifically:   - "Writing: Plan, Organize, Develop, Revise, Research" will map to "Plan, Organize, Research" score   - "Language: Understand, Edit for Grammar, Usage" will map to "Understand, Grammar, Usage" score   - "Language: Understand, Edit Mechanics" will map to "Punctuate, Spell Correctly".    See the following for more information on Common Core Goal structure: http://www.nwea.org/support/article/common-core-map-and-map-primary-grades - Users could previously only add students if they were assigned a role with "Everything" zone specified. Now a school-level or district-level user can add students. (Note that the "Add student" functionality is generally applicable only for districts using Special Education.)   Known Issue: - In creation of custom assessment reports, multiple edits of criteria may cause error: "Index was out of range", or may result in most recently added filter prompts not appearing on "Run Report" page.   Work-around: Save the report before re-editing the criteria.  If you receive "Index was out of range" error you will need to recreate the report criteria. This will be corrected in an upcoming release.   Enrich Version 8.2.5.3856 New: - Updated the "Merge Duplicate Students" utility so that it will not allow merging of students who have overlapping programs data. This is to prevent corruption of data.  For example, if both students have a Special Education involvement with overlapping dates, the Merge utility will point out the conflict. User must then manually update one of the student records to alleviate the conflict prior to merging.  Note that if the records have RTI involvements in two different domains, this will not cause a conflict and the two student records can be merged.  Fixed: - Users can now upload attachments without being granted Administrative Edit permissions. - [Assess] TCAP (CO) import now uses State ID for both the import matching and combining multiple subject records into one. - [IEP] Matrix of Service (FL only) did not show all disabilities beyond the first two disabilities. - [IEP] Validation message on IEP planned End Date has been clarified to state "The planned end date cannot be greater than the default (the meeting date plus one year minus one day)."   Enrich Version 8.2.4.3850 New: - [General] Minor Performance change to all static pages. Fixed: - [Assess] Error: Missing value for the user parameter on the Performance Groups (One Score or Two Scores) report.   Enrich Version 8.2.4.3847 **This is an Assess Update Only** New - [Assess] Added Support for MAP Goals for Common Core Standards. * Note: If you have already imported Fall 2012 MAP scores and your district uses new Common Core goals, you will need to re-import your MAP file to ensure all scores are included.  If your district does not use Common Core goals, you do not need to re-import. - [SC Only] Updated Extended Properties for True Grade, Student Generation, and Instructional Setting. - [SC Only] Added English Proficiency to clients that currently do not have it available. - [IEP] Disabled the ability to edit meetings associated with finalized IEPs. Fixed - [IEP] Error when selecting Print on a student''s IEP. - [IEP] Error that causes user to be disconnected from concurrent user editing session by opening a document on an IEP. - [IC SIS Import] SIS Import failure based on SchoolID being null from the School Calendar table in Infinite Campus. - Error when value is not provided for filter in Reports. Known Issue: - Error when running Performance Groups reports: "This report requires a default or user-defined value for the report parameter ''user''". This error will be corrected in a subsequent release as soon as possible.', 'Nov  6 2012  5:11PM')
update t set ReleaseNotes = s.ReleaseNotes, InstallDate = s.InstallDate, InstallScheduleID = s.InstallScheduleID 
from Setup t join 
@setup s on t.VersionNumber = s.VersionNumber

rollback tran
commit tran


-- select * from Setup where InstallScheduleID = 'D614930D-162A-410C-A3B4-B013534D3C66'



