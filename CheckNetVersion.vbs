Option Explicit
Dim oShell
Dim value

''#If the key isn't there when we try to read it, an error will be generated
''# that we will later test for, so we want to automatically resume execution.
On Error Resume Next

''#Try reading the registry value
Set oShell = CreateObject("WScript.Shell")
value = oShell.RegRead("HKLM\SOFTWARE\Microsoft\.NETFramework\Policy\v2.0\50727")

''#Catch the error
If Err.Number = 0 Then
    ''#Error code 0 indicates success
    MsgBox("Version 2.0 of the .NET Framework is installed.")
Else
    ''#Any other error code indicates failure
    MsgBox("Version 2.0 of the .NET Framework is NOT installed.")
End If
