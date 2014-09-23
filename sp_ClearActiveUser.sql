if exists (select 1 from sysobjects where name = 'sp_ClearActiveUser')
drop proc sp_ClearActiveUser
go

create proc sp_ClearActiveUser
as
declare @deletepriortodate datetime ; select @deletepriortodate = dateadd(dd, 2, convert(nvarchar, getdate(), 101))
print 'deleting activeuser records older than '+convert(nvarchar, @deletepriortodate, 101)
-- set nocount on ; -- Uncomment the code on this line once it is determined that the @@rowcount print statements work

delete x
-- @deletepriortodate datetime ; select @deletepriortodate = dateadd(dd, -1, convert(nvarchar, getdate(), 101)); select x.*
from activeuser u
join pagelock x on u.userindex = x.userindex
where u.createdt < @deletepriortodate
print convert(varchar(10), @@rowcount)+' rows deleted from PageLock'

delete x
-- @deletepriortodate datetime ; select @deletepriortodate = dateadd(dd, -1, convert(nvarchar, getdate(), 101)); select x.*
from activeuser u
join studentuserrights  x on u.userindex = x.userindex
where u.createdt < @deletepriortodate --- 206069 rows
print convert(varchar(10), @@rowcount)+' rows deleted from StudentUserRights'

delete x
-- @deletepriortodate datetime ; select @deletepriortodate = dateadd(dd, -1, convert(nvarchar, getdate(), 101)); select x.*
from activeuser u
join ReportFilterList x on u.userindex = x.userindex
where u.createdt < @deletepriortodate --- 0 rows
print convert(varchar(10), @@rowcount)+' rows deleted from ReportFilterList'

delete u
-- @deletepriortodate datetime ; select @deletepriortodate = dateadd(dd, -1, convert(nvarchar, getdate(), 101)); select u.*
from activeuser u
where u.createdt < @deletepriortodate --- 264 rows

print convert(varchar(10), @@rowcount)+' rows deleted from ActiveUser'

go


select * from StudentUserRights


select * from activeuser




