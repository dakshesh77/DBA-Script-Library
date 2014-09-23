declare @s uniqueidentifier ; select @s = s.id from Student s where s.Number = '' or (s.FirstName like 'Shakur%' and s.LastName like '%Johnson')
select * from Student s where s.ID = @s
select * from PrgItem i where i.StudentID = @s
select * from LEGACYSPED.Transform_PrgIep where StudentID = @s


update item set 
	IsEnded = 1, 
	EndDate = case when item.StartDate = item2.StartDate then item.StartDate else dateadd(dd, -1, item.StartDate) end, 
	ItemOutcomeID = '5ADC11E8-227D-4142-91BA-637E68FDBE70',
	EndedDate = getdate(),
	EndedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB'
--select ItemToEnd_ID = item2.ID, 
--	ItemToEnd_StartDate = item2.StartDate, 
--	ItemToEnd_EndDate = case when item.StartDate = item2.StartDate then item.StartDate else dateadd(dd, -1, item.StartDate) end, 
--	ItemToKeep_StartDate = item.StartDate
from PrgItem item left join
LEGACYSPED.Transform_PrgIep iep on item.ID = iep.DestID left join 
PrgItem item2 on item.DefID = item2.DefID and item.StudentID = item2.StudentID and iep.DestID <> item2.ID
where item.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
and item.StudentID in (
	select StudentID
	from PrgItem i 
	where i.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'
	and i.IsEnded = 0 and i.EndDate is null
	group by StudentID
	having count(*) > 1)
and iep.DestID is not null
and item.StartDate >= item2.StartDate


select * from PrgItem where EndedDate between '20120530' and '20120531' order by CreatedDate




-- and item.StudentID = '13EFB464-5CD9-4772-A737-05B671BAFD26'



select * from PrgItem i where i.id = 'E894D31D-7673-4660-9630-F06D3439D39E'







	--IsEnded = 1,
	--EndDate = make this the beginning date of the iep that is to be retained.

	--ItemOutcomeID = '5ADC11E8-227D-4142-91BA-637E68FDBE70',

	--EndedDate = getdate(),
	--EndedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB'

-- select * from PrgItemOutcome o where o.Text like '%IEP%' and DeletedDate is null
-- 5ADC11E8-227D-4142-91BA-637E68FDBE70	8011D6A2-1014-454B-B83C-161CE678E3D3	IEP Ended

-- select * from UserProfile p where p.Username like '%support%'


--These are the only valid states for PrgItem records:

--IsEnded/EndDate	OutcomeID	Interpretation
--0/null	Null	This is an draft or finalized item that has not yet ended
--1/not null	Null	This item was ended by the exit program command. No outcome was chosen for the item. The EndDate should be the same as the involvement’s end date.
--1/not null	Not null	This item was ended and an outcome was selected. May have occurred when editing the item individually or via the exit program command.

--ItemOutcomeID being not null and IsEnded=0 is not valid unfortunately. If the intention is for it to be ended you should be able to update IsEnded, EndDate, EndedDate and EndedBy to reflect that. Btw, the difference between EndDate and EndedDate is that the first one is the date the user typed in as the outcome date while the second one is the date and time the outcome was saved into the database.
