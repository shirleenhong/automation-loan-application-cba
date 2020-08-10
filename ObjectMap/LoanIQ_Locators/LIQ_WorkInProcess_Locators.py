LIQ_TransactionInProcess_Window = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter")'
LIQ_TransactionInProcess_Tree = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaTree("labeled_containers_path:=Group:Transactions;")'
LIQ_TransactionInProcess_Payments_Tree = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaTree("labeled_containers_path:=Group:Details;Tab:Payments;")'
LIQ_TransactionInProcess_File_Refresh = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaMenu("label:=File").JavaMenu("label:=Refresh")'
LIQ_TransactionInProcess_File_ChangeTargetDate = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaMenu("label:=File").JavaMenu("label:=Change Target Date...")'
LIQ_TransactionInProcess_CollapseAll_Button = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaObject("tagname:=Group","text:=Details").JavaButton("label:=Collapse All")'

LIQ_TransactionsInProcess_Transactions_List = 'JavaWindow("title:=Transactions In Process.*").JavaObject("text:=Transactions").JavaTree("tagname:=Tree")'
LIQ_TransactionsInProcess_Outstanding_List = 'JavaWindow("title:=.*Transactions In Process.*").JavaTree("attached text:=Target Date:")'
LIQ_TransactionsInProcess_ScheduledActivity_Menu = 'JavaWindow("title:=Transactions In Process.*","displayed:=1").JavaMenu("label:=Queries").JavaMenu("label:=Scheduled Activity")'

LIQ_Activate_LIQWindow = 'JavaWindow("title:=Fusion Loan IQ -.*")'
LIQ_WorkInProgress_Button = 'JavaWindow("title:=Fusion Loan IQ -.*").JavaButton("index:=7")'
LIQ_WorkInProgress_TransactionList = 'JavaWindow("title:=Transactions In Process.*").JavaObject("text:=Transactions").JavaTree("tagname:=List")'
LIQ_WorkInProgress_TransactionStatus_List = 'JavaWindow("title:=Transactions In Process.*").JavaTree("attached text:=Target Date:")'
LIQ_WorkInProgress_ManualTrans_List = 'JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=.*Manual Trans.*")'
LIQ_WorkInProgress_TransactionDetails_List = 'JavaWindow("title:=.*Transactions In Process.*").JavaTree("attached text:=0")'
LIQ_WorkInProgress_Window = 'JavaWindow("title:=Transactions In Process.*")'
LIQ_WorkInProgress_Queries_ExceptionQueue = 'JavaWindow("title:=Transactions In Process.*").JavaMenu("label:=Queries").JavaMenu("label:=Exception Queue")' 
LIQ_WorkInProgress_ExceptionQueue_Window = 'JavaWindow("title:=Logged Exception List")'
LIQ_WorkInProgress_ExceptionQueue_JavaTree = 'JavaWindow("title:=Logged Exception List").JavaTree("attached text:=Outcome")'
LIQ_WorkInProgress_ExceptionQueue_RefreshButton = 'JavaWindow("title:=Logged Exception List").JavaButton("attached text:=Refresh List")'
LIQ_WorkInProgress_ExceptionQueue_Transaction = 'JavaWindow("title:=Logged Exception List").JavaObject("text:=Logged Exceptions").JavaEdit("tagname:=Transaction")'  

LIQ_TransactionsInProcess_Window = 'JavaWindow("title:=Transactions In Process.*","displayed:=1")'
LIQ_TransactionsInProcess_Transations_JavaTree = 'JavaWindow("title:=Transactions In Process.*","displayed:=1").JavaObject("tagname:=Group","text:=Transactions").JavaTree("enabled:=1")'
LIQ_TransactionsInProcess_TargetDate_JavaTree = 'JavaWindow("title:=Transactions In Process.*","displayed:=1").JavaTree("attached text:=Target Date:.*")'
LIQ_TransactionsInProcess_Queries_ScheduledActivity = 'JavaWindow("title:=Transactions In Process.*").JavaMenu("label:=Queries").JavaMenu("label:=Scheduled Activity")'
LIQ_TransactionsInProcess_Queries_ScheduledActivity_Menu = 'JavaWindow("title:=Transactions In Process.*").JavaMenu("label:=Queries").JavaMenu("label:=Scheduled Activity")'
LIQ_TransactionsInProcess_FileExit_Menu = 'JavaWindow("title:=Transactions In Process.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'

