'author: Marvin Nanquilada
'date: 08/14/2018
'objective: execute hp uft and run RoboUFT script
set q=createobject("quicktest.application")
q.visible=true
q.launch
q.open "C:\MTAF\Test Automation Suite\Execution\App\Initialization Module\RoboUFT"
q.test.run

set q=nothing