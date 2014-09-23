
Use master
go

EXEC sp_configure 'show advanced options', 1
GO

-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

-- may need to map user to the master database

CREATE USER enrich_db_user FROM LOGIN enrich_db_user WITH DEFAULT_SCHEMA = dbo

GRANT EXECUTE ON sys.sp_OACreate TO enrich_db_user 
GRANT EXECUTE ON sys.sp_OAMethod TO enrich_db_user 

SELECT *
FROM sys.sysusers
WHERE name = 'enrich_db_user'

EXEC sp_change_users_login 'Report'
