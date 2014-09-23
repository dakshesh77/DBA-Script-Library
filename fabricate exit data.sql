

--
--
--select * from setting
--
--
---- update setting set stringvalue = 'True' where name = 'DbErrorResolved'
--
--
--
--select loginpwd from staff where loginname ='admin'



--select * from activeuser



--if exists (select 1 from sysobjects where type = 'P' and name = 'sp_Report_ExitDisab')
--drop proc sp_Report_ExitDisab
--go
--
--create proc sp_Report_ExitDisab
declare  @UserIndex int, @FromDt datetime, @ToDt datetime ; select @userindex = 10383, @fromdt = '20060101', @todt = '20080723'
--as
declare @ages table (age int)
declare @age int ; set @age = 3 ; while @age < 22  
begin 
	insert @ages
	select @age ; set @age = @age + 1
end

--declare @studentinfo table (StudentIndex Int, age int, disabilityid nvarchar(10), disabilitydesc nvarchar(80), spedexitcode nvarchar(5))
--insert @studentinfo
	SELECT S.StudentIndex, cast ((
		(datepart(yy, SpedExitDate)- datepart(yy, birthdate))*360.0 +
		(datepart(mm, SpedExitDate)- datepart(mm, birthdate))*30 +
		(datepart(dd, SpedExitDate)- datepart(dd, birthdate)))/30/12 as int) Age, DisabilityID, DisabilityDesc, E.Code
	FROM ReportStudPrimaryDisability D
	JOIN ReportIEPCompleteTblMax I on D.GStudentID = I.GStudentID  -- just to see that they have at least one completed IEP
	LEFT JOIN ReportStudentView S ON I.GStudentID = S.GStudentID
	JOIN (select code, lookdesc as SpedExitReason from CodeDescLook where usageid = 'spedreas') E ON isnull(S.SpedExitCode,0) = E.Code
--	WHERE S.UserIndex = @UserIndex and S.SpedStat = 2
--	AND S.SpedExitDate >= @FromDt and S.SpedExitDate < dateadd(dd,1,@ToDt)

select * from @studentinfo


select * from ReportIEPCompleteTblMax
if exists (select 1 from sysobjects where type = 'V' and name = 'ReportIEPCompleteTbl')
drop view ReportIEPCompleteTbl
GO

if exists (select 1 from sysobjects where type = 'V' and name = 'ReportIEPCompleteTblMax')
drop view ReportIEPCompleteTblMax
GO

create view ReportIEPCompleteTbl
as
Select s.GStudentID, i.studentindex, i.IEPSeqNum, i.MeetDate, i4.initiateddate LastIEPDate, 
	case when i.iepstatus = 0 then 'Draft' when i.iepstatus in (1, 2) then 'IEPComplete' else 'Unknown' end IEPComplete, 
	i.IEPType, i.InitiatedDate IEPAppDate, i.CaseMgr, i.CaseMgrTitle, 
	ia.AnnReviewDate ReviewDate, ia.TriReviewDate ReEvalDate, ia.ImplDate CurrEvalDate, MeetDate as repIEPReviseDate, 
	ia.InitiatedDate as repIEPStartDate,   ----- verify this
	ia.LEPYN,
	isnull(ia.ESY,0) as ESYElig
from student s
left join IEPTbl i on s.studentindex = i.studentindex
left join IEPTbl_DD ia on i.iepseqnum = ia.iepseqnum ----------------------------------   will we be saving iepdata in ieptbl?  why iepcompletetbl?
left join (select iepseqnum, initiateddate from ieptbl where isnull(del_flag,0)=0 and iepstatus != 0) i4 on i.sourceiepseqnum = i4.iepseqnum
where isnull(i.del_flag,0)=0 and isnull(ia.del_flag,0)=0
and iepstatus != 0
GO

create view ReportIEPCompleteTblMax
as
select i.*
from (select max(iepseqnum) iepseqnum from ReportIEPCompleteTbl group by studentindex) i2
left join reportiepcompletetbl i on i2.iepseqnum = i.iepseqnum
GO


select * from ieptbl -- 144
select * from IEPTbl_DD -- 144
select iepstatus, count(*) tot from ieptbl where isnull(del_flag,0)=0 group by iepstatus










/*

select * from student where spedstat = 2

select count(*) from student

select * from codedesclook where usageid like '%reas%'

select * from codedesclook where usageid = 'ExitReason' order by Code -- 1,3,4,5,6,7,9

select cast(getdate() as bigint)
39650
25567 1/1/1970
0 1/1/1900
1 1/2/1900


select cast(cast('19000102' as datetime) as bigint)


select datediff(dd, '20060101', '20080101')

update student set spedstat = 2, SpedExitCode = k.Code, SpedExitReason = k.LookDesc, SpedExitDate = convert(varchar, dateadd(dd, -studentindex%731, getdate()), 101)
-- select s.StudentId, s.lastname+', '+s.firstname StudentName, 2 SpedStat, k.Code SpedExitCode, LookDesc SpedExitReason, StudentIndex, convert(varchar, dateadd(dd, -studentindex%731, getdate()), 101) SpedExitDate
from student s
join CodeDescLook k on '0'+convert(char(1), 
	case (studentindex%8)+1 when 2 then 3 when 8 then 7 else (studentindex%8)+1 end
	) = k.Code and k.UsageId = 'ExitReason'
where studentindex%31 = 1
--order by studentid





*/


--select s1.StudentIndex, aed.Age, aed.SpedExitCode, aed.SpedExitReason, aed.DisabilityID, aed.DisabilityDesc
--from @StudentInfo s1
--right join (
--	select Age, SpedExitCode, SpedExitReason, l2.DisabilityID, l2.DisabDesc as DisabilityDesc
--	from @ages a
--	cross join (select code as SpedExitCode, lookdesc as SpedExitReason from CodeDescLook where usageid = 'spedreas') e
--	cross join (select distinct DisabilityID from @StudentInfo) dd
--	left join disabilitylook l2 on dd.DisabilityID = l2.DisabilityID
--	) aed  on s1.age = aed.age and s1.SpedExitCode = aed.SpedExitCode and s1.disabilityid = aed.disabilityid
--GO






