


EXEC sp_change_users_login 'Auto_Fix', 'TSSMADO'
go

sp_change_users_login 'Update_One','TSSMADO','TSSMADO' 
go


EXEC sp_change_users_login 'Auto_Fix', 'enrich_db_user'
go

sp_change_users_login 'Update_One','enrich_db_user','enrich_db_user' 
go

