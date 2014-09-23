

use master -- prevent this from accidentally being run in the wrong context
go

use ELINK_COBO
go

declare @oldpath varchar(150), @newpath varchar(150) ; 
select 
	@oldpath = 'c:\_worldstage\FLPolk\',
	@newpath = 'c:\_worldstage\COBoulder\'

update dlinkfile set dllocation = REPLACE(dllocation, @oldpath, @newpath)

go

select * from dlinkfile 

select * from codes -- 4049141950396533 = comma delimiter (FDELIMETER)
select * from dlelement where de_table = 'STUDENT'
select * from dlimport
select * from dlinkfile

-- set all fields in all files to double-quoted comma delimited
update dlinkfile set dl_delim = '4049142024255289', dl_quote = 1 where dl_delim <> '4049142024255289' -- comma

-- set to pipe
update dlinkfile set dl_delim = '4049142003445579', dl_quote = 0 where dl_delim <> '4049142003445579' -- 



select * from dltable
select * from imptable order by iorder


-- select * from imprecsel




