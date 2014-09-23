
-- the first couple of updates may not affect any records.  that is okay.

-- nothing in these so get rid of them.
update c set del_flag = 1, deleteid = 'updBadRecs', deletedate = getdate() 
-- select c.*
from contacts c
where conname is null and resph is null and offph is null and addr1 is null and relation is null
go

-- remove superfluous records
update c set del_flag = 1, deleteid = 'updBadRecs', deletedate = getdate()
-- select c.*
from (
	select gstudentid, conname, resph, offph, addr1, relation, min(recnum) recnum
	from contacts 
	where isnull(del_flag,0)=0 and conname is  null 
	group by gstudentid, conname, resph, offph, addr1, relation
	having count(*) > 1
	) c2
join contacts c on c2.gstudentid = c.gstudentid 
	and isnull(c2.resph,'') = isnull(c.resph,'') 
	and isnull(c2.offph,'') = isnull(c.offph,'') 
	and isnull(c2.addr1,'') = isnull(c.addr1,'') 
	and isnull(c2.relation,'') = isnull(c.relation,'') 
	and isnull(c2.conname,'') = isnull(c.conname,'')
where isnull(c.del_flag,0)=0
and c.recnum > c2.recnum
go

-- del_flag duplicates
update c set del_flag = 1, deleteid = 'admDelDup', deletedate = getdate() -- 3740 rows updated
-- select c.*
from (
	select gstudentid, isnull(conname,'') conname, isnull(addr1,'') addr1, min(recnum) recnum
	from contacts 
	where isnull(del_flag,0)=0
	group by gstudentid, isnull(conname,''), isnull(addr1,'') 
	having count(*) > 1
	) c2
join contacts c on c2.gstudentid = c.gstudentid and c2.conname = isnull(c.conname,'') and c2.addr1 = isnull(c.addr1,'') and c2.recnum < c.recnum -- 3762 gt, 2434 eq, 2740 gt w/ addr1
go

-- create a temporary table because it is much more efficient to work with.
select * 
into #fn_parsecontactnames
from dbo.fn_parsecontactnames() 

-- declare cursor variables 
declare @GStudentID uniqueidentifier, @recnum bigint, @newconorder int,	@conname varchar(50), @prefix varchar(10), @firstname varchar(20), @lastname varchar(25)

set nocount on;

