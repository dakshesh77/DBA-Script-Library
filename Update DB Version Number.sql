-- After manually upgrading the db on a restored database, to set the db version, actions depend on whether the update was already downloaded or not.

-- if not downloaded, insert only.
-- if already downloaded, the setup record will exist, but the schedule and finalize records will not

set nocount on;
declare @InstallScheduleID uniqueidentifier, @stsParameters varchar(max), @setupReleasNotes varchar(max), @stParameters varchar(max), @year int, @month int, @day int, @hour int, @minute int, @VersionNumber varchar(20), @downloaded bit, @installed bit
select 
      @InstallScheduleID = NEWID(), @year = DATEPART(year, getdate()), @month = DATEPART(month, getdate()), @day = DATEPART(day, getdate()), @hour = DATEPART(HOUR, GETDATE()), @minute = DATEPART(minute, getdate()),
      -- IMPORTANT:  Update ScheduledTaskSchedule parameters
      @stsParameters  = '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">Version</Key>      <Value xsi:type="xsd:string">8.1.6.3815</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>',
      -- IMPORTANT:  Update ScheduledTask parameters
	  @stParameters = '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">Version</Key>      <Value xsi:type="xsd:string">8.1.6.3815</Value>    </DictionaryEntry>    <DictionaryEntry>      <Key xsi:type="xsd:string">WasSuccessful</Key>      <Value xsi:type="xsd:boolean">true</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>',
      -- IMPORTANT:  Update release notes
      @setupReleasNotes = 'Enrich Version 8.1.6.3815 New - [Assess] Colorado CELA updated for 2012 changes. - [Custom] Support for manual entry of Fountas and Pinnell assessment data. - [Custom] Updated values of SMI_Last_Performance_Level field for Scholastic test import. - [IEP - Illinois] Created separate calculation for bell-to-bell minutes for Least Restrictive Environment (LRE). Fixed - [IEP] Various script errors when viewing and editing IEP plans / actions. - [RTI / ILP] Performance improvements when creating and opening interventions (RTI) and individual literacy plans (ILP). - "Not enrolled" label appeared on roster and search drop-down if student lacked grade level information on profile. Now if grade level information is missing but student is enrolled, student will appear as enrolled. - Concurrent user editing issue where first user's changes trumped subsequent user's changes. - In multi-district environment, error "Invalid column name 'StatusISLEFT'" occurred when selecting a district on home page.   Enrich Version 8.1.5.3796 New - [Assess] Updated MAP 2012 Combined File layout. - [IEP] Removed prepopulation of Eligibility decision when disabilities are copied forward to a new Eligibility Determination. - [SC Only] Added Extended Properties for SC County, Instructional Setting, and District of Residence. These will now appear on student profile and be available for reporting.  Fixed - [IEP] New draft documents were not created for items marked "Every Save" when making changes to form fields and saving the change. - [IEP] Updated Planned End Date validation message to provide a clearer message. - Double-quotes did not display properly in some documents.   Enrich Version 8.1.4.3779 New - On Add Students page, District selection now acts as a filter to prevent user from selecting an invalid district/school combination in environments with more than one district. - [IEP - CO Only] Removed option to configure Eligbility Disability functionality. - [Illinosis Only] Medicaid Procedure codes have been added. Fixed - [IEP] Goals did not appear when adding or editing Service Delivery Log entries. - [RTI, IEP] Additional changes to help quotation marks print properly in documents. - [IEP] Removed soft deleted items from showing in Service Frequency drop down menu.   Enrich Version 8.1.3.3765 New - [IEP] New Compliance Check Report templates now available under Special Education category:   - Completed compliance checks   - Completed compliance checks by school and goal   - Upcoming compliance due dates   - Upcoming compliance due dates by goal   - Upcoming compliance school and goal   - Upcoming compliance due dates for a goal - [IEP, RTI] Added month and year columns to existing report templates. In addition to specific dates, any Start Date or End Date field has link for Related fields which allow user to select a month or year.  - [IEP] Made timeline compliance start date editable. - [IEP, Florida only] 2012 Matrix of Services now available. Once implemented, users will see two Matrix of Service options on student Programs tab:   - Matrix of Services (2002-2011)   - Matrix of Services Fixed - [IEP] "You do not have permission to Edit Program Item Section" when opening a Converted Data IEP. - [IEP] Script error when marking a participant absent after choosing an existing meeting. - [IEP] Unable to edit user details within user picker on previously saved item. - [IEP] Expired Services show "Assign Provider" when the service already has one assigned. - Invalid format error when updating Student profile.   Enrich Version 8.1.2.3748 New - [Assess] Attachments feature is now available for all students for districts licensing the Assess module.  Users will now see an "Attachments" tab that will allow user to upload a file and assign a label (name) to the attachment. System administrators should verify and adjust security roles which will have the following permissions under the Attachments branch:    - View   - Upload   - Edit   - Delete - [IEP] Added new Special Education Report called "Service Count Reports".',
      -- IMPORTANT:  Update version number
      @versionNumber = '8.1.6.3815'
select top 1 @downloaded = Downloaded, @installed = isnull(Installed,0) from (select Downloaded = cast(0 as Bit), Installed = NULL union all select Downloaded = case when DownloadDate is null then 0 else 1 end, Installed = case when InstallDate is null then 0 else 1 end from dbo.Setup where VersionNumber = @VersionNumber ) t order by Installed desc

begin tran sts

if (@downloaded = 0 and @installed = 0)
begin
	insert VC3TaskScheduler.ScheduledTaskSchedule values (@InstallScheduleID, '9E307113-0C89-4FF7-AD9C-36B63B74F7E1', @stsParameters, 0, NULL, GETDATE(), 1, 'O', @year, @month, @day, @hour, @minute, 0, 0, 0, 0, 0, 0, 0)
	insert VC3TaskScheduler.ScheduledTask values (NEWID(), '4955FEBD-B332-4191-9D8B-0B33469C31EA', NULL, @stParameters, 'S', NULL, GETDATE(), GETDATE(), NULL)
	insert dbo.Setup values (@VersionNumber, GETDATE(), @InstallScheduleID, @setupReleasNotes, GETDATE())
end 
else 
if (@downloaded = 1 and @installed = 0)
begin
	select @InstallScheduleID = Installscheduleid from Setup where VersionNumber = @VersionNumber
	update dbo.Setup set InstallDate = getdate()
	update s set Parameters = @stsParameters, LastRunTime = getdate() from VC3TaskScheduler.ScheduledTaskSchedule s where s.ID = @InstallScheduleID
	-- insert VC3TaskScheduler.ScheduledTaskSchedule values (@InstallScheduleID, '9E307113-0C89-4FF7-AD9C-36B63B74F7E1', @installParameters, 0, NULL, GETDATE(), 1, 'O', @year, @month, @day, @hour, @minute, 0, 0, 0, 0, 0, 0, 0)
	insert VC3TaskScheduler.ScheduledTask values (NEWID(), '4955FEBD-B332-4191-9D8B-0B33469C31EA', NULL, @stParameters, 'S', NULL, GETDATE(), GETDATE(), NULL)
end

select * from Setup where VersionNumber  = @VersionNumber
select * from VC3TaskScheduler.ScheduledTaskSchedule where ID = @InstallScheduleID 
select top 1 * from VC3TaskScheduler.ScheduledTask where TaskTypeID = '4955FEBD-B332-4191-9D8B-0B33469C31EA' order by StartTime desc



--rollback tran sts
--commit tran sts
