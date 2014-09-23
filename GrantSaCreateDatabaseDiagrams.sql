EXEC sp_dbcmptlevel 'Richland1_Enrich', '90';
go
ALTER AUTHORIZATION ON DATABASE::Richland1_Enrich TO "sa"
go
use [Richland1_Enrich]
go
EXECUTE AS USER = N'dbo' REVERT
go