####Scheduled Activity####
LIQ_ScheduledActivityFilter_Window = 'JavaWindow("title:=Scheduled Activity Filter")'
LIQ_ScheduledActivityFilter_From_Datefield = 'JavaWindow("title:=Scheduled Activity Filter").JavaEdit("attached text:=From:")'
LIQ_ScheduledActivityFilter_Thru_Datefield = 'JavaWindow("title:=Scheduled Activity Filter").JavaEdit("attached text:=Thru:")'
LIQ_ScheduledActivityFilter_Deal_Button = 'JavaWindow("title:=Scheduled Activity Filter").JavaButton("attached text:=Deal:")'
LIQ_ScheduledActivityFilter_OK_Button = 'JavaWindow("title:=Scheduled Activity Filter").JavaButton("attached text:=OK")'
LIQ_ScheduledActivityReport_Window = 'JavaWindow("title:=Scheduled Activity Report.*")'
LIQ_ScheduledActivityReport_CollapseAll_Button = 'JavaWindow("title:=Scheduled Activity Report.*").JavaButton("attached text:=Collapse All")'
LIQ_ScheduledActivityReport_List = 'JavaWindow("title:=Scheduled Activity Report.*").JavaTree("tagname:=Tree")'


######dev#######
LIQ_TransactionsInProcess_Circles_List= 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaTree("labeled_containers_path:=Group:Details;Tab:Circles;")'

###Work In Process - Scheduled Activity Filter###
LIQ_ScheduledActivityFilter_FromDate_Field = 'JavaWindow("title:=Scheduled Activity Filter.*").JavaEdit("attached text:=From:")'
LIQ_ScheduledActivityFilter_ThruDate_Field = 'JavaWindow("title:=Scheduled Activity Filter.*").JavaEdit("attached text:=Thru:")'
LIQ_ScheduledActivityFilter_Department_List = 'JavaWindow("title:=Scheduled Activity Filter.*").JavaList("attached text:=Department.*")'
LIQ_ScheduledActivityFilter_Branch_List = 'JavaWindow("title:=Scheduled Activity Filter.*").JavaList("attached text:=Branch.*")'
LIQ_ScheduledActivityFilter_Deal_Button = 'JavaWindow("title:=Scheduled Activity Filter.*").JavaButton("attached text:=Deal:")'
LIQ_ScheduledActivityFilter_OK_Button = 'JavaWindow("title:=Scheduled Activity Filter.*").JavaButton("attached text:=OK")'
LIQ_ScheduledActivityFilter_Window = 'JavaWindow("title:=Scheduled Activity Filter.*")'

###Work In Process - Scheduled Activity Report###
LIQ_ScheduledActivityReport_Tree = 'JavaWindow("title:=Scheduled Activity Report.*").JavaTree("tagname:=Tree")'
LIQ_ScheduledActivityReport_ExpandAll_Button = 'JavaWindow("title:=Scheduled Activity Report.*").JavaButton("attached text:=Expand All")'
LIQ_ScheduledActivityReport_ViewBy_Combobox = 'JavaWindow("title:=Scheduled Activity Report.*").JavaList("attached text:=View By:")'


###Change Target Date###
LIQ_ChangeTargetDate_Window = 'JavaWindow("title:=Transactions In Process.*").JavaWindow("title:=Change Target Date")'
LIQ_ChangeTargetDate_DateField = 'JavaWindow("title:=Transactions In Process.*").JavaWindow("title:=Change Target Date").JavaEdit("attached text:=Target Date:")'
LIQ_ChangeTargetDate_Ok_Button = 'JavaWindow("title:=Transactions In Process.*").JavaWindow("title:=Change Target Date").JavaButton("attached text:=OK")'

###Logged Exception List Window###
LIQ_WorkInProgress_ExceptionQueue_Queries = 'JavaWindow("title:=Transactions In Process.*").JavaMenu("label:=Queries").JavaMenu("label:=Exception Queue")'
LIQ_WorkInProgress_LoggedExceptionList_Window = 'JavaWindow("title:=Logged Exception List","displayed:=1")'
LIQ_LoggedExceptionList_FromDate_Field = 'JavaWindow("title:=Logged Exception List").JavaEdit("attached text:=From:")'
LIQ_LoggedExceptionList_ToDate_Field = 'JavaWindow("title:=Logged Exception List").JavaEdit("attached text:=To:")'
LIQ_LoggedExceptionList_RefreshList_Button = 'JavaWindow("title:=Logged Exception List").JavaButton("attached text:=Refresh List")'
LIQ_LoggedExceptionList_Deal_Field  = 'JavaWindow("title:=Logged Exception List").JavaEdit("attached text:=Deal")'
LIQ_LoggedExceptionList_Items_JavaTree = 'JavaWindow("title:=Logged Exception List").JavaTree("labeled_containers_path:=Group:Logged Exceptions.*","attached text:=Outcome")'


LIQ_WorkInProgress_ExceptionQueue_LoggedExceptionERR_Window = 'JavaWindow("title:=Logged Exception: ERR","displayed:=1")'
LIQ_LoggedExceptionERR_TranRID_StaticText = 'JavaWindow("title:=Logged Exception: ERR","displayed:=1").JavaStaticText("index:=5")'
LIQ_LoggedExceptionERR_Description_Field = 'JavaWindow("title:=Logged Exception: ERR","displayed:=1").JavaEdit("attached text:=Description:")'
LIQ_LoggedExceptionERR_Close_Button = 'JavaWindow("title:=Logged Exception: ERR","displayed:=1").JavaButton("attached text:=Close")'