-- cursor query to handle duplicate Contacts.RecNum value (where we are parsing out 1 contact record to 2 contact records)
-- record number 2 is the 2nd record where exists a duplicate Contacts.RecNum value (record #2 of a record for Mr and Mrs Smith will be Mrs Smith, whereas Mr Smith will be contact #1)
declare G insensitive cursor for
select cp.gstudentid, cp.recnum, 
	isnull(case cp.salutation when '' then NULL else cp.salutation end+' ', '')+
			isnull(cp.firstname+' ','')+
			isnull(cp.lastname,'') Conname,
	case cp.Salutation when '' then NULL else cp.Salutation end Salutation, cp.firstname, cp.lastname
from (select gstudentid, recnum, count(*) tot from #fn_parsecontactnames group by gstudentid, recnum having count(*) > 1) c2
join #fn_parsecontactnames cp on c2.recnum = cp.recnum
where cp.newconorder = 2

open G 
fetch from G into @gstudentid, @recnum, @conname, @prefix, @firstname, @lastname
while @@fetch_status =0
begin

-- update all but newconorder 2 (should only be newconorder = 1) (many contacts do not have duplicate Contact.RecNum)
	update c set modifyid = 'ParseContacts', modifydate = getdate(),
		ConOrder = cp.newconorder, 
		prefix = case cp.Salutation when '' then NULL else cp.Salutation end, 
		ConName = isnull(case cp.salutation when '' then NULL else cp.salutation end+' ', '')+
			isnull(cp.firstname+' ','')+
			isnull(cp.lastname,''),
		firstname = cp.firstname, 
		lastname = cp.lastname, 
		relation = NULL, 
		contactgid = convert(char(32), replace(convert(varchar(50), newID() ), '-', ''))
	-- select cp.NewConOrder, cp.Salutation, cp.Firstname, cp.Lastname
	from #fn_parsecontactnames cp 
	join Contacts c on cP.recnum = c.recnum
	where c.gstudentid = @gstudentid 
	and ContactGID is null -- if there is a ContactGID we probably already parsed this record (ContactGID used in Due Process)
	and cP.newconorder <> 2

	-- Contacts.ConOrder = 1, but #fn_parsecontactnames.newconorder = 2 (2nd of 2 parsed contacts)
	insert contacts (GStudentID, ConOrder, ConName, Addr1, Addr2, City, StateCode, Zip, OffPh, ResPh, CellPh, Relation, Lang, ParentInterpret, Email, StudentAddr, MailAddr, CreateID, CreateDate, Del_Flag, Surrogate, Prefix, Lastname, Firstname)
	select @GStudentID, 2 ConOrder, @conname, c.Addr1, c.Addr2, c.City, c.StateCode, c.Zip, c.OffPh, c.ResPh, c.CellPh, NULL Relation, c.Lang, c.ParentInterpret, c.Email, c.StudentAddr, 
		c.MailAddr, 'ParseContacts'  CreateID, getdate() CreateDate, 0 Del_Flag, c.Surrogate, @prefix, @lastname, @firstname
	-- select c.*
	from Contacts c
	where conorder = 1
	and c.recnum = @recnum

fetch from G into @gstudentid, @recnum, @conname, @prefix, @firstname, @lastname
end
close G
deallocate G

-- don't need this temporary table any more
drop table #fn_parsecontactnames
go

-- it is common to see lots of extra spaces 
update contacts set conname = replace(conname, '  ', ' ') where isnull(del_flag,0)=0 and conname like '%  %'
go

-- lots of trailing spaces on firstname
update contacts set firstname = rtrim(firstname) where isnull(del_flag,0)=0
go

-- finish modifying contact data for the newly parsed contacts
update c set modifyid = 'ParseContacts', modifydate = getdate(),
	ConOrder = cp.NewConOrder, 
	prefix = case cp.Salutation when '' then NULL else cp.Salutation end, 
	ConName = isnull(case cp.salutation when '' then NULL else cp.salutation end+' ', '')+
			isnull(cp.firstname+' ','')+
			isnull(cp.lastname,''),
	firstname = cp.firstname, 
	lastname = cp.lastname, 
	contactgid = convert(char(32), replace(convert(varchar(50), newID() ), '-', ''))  -- add a new contactgid
from dbo.fn_parsecontactnames() cp 
join Contacts c on cP.recnum = c.recnum
where ContactGID is null
go

-- reorder all contact records
set nocount on

declare @g uniqueidentifier 

create table #ContactOrdering (recnum int, newconorder int identity(1,1))

declare C insensitive cursor for 
select c.GStudentID 
from (
	SELECT GStudentID, isnull(min(ConOrder),0) MinConOrder, isnull(max(ConOrder),0) MaxConOrder, isnull(sum(ConOrder),0) SumConOrder, count(*) ConCount
	from Contacts
	where isnull(del_flag,0) = 0
	group by GStudentID
	) c3
join Contacts c on c3.GStudentID = c.GStudentID and isnull(c.del_flag,0)=0
where not (c3.MinConOrder = 1 and c3.MaxConOrder = c3.ConCount and c3.SumConOrder = ( (c3.ConCount*1.0/2)*(c3.ConCount+1) ) )
order by c.GStudentID 

open C
fetch C into @g

while @@fetch_status = 0
begin

truncate table #ContactOrdering 
insert #ContactOrdering (recnum)
select recnum from contacts where gstudentid = @g and isnull(del_flag,0)=0 order by recnum

update c set conorder = newconorder
from #ContactOrdering c2 
join contacts c on c2.recnum = c.recnum

fetch C into @g
end
close C
deallocate C

drop table #ContactOrdering
-- completed




