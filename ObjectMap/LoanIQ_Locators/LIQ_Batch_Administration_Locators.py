####MASTER####
LIQ_Batch_Admin_Window = 'JavaWindow("title:=.* Batch Admin.*")'
LIQ_Batch_Admin_Master_ComboBox = 'JavaWindow("title:=.* Batch Admin.*").JavaList("labeled_containers_path:=Group:Batch Nets;")'
LIQ_Batch_Admin_Inquiry_Mode_Button = 'JavaWindow("title:=.* Batch Admin.*").JavaButton("attached text:=In Inquiry Mode - F7")'
LIQ_Batch_Admin_Add_Button = 'JavaWindow("title:=.* Batch Admin.*").JavaButton("attached text:=Add")'
LIQ_Batch_Admin_Execution_Journal_Button = 'JavaWindow("title:=.* Batch Admin.*").JavaButton("attached text:=Execution Journal")'
LIQ_Batch_Java_Tree = 'JavaWindow("title:=.* Batch Admin.*").JavaTree("labeled_containers_path:=Group:Schedule for.*")'
LIQ_Batch_Admin_Remove_Button = 'JavaWindow("title:=.* Batch Admin.*").JavaButton("attached text:=Remove")'
LIQ_Batch_Admin_Options_Environment = 'JavaWindow("title:=.*Batch Admin.*").JavaMenu("label:=Options").JavaMenu("label:=Environment")'
LIQ_Batch_Admin_TimeZone_JavaTree = 'JavaWindow("title:=.* Batch Admin.*").JavaTree("labeled_containers_path:=Group:Time Zones;")'
LIQ_Batch_Admin_Refresh_Button = 'JavaWindow("title:=.* Batch Admin.*").JavaButton("attached text:=Refresh")'

####SCHEDULED EDITOR####
LIQ_Scheduled_Editor_Window = 'JavaWindow("title:=ScheduleEditorSchedule.*")'
LIQ_Scheduled_Editor_Frequency_ComboBox = 'JavaWindow("title:=ScheduleEditorSchedule.*").JavaList("attached text:=Frequency:")'
LIQ_Scheduled_Editor_Date= 'JavaWindow("title:=ScheduleEditorSchedule.*").JavaEdit("attached text:=Date:")'
LIQ_Scheduled_Editor_Cancel_Button ='JavaWindow("title:=ScheduleEditorSchedule.*").JavaButton("attached text:=Cancel")'
LIQ_Scheduled_Editor_Location_ComboBox = 'JavaWindow("title:=ScheduleEditorSchedule.*").JavaList("attached text:=Location:")'
LIQ_Scheduled_Editor_Ok_Button = 'JavaWindow("title:=ScheduleEditorSchedule.*").JavaButton("attached text:=OK")'


###EXECUTION JOURNAL####
LIQ_Execution_Scheduled_ExecutionDate_ComboBox = 'JavaWindow("title:=Exec Journal.*").JavaList("attached text:=Execution Date:")'
LIQ_Execution_Scheduled_File_Purge_Menu = 'JavaWindow("title:=Exec Journal.*").JavaMenu("label:=File").JavaMenu("label:=Purge...")'
LIQ_Execution_Scheduled_File_Purge_From_Date = 'JavaWindow("title:=Exec Journal.*").JavaWindow("title:=Purge...").JavaEdit("attached text:=From Date:")'
LIQ_Execution_Scheduled_File_Purge_To_Date = 'JavaWindow("title:=Exec Journal.*").JavaWindow("title:=Purge...").JavaEdit("attached text:=To Date:")'
LIQ_Execution_Scheduled_File_Purge_Ok_Button = 'JavaWindow("title:=Exec Journal.*").JavaWindow("title:=Purge...").JavaButton("attached text:=OK")'
LIQ_Execution_Scheduled_Items_Count = 'JavaWindow("title:=Exec Journal.*").JavaTree("items count:=0","attached text:=Execution Date:")'
LIQ_Execution_Scheduled_File_Purge_Cancel_Button = 'JavaWindow("title:=Exec Journal.*").JavaWindow("title:=Purge...").JavaButton("attached text:=Cancel")'
LIQ_Execution_Window = 'JavaWindow("title:=Exec Journal.*")'
LIQ_Execution_Scheduled_JavaTree = 'JavaWindow("title:=Exec Journal.*").JavaTree("attached text:=Execution Date:")'
LIQ_Execution_Scheduled_File_Refresh = 'JavaWindow("title:=Exec Journal.*").JavaMenu("label:=File").JavaMenu("label:=Refresh")'
LIQ_Execution_Scheduled_Location_ComboBox = 'JavaWindow("title:=.*Exec Journal.*").JavaList("attached text:=Location.*")'

###ENVIRONMENT PARAMETER###
LIQ_Environment_Parameter_Window = 'JavaWindow("title:=Environment Parameters")'
LIQ_Environment_Parameter_JavaTree = 'JavaWindow("title:=Environment Parameters").JavaTree("attached text:=Double-click to modify.")'
LIQ_Environment_Param_Window = 'JavaWindow("title:=EnvParamEditor.*")'
LIQ_Environment_Param_Value = 'JavaWindow("title:=EnvParamEditor.*").JavaEdit("attached text:=Value:")'
LIQ_Environment_OK_Button = 'JavaWindow("title:=EnvParamEditor.*").JavaButton("attached text:=OK")'
LIQ_Environment_Cancel_Button = 'JavaWindow("title:=EnvParamEditor.*").JavaButton("attached text:=Cancel")'