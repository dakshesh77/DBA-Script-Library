select * from School where Number = '6039'

select * from LEGACYSPED.School where SchoolCode = '6039'

select * from LEGACYSPED.Transform_School where SchoolCode = '6039'

select * from LEGACYSPED.Transform_OrgUnit

select * from LEGACYSPED.District

select * from dbo.OrgUnit


--update OrgUnit set Number = '1195' where ID = '4BE21F7B-C8B7-4E67-A438-0C54847B437E'
--update OrgUnit set Number = '3000' where ID = '251A4545-F693-4C69-B852-550B1E4A84F7'
--update OrgUnit set Number = '1510' where ID = '7FEF1C61-93C8-448D-9129-8FE572FA43FA'
--update OrgUnit set Number = '2640' where ID = '52830B77-8AB8-4A4C-A0EB-A7DD0D233012'
--update OrgUnit set Number = '64093' where ID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'




select * from LEGACYSPED.Transform_


select enabled, * from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' order by Sequence

-- create schema x_DATATEAM
--select * 
--into x_DATATEAM.SpedScratchPad
--from VC3ETL.LoadTable 
--where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6'
--and Sequence < 100

declare @firstrow int, @lastrow int ; select @firstrow = 0, @lastrow = 13
update lt set Enabled = case when lt.Sequence between @firstrow and @lastrow then sp.Enabled else 0 end from VC3ETL.LoadTable lt join x_DATATEAM.SpedScratchPad sp on lt.id = sp.ID 

select Enabled, * from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' 
-- and DestTable like '%Goal%'
order by Sequence


vc3etl.loadtable_run '1427C99A-DB2E-409B-ADF0-51E2689AD311', '', 1, 0


begin tran
INSERT StudentGradeLevelHistory (StudentID, GradeLevelID, StartDate, EndDate)
SELECT s.StudentID, s.GradeLevelID, s.StartDate, s.EndDate
FROM (select * from LEGACYSPED.Transform_StudentSchoolAndGrade where ManuallyEntered = 1 and GradeLevelHistoryExists = 0) s
WHERE NOT EXISTS (SELECT * FROM StudentGradeLevelHistory d WHERE s.StudentID=d.StudentID AND s.GradeLevelID=d.GradeLevelID AND s.StartDate=d.StartDate)

rollback


select StudentID, SchoolID, RosterYearID, count(*) tot
from LEGACYSPED.Transform_StudentSchoolAndGrade
group by StudentID, SchoolID, RosterYearID
having count(*) > 1


select StudentID, GradeLevelID, RosterYearID, count(*) tot
from LEGACYSPED.Transform_StudentSchoolAndGrade
group by StudentID, GradeLevelID, RosterYearID
having count(*) > 1


select StudentID, GradeLevelID, count(*) tot
from dbo.StudentGradeLevelHistory gh
where getdate() between gh.StartDate and isnull(gh.EndDate, dateadd(dd, 1, getdate()))
group by StudentID, GradeLevelID
having count(*) > 1


select StudentID, SchoolID, count(*) tot
from dbo.StudentSchoolHistory gh
where getdate() between gh.StartDate and isnull(gh.EndDate, dateadd(dd, 1, getdate()))
group by StudentID, SchoolID
having count(*) > 1



select * 
from StudentGradeLevelHistory 
where StudentID = '43D5357D-FF2F-4AED-A20B-00ABA4010D28' 
and GradeLevelID = 'FA02DAC4-AE22-4370-8BE3-10C3F2D92CB3'

--update h set EndDate = NULL
---- select *
--from StudentSchoolHistory h
--where StudentID = 'C8299A70-3500-422F-9805-018B16EC6DB0' 
--and SchoolID = 'B82E4B94-9B80-4097-BCF2-F0044518924B'
--and enddate is not null


--update sh set EndDate = (select min(hq.StartDate) from StudentSchoolHistory hq where d.StudentID = hq.StudentID and hq.StartDate > sh.StartDate and isnull(hq.EndDate, dateadd(dd, 1, getdate())) > getdate())
---- select sh.*, newEndDate = (select min(hq.StartDate) from StudentSchoolHistory hq where d.StudentID = hq.StudentID and hq.StartDate > sh.StartDate and isnull(hq.EndDate, dateadd(dd, 1, getdate())) > getdate())
--from (
--	select StudentID, maxStartDate = max(StartDate)
--	from StudentSchoolHistory 
--	where getdate() between StartDate and isnull(EndDate, dateadd(dd, 1, getdate()))
--	group by StudentID
--	having count(*) > 1
--) d join
--StudentSchoolHistory sh on d.StudentID = sh.StudentID and isnull(sh.EndDate, dateadd(dd, 1, getdate())) > getdate() 


--select *
--from schoolHistoryCTE
--where StartDate < maxStartDate
--and studentid = 'C8299A70-3500-422F-9805-018B16EC6DB0'

	select StudentID, maxStartDate = max(StartDate)
	from StudentSchoolHistory 
	where getdate() between StartDate and isnull(EndDate, dateadd(dd, 1, getdate()))
	group by StudentID
	having count(*) > 1










SELECT s.StudentID, s.GradeLevelID, s.StartDate, s.EndDate
FROM (select * from LEGACYSPED.Transform_StudentSchoolAndGrade where ManuallyEntered = 1 and GradeLevelHistoryExists = 0) s
WHERE NOT EXISTS (SELECT * FROM StudentGradeLevelHistory d WHERE s.StudentID=d.StudentID AND s.GradeLevelID=d.GradeLevelID AND s.StartDate=d.StartDate)
and s.StudentID = '547b364b-ea44-4b13-903f-50dfe06ebe9e' 


select * from LEGACYSPED.Transform_Student where DestID = '547b364b-ea44-4b13-903f-50dfe06ebe9e' 

select * from student where ID = '547b364b-ea44-4b13-903f-50dfe06ebe9e' 

x_DATATEAM.FindGUID 'e025e230-d6b4-41b9-9672-2e3c901a9e12' 





select StudentID, GradeLevelID, count(*)  tot
from LEGACYSPED.Transform_StudentSchoolAndGrade where ManuallyEntered = 1 and GradeLevelHistoryExists = 0
group by StudentID, GradeLevelID
having count(*) > 1
order by tot desc



select s.StudentRefID, s.Number, count(*) tot
from LEGACYSPED.Transform_Student s
where DestID = '205BA43B-1BB8-4D73-A23D-036070384C51'
group by s.StudentRefID, s.Number
-- having count(*) > 1



