###Business Event Output Window###
LIQ_OptionsEventsManagementQueue_Menu   = 'JavaWindow("title:=Fusion Loan IQ .*").JavaMenu("label:=Options").JavaMenu("label:=Events Management - Queue")'
LIQ_BusinessEventOutput_Window  = 'JavaWindow("title:=Business Event Output")'

###Business Event Output Window - Filter Section###
LIQ_BusinessEventOutput_StartDate_Field = 'JavaWindow("title:=Business Event Output").JavaEdit("attached text:=Start Date:")'
LIQ_BusinessEventOutput_EndDate_Field = 'JavaWindow("title:=Business Event Output").JavaEdit("attached text:=End Date:")'
LIQ_BusinessEventOutput_LookUp_Button = 'JavaWindow("title:=Business Event Output").JavaButton("attached text:=Lookup .*")'
LIQ_BusinessEventOutput_LookUp_LookUp_Menu = 'JavaWindow("title:=Business Event Output").WinMenu("menuobjtype:=3")'
LIQ_BusinessEventOutput_EventID_Field = 'JavaWindow("title:=Business Event Output").JavaEdit("attached text:=Event ID.*")'
LIQ_BusinessEventOutput_XML_Section = 'JavaWindow("title:=Business Event Output").JavaObject("text:=<XML>").JavaEdit("tagname:=Text")'

###Business Event Output Window - Statuses Section###
LIQ_BusinessEventOutput_SelectAll_Button = 'JavaWindow("title:=Business Event Output").JavaButton("attached text:=Select All")'
LIQ_BusinessEventOutput_Completed_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Completed")'
LIQ_BusinessEventOutput_Balance_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Balance")'
LIQ_BusinessEventOutput_Pending_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Pending")'
LIQ_BusinessEventOutput_PendingBalance_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Pending Balance")'
LIQ_BusinessEventOutput_Error_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Error")'
LIQ_BusinessEventOutput_Inactive_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Inactive")'
LIQ_BusinessEventOutput_Confirmed_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Confirmed")'
LIQ_BusinessEventOutput_Delivered_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Delivered")'
LIQ_BusinessEventOutput_Failed_CheckBox = 'JavaWindow("title:=Business Event Output").JavaCheckBox("attached text:=Failed")'


###Business Event Output Window - Event Output Records Section###
LIQ_BusinessEventOutput_Refresh_Button = 'JavaWindow("title:=Business Event Output").JavaButton("attached text:=Refresh .*")'
LIQ_BusinessEventOutput_Records = 'JavaWindow("title:=Business Event Output","displayed:=1").JavaTree("labeled_containers_path:=Group:Event Output Records .*")'

###Event Output Record Window###
LIQ_EventOutputRecord_Window = 'JavaWindow("title:=Event Output Record","displayed:=1")'
LIQ_EventOutputRecord_Status_Link = 'JavaWindow("title:=Event Output Record").JavaLink("attached text:=Status:")'
LIQ_EventOutputRecord_XML_Section = 'JavaWindow("title:=Event Output Record","displayed:=1").JavaEdit("attached text:=Query Function:")'