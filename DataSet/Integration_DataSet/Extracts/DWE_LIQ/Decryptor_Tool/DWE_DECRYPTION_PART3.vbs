Dim objShell
Dim Arg

Set objShell = Wscript.CreateObject ("Wscript.shell")
Set Arg = Wscript.Arguments

var0 = Arg(0)

objShell.SendKeys var0
objShell.SendKeys "{ENTER}"

Set objShell = Nothing
Set Arg = Nothing