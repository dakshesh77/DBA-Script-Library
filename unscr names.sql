
/*

if exists (select 1 from sysobjects where name = 'fn_ScrambledEggs')
drop function fn_ScrambledEggs

CREATE FUNCTION fn_ScrambledEggs
  (@string AS NVARCHAR(4000), @pattern AS NVARCHAR(4000))
  RETURNS VARCHAR(4000)
AS
/*	This function was created specifically for preparing Contacts.ConName for parsing to derive 1 or 2 contacts from a free-form varchar column
	Usage:
	replace(replace(replace(dbo.fn_ScrambledEggs(replace(replace(conname, '&', ' and '), '/', ' and '), '%[^-'' a-zA-Z]%'), ' ', ' ' + '!'), '!' + ' ', ''), '!', '') CleanConName
	See view : ContactsCleanNames
*/
BEGIN
  DECLARE @pos INT, @charcount int;
  select @pos = PATINDEX(@pattern, @string), @charcount = len(@string)

  WHILE @pos > 0
  BEGIN
    SET @string = STUFF(@string, @pos, 1, N'');
    SET @pos = PATINDEX(@pattern, @string);
  END

  WHILE @charcount > 0
  BEGIN
	SET @string = STUFF(@string, @charcount, 1, 
	char(
		case when 
			case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
				then ascii(substring(@string, @charcount, 1))-32 
				else ascii(substring(@string, @charcount, 1)) 
			end 
		between 65 and 78 
			then 
				case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
					then ascii(substring(@string, @charcount, 1))-32 
					else ascii(substring(@string, @charcount, 1)) 
				end+5
			else 
				case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
					then ascii(substring(@string, @charcount, 1))-32 
					else ascii(substring(@string, @charcount, 1)) 
				end-3
			end));
    select @charcount = @charcount - 1
  END

  RETURN @string;
END


select char(65) -- A
select char(78) -- N
select char(ascii('A')+5)
select char(ascii('N')+5)

select ascii('A')
select ascii('N')

select char(65+5) -- F
select char(78+5) -- S

select ascii('F') -- 70
select ascii('K') -- 75

select ascii('T') -- 84
select ascii('W') -- 87



select char(79)
select char(90)
select char(ascii('O')-3)
select char(ascii('Z')-3)

select ascii('O')
select ascii('Z')


select char(79)
select char(90)
select ascii('L')
select ascii('W')

select char(79-3) -- L
select char(90-3) -- W


A		
B		
C		
D		
E		
F	.		-5
G	.		-5
H	.		-5
I	.		-5
J	.		-5
K	.		-5
L	.	+	-5	+3
M	.	+	-5	+3
N	.	+	-5	+3
O	.	+	-5	+3
P	.	+	-5	+3
Q	.	+	-5	+3
R	.	+	-5	+3
S	.	+	-5	+3
T		+		+3
U		+		+3
V		+		+3
W		+		+3
X		
Y		
Z		


select ascii('F') -- 70
select ascii('K') -- 75

select ascii('T') -- 84
select ascii('W') -- 87

select ascii('L') -- 76
select ascii('S') -- 83


select dbo.fn_ScrambledEggs(replace(replace('George' , '&', ' and '), '/', ' and '), '%[^-'' a-zA-Z]%')




*/


if exists (select 1 from sysobjects where name = 'fn_ScrambledEggs')
drop function fn_ScrambledEggs

CREATE FUNCTION fn_ScrambledEggs
  (@string AS NVARCHAR(4000), @pattern AS NVARCHAR(4000))
  RETURNS VARCHAR(4000)
AS
/*	This function was created specifically for preparing Contacts.ConName for parsing to derive 1 or 2 contacts from a free-form varchar column
	Usage:
	replace(replace(replace(dbo.fn_ScrambledEggs(replace(replace(conname, '&', ' and '), '/', ' and '), '%[^-'' a-zA-Z]%'), ' ', ' ' + '!'), '!' + ' ', ''), '!', '') CleanConName
	See view : ContactsCleanNames
*/
BEGIN
  DECLARE @pos INT, @charcount int;
  select @pos = PATINDEX(@pattern, @string), @charcount = len(@string)

  WHILE @pos > 0
  BEGIN
    SET @string = STUFF(@string, @pos, 1, N'');
    SET @pos = PATINDEX(@pattern, @string);
  END

  WHILE @charcount > 0
  BEGIN
	SET @string = STUFF(@string, @charcount, 1, 
	char(
		case when 
			case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
				then ascii(substring(@string, @charcount, 1))-32 
				else ascii(substring(@string, @charcount, 1)) 
			end 
		between 70 and 75
			then 
				case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
					then ascii(substring(@string, @charcount, 1))-32 
					else ascii(substring(@string, @charcount, 1)) 
				end-5
			when ascii(substring(@string, @charcount, 1)) between 97 and 122 
				then ascii(substring(@string, @charcount, 1))-32 
				else ascii(substring(@string, @charcount, 1)) 
			end 
		between 84 and 87
			then
				case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
					then ascii(substring(@string, @charcount, 1))-32 
					else ascii(substring(@string, @charcount, 1)) 
				end+3
			when ascii(substring(@string, @charcount, 1)) between 97 and 122 
				then ascii(substring(@string, @charcount, 1))-32 
				else ascii(substring(@string, @charcount, 1)) 
			end 
		between 76 and 83
			then
				case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
					then ascii(substring(@string, @charcount, 1))-32 
					else ascii(substring(@string, @charcount, 1)) 
				end-5
			then
				case when ascii(substring(@string, @charcount, 1)) between 97 and 122 
					then ascii(substring(@string, @charcount, 1))-32 
					else ascii(substring(@string, @charcount, 1)) 
				end+3



			end));
    select @charcount = @charcount - 1
  END

  RETURN @string;
END





