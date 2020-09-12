Dim objShell
Dim Arg, DWE_DECRYPT_PATH, DWE_DECRYPTOR_JAR

Set objShell = Wscript.CreateObject ("Wscript.shell")
Set Arg = Wscript.Arguments

var0 = Arg(0)

objShell.SendKeys "java -jar " & var0
objShell.SendKeys "{ENTER}"

Set objShell = Nothing
Set Arg = Nothing