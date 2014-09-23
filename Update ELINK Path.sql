

-- select * from dlinkfile

use master -- prevent this from accidentally being run in the wrong context
go

use ELINK_XXXX
go

declare @oldpath varchar(150), @newpath varchar(150) ; 
select 
	@oldpath = 'c:\_worldstage\copoudre\',
	@newpath = 'c:\_worldstage\flcollier\'

update dlinkfile set dllocation = REPLACE(dllocation, @oldpath, @newpath)

go



-- c:\_worldstage\copoudre\exportfiles\district.csv
