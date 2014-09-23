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
