

--if object_id('x_WalkIEP.PresentLevels_LOCAL') is not null
--drop table x_WalkIEP.PresentLevels_LOCAL
--go

if object_id('x_WalkIEP.PresentLevels_LOCAL') is null
BEGIN
CREATE TABLE x_WalkIEP.PresentLevels_LOCAL (
	IEPRefID varchar(150) NOT NULL,
	EventGroupID int NOT NULL,
	StrengthsInterests text NULL,
	PLOPSummary text NULL,
	DisabilityImpact text NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


alter table x_WalkIEP.PresentLevels_LOCAL 
	add constraint PK_x_WalkIEP_PresentLevels_LOCAL primary key (IEPRefID)
END
go





if object_id('x_WalkIEP.PresentLevelsExtract') is not null
drop view x_WalkIEP.PresentLevelsExtract
go

create view x_WalkIEP.PresentLevelsExtract
as
select IEPRefID = xi.IepRefID, EventGroupID = ei.ardMeetingId, StrengthsInterests = cast(si.StrengthsInterests as text), PLOPSummary = cast(ps.PLOPSummary as text), DisabilityImpact = cast(di.DisabilityImpact as text)
from x_WalkIEP.IEP xi
join Encore.dbo.IEP ei on xi.IepRefID = ei.ID
left join (
	SELECT 
		IEPRefID = iep.ID, 
		StrengthsInterests = ltrim(replace(replace((
			SELECT CAST(ar.txtPresentLevel as varchar(max)) + ' '
			FROM Encore.dbo.CO_AnnualReview ar  
			WHERE ar.lngEventGroupID = iep.ardMeetingId
			AND ar.txtPresentLevel IS NOT NULL
			FOR XML PATH('')
		), '&#x0D;', ' '), '&lt;', '< '))
	FROM Encore.dbo.IEP iep 
	JOIN x_WalkIEP.IEP spediep on spediep.IEPRefID = iep.ID
	--and iep.id = 29901
) si on xi.IepRefID = si.IEPRefID
left join (
	SELECT 
		IEPRefID = iep.ID, 
		PLOPSummary = ltrim(replace(replace((
			SELECT p3.strSubjectLabel + ': ' + p3.txtAssessFindings + ' '
			FROM Encore.dbo.CO_IEP_Page03 p3 
			WHERE p3.lngEventGroupID = iep.ardMeetingId
			AND p3.strSubjectLabel IS NOT NULL	
			--and iep.id = 29901
			FOR XML PATH('')
		), '&#x0D;', ' '), '&lt;', '< '))
	FROM Encore.dbo.IEP iep 
	JOIN x_WalkIEP.IEP spediep on spediep.IEPRefID = iep.ID
	-- order by iep.id
	--and iep.id = 29901
) ps on xi.IepRefID = ps.IEPRefID
left join (
	SELECT
		IEPRefID = iep.ID, 
		DisabilityImpact = ltrim(replace(replace((
			SELECT lre.strJustification + ' '
			FROM Encore.dbo.CO_IEP_Page06_ServicesLRE lre 
			WHERE lre.lngEventGroupID = iep.ardMeetingId
			AND lre.strJustification IS NOT NULL	
			FOR XML PATH('')	
		), '&#x0D;', ' '), '&lt;', '< '))
	FROM Encore.dbo.IEP iep 
	JOIN x_WalkIEP.IEP spediep on spediep.IEPRefID = iep.ID
	--and iep.id = 29901
) di on xi.IepRefID = di.IEPRefID
go


insert x_WalkIEP.PresentLevels_LOCAL (IEPRefID, EventGroupID, StrengthsInterests, PLOPSummary, DisabilityImpact)
select x.IEPRefID, x.EventGroupID, x.StrengthsInterests, x.PLOPSummary, x.DisabilityImpact
from x_WalkIEP.PresentLevelsExtract x
left join x_WalkIEP.PresentLevels_LOCAL t on x.IEPRefID = t.IEPRefID
where t.IEPRefID is null
go
-- 


select * from x_Walk.FormInputFields where TemplateName = 'CW - Present Level of Performance' and ControlType = 'Input Area'
go

/*

select s.* 
from x_WalkIEP.Student s
left join x_WalkIEP.iep i on s.StudentRefID = i.StudentRefID 
where 1=1
and i.StudentRefID is null
and s.firstname like 'Geo%'

*/







/*


declare @s table (
Item			varchar(10) not null,
StagingParent	varchar(100) not null,
StagingChild	varchar(100) not null,
FuzzyMatch		varchar(30) not null
)


declare @obj varchar(100), @q1 varchar(max), @q1text varchar(max), @q1flag varchar(max), @q1date varchar(max), @q2 varchar(max), @newline varchar(5) ; set @obj = 'PresentLevels'
set @newline = '
'
select @q1 = 'if object_id(''x_WalkIEP.'+@obj+'DATATYPEPivot'', ''V'') is not null
DROP VIEW x_WalkIEP.'+@obj+'DATATYPEPivot
GO

create view x_WalkIEP.'+@obj+'DATATYPEPivot
as
select u.IEPRefID, u.EventGroupID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from ('+@newline+@newline,
@q2 = '	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go
'

set @q1text = replace(@q1, 'DATATYPE', 'Text')
set @q1flag = replace(@q1, 'DATATYPE', 'Flag')
set @q1date = replace(@q1, 'DATATYPE', 'Date')


		-- NOTE: if the exact Form Template name is known, use that as the FuzzyMatch value (insert below)

--insert @s values ('BIP', 'x_Walk.BIPData_Main', '', 'CW%B%I%P%')
--insert @s values ('Eval', 'x_Walk.EvalData_Main', 'x_Walk.EvalData_Results', 'CW%Eval%')
--insert @s values ('IEP', 'x_WalkIEP.MeetingParticipantsExtract_MAIN', 'x_WalkIEP.MeetingParticipantsExtract_DETAIL', 'CW%Part%')
insert @s values ('IEP', 'x_WalkIEP.PresentLevels_LOCAL', '', 'CW%Pres%')


set nocount on;

print @q1flag
select /* ii.TemplateName, DataType = 'Flag', */ Stmt = '	select IepRefID,EventGroupID,  SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_Walk.FormInputFields ii
join @s s on ii.TemplateName like s.FuzzyMatch
and ii.InputItemType = 'Flag'
order by TemplateName, ControlIsRepeatable

print @q2

print @q1date
select /* ii.TemplateName, DataType = 'Date', */ Stmt = '	select IepRefID, EventGroupID, SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_Walk.FormInputFields ii
join @s s on ii.TemplateName like s.FuzzyMatch
and ii.InputItemType = 'Date'
order by TemplateName, ControlIsRepeatable, ii.InputItemCode

print @q2

print @q1text
select /* ii.TemplateName, DataType = 'Text', */ Stmt = '	select IepRefID, EventGroupID, SubRefID = '+ case when ii.ControlIsRepeatable = 0 then 'cast(-99 as int)' else ' x.SubRefID' end +', Value = x.ColumnNameFromLegacyData, InputFieldID = '''+convert(varchar(36), ii.InputFieldID)+''', Sequence = '+ case when ii.ControlIsRepeatable = 0 then ' cast(0 as int) ' else ' x.Sequence ' end +' -- '+case when ii.ControlIsRepeatable = 1 then '(1:M)  ' else '' end +ii.InputItemCode+' - '+ii.InputItemLabel+'
	from '+case when ii.ControlIsRepeatable = 0 then s.StagingParent else s.StagingChild end +' x
	UNION ALL'
from x_Walk.FormInputFields ii
join @s s on ii.TemplateName like s.FuzzyMatch
and InputItemType = 'Text'
order by TemplateName, ControlIsRepeatable, ii.InputItemCode+' - '+ii.InputItemLabel

print @q2



*/



if object_id('x_WalkIEP.PresentLevelsTextPivot', 'V') is not null
DROP VIEW x_WalkIEP.PresentLevelsTextPivot
GO

create view x_WalkIEP.PresentLevelsTextPivot
as
select u.IEPRefID, u.EventGroupID, u.SubRefID, u.Value, u.Sequence, u.InputFieldID, InputItemType =  iit.Name, InputItemTypeID = iit.ID 
from (
	select IepRefID, EventGroupID, SubRefID = cast(-99 as int), Value = x.PLOPSummary, InputFieldID = '627CDD8A-D18C-4250-8FAF-92218BCFFC05', Sequence =  cast(0 as int)  -- PresentLvl - Include statements in all relevent areas including: Educational, Communication, Cognitive, Social/Emotional, Physical Health, Physical Motor, and Life Skills/Career/Transition
	from x_WalkIEP.PresentLevels_LOCAL x
	) u join
FormTemplateInputItem ftii on u.InputFieldID = ftii.Id join 
FormTemplateInputItemType iit on ftii.TypeId = iit.Id
go



























--===================================================================================================================================
-- OUTPUT
--===================================================================================================================================
--SELECT 
--o.IEPRefID
--,o.PresentLevelType
--,REPLACE(REPLACE(LEFT(REPLACE(LTRIM(RTRIM(o.Statement)),'&#x0D',''),7900),'|','{pipe}'),'''','') as Statement
--FROM @output o
--WHERE o.Statement IS NOT NULL


--SELECT 
--	IEPRefID = iep.ID, ar.ID, StrengthsInterests = (
--		SELECT CAST(ar.txtPresentLevel as varchar(max)) + ' '
--		FROM Encore.dbo.CO_AnnualReview ar  -- select top 1 * FROM Encore.dbo.CO_AnnualReview ar where ar.txtPresentLevel IS NOT NULL
--		WHERE ar.lngEventGroupID = iep.ardMeetingId
----		AND ar.txtPresentLevel IS NOT NULL
--		FOR XML PATH('')
--	)

--FROM Encore.dbo.IEP iep 
--JOIN x_WalkIEP.IEP spediep on spediep.IEPRefID = iep.ID
--join Encore.dbo.CO_AnnualReview ar on ar.lngEventGroupID = iep.ardMeetingId


--select IEPRefID = iep.ID, PresentLevelID = ar.ID, StrengthsInterests = ar.txtPresentLevel
--FROM Encore.dbo.IEP iep 
--JOIN x_WalkIEP.IEP spediep on spediep.IEPRefID = iep.ID
--join Encore.dbo.CO_AnnualReview ar on ar.lngEventGroupID = iep.ardMeetingId


--SELECT IEPRefID = iep.ID, 
--	-- PresentLevelID = 
--	PLOPSummary = p3.strSubjectLabel + ': ' + REPLACE(p3.txtAssessFindings, '&#x0D; ','') + ' '
--FROM Encore.dbo.IEP iep 
--JOIN x_WalkIEP.IEP spediep on spediep.IEPRefID = iep.ID
--join Encore.dbo.CO_IEP_Page03 p3 on iep.ardMeetingId = p3.lngEventGroupID
--where iep.id = 29901



--Cordero is currently an 11th grader at Arvada West.  He is taking four General Ed classes and one Special Ed English.  Cordero's grades are as follows:

--American History: F

--Drafting: A

--Drawing/Painting Adv: C

--English 11 B:  F

--Graphic Arts: D

--Cordero's 6th hour American History teacher, Janet Pease, reports that "He (Cordero) really does nothing in class except socialize.  He's not disruptive or a "problem" in any way.....he just doesn't do anything."

--When speaking with Cordero's English teacher, Mr. Halter, he informed me that Cordero has trouble decoding information and transferring that information from book to paper.

--Cordero is genuinely a hard worker when motivated, however his progress is often hindered by social distractions such as working in groups.  Cordero will often use that opportunity as a means to escape work that he might find difficult, rather than asking for help.




--select * from x_WalkIEP.PresentLevelsExtract

--declare @bug varchar(max) ;

--set @bug = 'Physical/Motor: UPDATE OF PRE-VOCATIONAL GOALS AND OBJECTIVES:&#x0D;
--&#x0D;
--Goal 7: Brandon will improve his pre-vocational skills by meeting the following objectives:&#x0D;
--Objective 1: Using a name stamp, Brandon will stamp his name on his work and practice sheets in the designated area independently for two weeks. - Making Progress.  Needs prompting.&#x0D;
--Objective 2: Brandon will participate in a pre-vocational activity (delivering, sorting) two times per week with one verbal prompt for two weeks. - Accomplished.  Working on increasing independence to find the correct classrooms when delivering.&#x0D;
--&#x0D;
--PRE-VOCATIONAL SKILLS UPDATE:&#x0D;
--&#x0D;'

--print @bug
--print '--==================================================================================='
--select replace(@bug, '&#x0D;', ' ')







