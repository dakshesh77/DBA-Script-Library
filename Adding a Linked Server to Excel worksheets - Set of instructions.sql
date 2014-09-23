/*

1.  Remember to consider what server the files are on and to set permissions to the files
2.  Use a query window that is logged in to the server with Windows permissions (easiest way) and Windows user account has access to the file
3.  For 62 bit SQL Server, install on the DB server : Microsoft Access Database Engine 2010 Redistributable from http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=13255
4.  Add the linked server using the full file path as the datasrc

EXEC sp_addlinkedserver @server = N'DCLookupPref', 
	@srvproduct=N'ExcelData', @provider=N'Microsoft.ACE.OLEDB.12.0', -- 62 bit OLE Provider for Excel finally available as of late 2010
	@datasrc=N'E:\Lookups Import Files\Enrich Lookups Preferences FL Polk.xlsx',
	@provstr=N'EXCEL 12.0' ;

-- EXEC sp_dropserver DCLookupPref


5.  May also have to run sp_MSset_oledb_prop with the following parameters:
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1

6. To run ad hoc distributed queries run the following:
	sp_configure 'show advanced options', 1;
	RECONFIGURE;
	sp_configure 'Ad Hoc Distributed Queries', 1;
	RECONFIGURE;
GO

7. To see worksheets in the file run
	EXEC sp_tables_ex @table_server = 'DCLookupPref'

8.
	select * from DCLookupPref...README$

9. To use SSMS on one machine to run queries on the target server, start SSMS with this command:
	runas /netonly /user:DISCOVERY\georgeg ssms.exe
	After password you can query the remote server Excel file with the shorthand syntax above
	


10. Another way to query the without adding a linked server is :
	 SELECT *
	FROM OpenDataSource( 'Microsoft.ACE.OLEDB.12.0',
	'Data Source="E:\Lookups Import Files\Enrich Lookups Preferences FL Polk.xlsx";
	User ID=Admin;Password=;Extended properties=Excel 8.0')...README$




*/







