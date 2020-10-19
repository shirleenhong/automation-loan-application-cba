Dim objShell
Dim Arg

Set objShell = Wscript.CreateObject ("Wscript.shell")
Set Arg = Wscript.Arguments

var1 = Arg(0)

objShell.Run "CMD /K CD " & var1
objShell.AppActivate "C:\Windows\system32\cmd.exe"
objShell.SendKeys "{ENTER}"

Set objShell = Nothing
Set Arg = Nothing