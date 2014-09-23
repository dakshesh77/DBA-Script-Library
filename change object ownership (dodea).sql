

select * from setting

-- script to change object ownership
declare @OldOwner varchar(100), @NewOwner varchar(100) ; select @OldOwner = 'excent', @NewOwner = 'dbo'

-- views
select 'sp_changeobjectowner ''[' + table_schema + '].[' + table_name + ']'', ''' + @NewOwner + '''
go'  
from information_schema.views 
where Table_schema = @OldOwner



-- stored procedures and functions
select 'sp_changeobjectowner ''[' + routine_schema + '].[' + routine_name + ']'', ''' + @NewOwner + '''
go'  
from information_schema.routines 
where routine_schema = @OldOwner
and Routine_type in ('procedure', 'function')


select * from information_schema.routines 







<root>  
<root><value><src><![CDATA[\x01]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x12]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x03]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x04]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x05]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x18]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x0B]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x1e]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x06]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x02]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x1b]]></src><dest/></value></root>  
<root><value><src><![CDATA[\x17]]></src><dest/></value></root>  
<root><value><src><![CDATA[\xf4\xf4\xf4\xf4]]></src><dest><![CDATA[&lt;]]></dest></value></root>  
<root><value><src><![CDATA[\xa7\xa7\xa7\xa7]]></src><dest><![CDATA[&gt;]]></dest></value></root>  
<root><value><src><![CDATA[\xde\xde\xde\xde]]></src><dest><![CDATA[<]]></dest></value></root>  
<root><value><src><![CDATA[\xdf\xdf\xdf\xdf]]></src><dest><![CDATA[>]]></dest></value></root>  
<root><value><src><![CDATA[\xd8\xd8\xd8\xd8]]></src><dest><![CDATA[&quot;]]></dest></value></root>  
</root>






