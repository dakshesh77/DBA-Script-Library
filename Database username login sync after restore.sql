declare @UserNamePattern varchar(50), @LoginName varchar(50);

select @UserNamePattern = 'enrich_db_user'
select @LoginName = @UserNamePattern 

exec sp_change_users_login @Action = 'update_one', @UserNamePattern = @UserNamePattern , @LoginName = @LoginName 


UPDATE SystemSettings SET SecurityRebuiltDate = NULL



