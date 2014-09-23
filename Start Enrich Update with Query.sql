
declare @productVersion varchar(20), @y char(4), @m varchar(2), @d varchar(2) ; select @productVersion = '7.27.6.3552', @y = '2012', @m = '8', @d = '3'
insert VC3TaskScheduler.ScheduledTaskSchedule (ID, TaskTypeID, Parameters, IsEnabled, EnabledDate, LastRunTime, FrequencyAmount, FrequencyTypeID, YearTrigger, MonthTrigger, DayTrigger, HourTrigger, MinuteTrigger, MonTrigger, TuesTrigger, WedsTrigger, ThursTrigger, FriTrigger, SatTrigger, SunTrigger) 
values (NEWID(), 
 '9E307113-0C89-4FF7-AD9C-36B63B74F7E1', 
 '<?xml version="1.0" encoding="utf-16"?>  <ArrayOfDictionaryEntry xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">    <DictionaryEntry>      <Key xsi:type="xsd:string">Version</Key>      <Value xsi:type="xsd:string">'+@productVersion+'</Value>    </DictionaryEntry>  </ArrayOfDictionaryEntry>', 
 1, GETDATE(), NULL, 1, 'O', 
 @y, @m, @d, '1', '30', 
 0, 0, 0, 0, 0, 0, 0)
