
if exists (select 1 from sysobjects where name = 'udf_StripNonNumeric')
drop function dbo.udf_StripNonNumeric
go

create function dbo.udf_StripNonNumeric (
	@s varchar(4000)
)
Returns varchar(4000)
as
/*
	Adapted from sample found at http://www.nigelrivett.net/SQLTsql/RemoveNonNumericCharacters.html
*/
begin
declare @i int
select @i = patindex('%[^0-9]%', @s)
	while @i > 0
	begin
		select @s = replace(@s, substring(@s, @i, 1), '')
		select @i = patindex('%[^0-9]%', @s)
	end
RETURN @s
end
go