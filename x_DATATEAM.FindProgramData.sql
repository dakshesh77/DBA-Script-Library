alter view x_DATATEAM.FindProgramData
as
select s.Number, S.Firstname, s.Lastname, 
 ItemType = it.Name, ItemDef = id.Name, 
 SectionType = st.Name, SectionTitle = sd.Title, 
 sd.FormTemplateID, sd.HeaderFormTemplateID,
 ps.ItemID, SectionID = ps.ID, i.StudentID
from Student s
join PrgItem i on s.ID = i.StudentID
join PrgItemDef id on i.DefID = id.ID
join PrgItemType it on id.TypeID = it.ID
join PrgSection ps on i.ID = ps.ItemID
join PrgSectionDef sd on ps.DefID = sd.ID
join PrgSectionType st on sd.TypeID = st.ID
go