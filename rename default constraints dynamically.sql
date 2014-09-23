



select 'exec sp_rename ' + o.name + ', DF_' + t.name + '_' + c.name
from syscolumns c
inner join sysobjects o
on c.cdefault = o.id
inner join sysobjects t
on c.id = t.id
where c.cdefault <> 0
and o.name <> 'DF_' + t.name + '_' + c.name
order by o.name








