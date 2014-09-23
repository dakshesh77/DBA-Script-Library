

0	3185
NULL	283
1	187



select esy, count(*) tot from ieptbl group by esy

alter table IEPTbl
	add constraint DF_ESY default (0) for ESY
go

update IEPTbl set ESY = 0 where ESY is null
go



alter table ieptbl drop constraint Const_IEPTbl_ESY_default


sp_help IEPTbl



sp_help ieptbl





