-- Delete the row and re-insert it with a status of P for Pending.   See if the task service grabs it
-- delete VC3TaskScheduler.ScheduledTask where ID = '229C76EE-A2AA-4751-B540-E24ACC4DB635'


-- Finalize TestView update	
declare @version varchar(20); 
insert VC3TaskScheduler.ScheduledTask values ('229C76EE-A2AA-4751-B540-E24ACC4DB635', '4955FEBD-B332-4191-9D8B-0B33469C31EA', NULL, '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">Version</Key>      <Value xsi:type="xsd:string">'+@version+'</Value>    </DictionaryEntry>    <DictionaryEntry>      <Key xsi:type="xsd:string">WasSuccessful</Key>      <Value xsi:type="xsd:boolean">true</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>', 'P', NULL, '2012-08-20 09:05:02.617', '2012-08-20 09:05:09.337', NULL)

