### Event Fee Notebook - General Tab ###
LIQ_EventFee_Window = 'JavaWindow("title:=.*Fee.*","index:=0")'
LIQ_EventFee_Javatab = 'JavaWindow("title:=.*Fee.*","index:=0").JavaTab("index:=0")'
LIQ_EventFee_RequestedAmount_Textfield = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("attached text:=Requested Amount:")'
LIQ_EventFee_General_EffectiveDate = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("labeled_containers_path:=Tab:General;","attached text:=Effective Date:")'
LIQ_EventFee_FeeType_Combobox = 'JavaWindow("title:=.*Fee.*","index:=0").JavaList("attached text:=Fee Type:")'
LIQ_EventFee_RecurringFee_Checkbox = 'JavaWindow("title:=.*Fee.*","index:=0").JavaCheckBox("attached text:=Recurring Fee")'
LIQ_EventFee_NoRecurrencesAfter_Datefield = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("tagname:=Text","x:=935","y:=190")'
LIQ_EventFee_BillingDays_Textfield = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("labeled_containers_path:=Tab:General;Group:Billing Rules;","attached text:=Billing days:")'
LIQ_EventFee_Comment_Textfield = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("labeled_containers_path:=Tab:General;Group:Comment;")'
LIQ_EventFee_File_Save = 'JavaWindow("title:=.*Fee.*","index:=0").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_EventFee_File_Exit = 'JavaWindow("title:=.*Fee.*","index:=0").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_EventFee_Options_Payment = 'JavaWindow("title:=.*Fee.*","index:=0").JavaMenu("label:=Options").JavaMenu("label:=Payment")'


### Event Fee Notebook - Frequency Tab ###
LIQ_EventFee_Frequency_EffectiveDate = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("labeled_containers_path:=Tab:Frequency;","attached text:=Effective Date:")'
LIQ_EventFee_Frequency_Combobox = 'JavaWindow("title:=.*Fee.*","index:=0").JavaList("labeled_containers_path:=Tab:Frequency;","attached text:=Frequency:")'
LIQ_EventFee_NonBussDayRule_Combobox = 'JavaWindow("title:=.*Fee.*","index:=0").JavaList("labeled_containers_path:=Tab:Frequency;","attached text:=Non-Business Day Rule:")'
LIQ_EventFee_ActualNextOccurence_Datefield = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("attached text:=Actual Next Occurrence Date:")'
LIQ_EventFee_AdjustedNextOccurence_Datefield = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("attached text:=Actual Next Occurrence Date:")'
LIQ_EventFee_EndDate_Field = 'JavaWindow("title:=.*Fee.*","index:=0").JavaEdit("attached text:=End Date:")'

### Event Fee Notebook - Workflow Tab ###
LIQ_EventFee_Workflow_Tree = 'JavaWindow("title:=.*Fee.*","index:=0").JavaTree("labeled_containers_path:=Tab:Workflow;","attached text:=.*Workflow item")'


LIQ_EventFeeNotebook_Window = 'JavaWindow("title:=.*Fee.*","displayed:=1")'
LIQ_EventFeeNotebook_Javatab = 'JavaWindow("title:=.*Fee .*").JavaTab("text:=Events")'
LIQ_EventFeeNotebook_RequestedAmount_Textfield = 'JavaWindow("title:=.*Fee.*").JavaEdit("attached text:=Requested Amount:")'
LIQ_EventFeeNotebook_EffectiveDate_Datefield = 'JavaWindow("title:=.*Fee.*").JavaEdit("attached text:=Effective Date:")'
LIQ_EventFeeNotebook_FeeType_Combobox = 'JavaWindow("title:=.*Fee.*").JavaList("attached text:=Fee Type:")'
LIQ_EventFeeNotebook_RecurringFee_Checkbox = 'JavaWindow("title:=.*Fee.*").JavaCheckBox("attached text:=Recurring Fee")'
LIQ_EventFeeNotebook_NoRecurrencesAfter_Datefield = 'JavaWindow("title:=.*Fee.*").JavaEdit("attached text:=No Recurrences After Date:")'
LIQ_EventFeeNotebook_BillingDays_Textfield = 'JavaWindow("title:=.*Fee.*").JavaObject("tagname:=Group","attached text:=Billing days:")'
LIQ_EventFeeNotebook_Comment_Textfield = 'JavaWindow("title:=.*Fee.*").JavaEdit("labeled_containers_path:=Tab:General;Group:Comment;")'
LIQ_EventFeeNotebook_FileExit_Menu = 'JavaWindow("title:=.* Fee Fee / Released.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Exit")'


###Tab
LIQ_EventFeeNotebook_PendingTab_Window = 'JavaWindow("title:=.*Fee.*.*Pending.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_EventFee_AwaitingSend_Tab= 'JavaWindow("title:=.* Fee Fee / Awaiting Send To Approval.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_EventFee_AwaitingApproval_Tab= 'JavaWindow("title:=.* Fee Fee / Awaiting Approval.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_EventFee_AwaitingRelease_Tab= 'JavaWindow("title:=.* Fee Fee / Awaiting Release.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_EventFee_Released_Tab= 'JavaWindow("title:=.* Fee Fee / Released.*","displayed:=1").JavaTab("tagname:=TabFolder")'

###Window
LIQ_EventFee_Pending_Window = 'JavaWindow("title:=.*Fee.*.*Pending.*","displayed:=1")'
LIQ_EventFee_AwaitingSend_Window = 'JavaWindow("title:=.* Fee Fee / Awaiting Send To Approval.*","displayed:=1")'
LIQ_EventFee_AwaitingApproval_Window = 'JavaWindow("title:=.* Fee Fee / Awaiting Approval.*","displayed:=1")'
LIQ_EventFee_AwaitingRelease_Window = 'JavaWindow("title:=.* Fee Fee / Awaiting Release.*","displayed:=1")'
LIQ_EventFee_Released_Window = 'JavaWindow("title:=.* Fee Fee / Released.*","displayed:=1")'


###Events Tab
LIQ_EventFee_Events_Tree = 'JavaWindow("title:=.* Fee Fee / Released.*","displayed:=1").JavaTree("attached text:=Select event to view details")'
LIQ_EventFee_Events_JavaTree = 'JavaWindow("title:=.* Fee .*").JavaTree("attached text:=Select event to view details")'

###Event Fee - Workflow List###
LIQ_EventFee_WorkflowItems_Pending_List = 'JavaWindow("title:=.* Fee Fee / Pending.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_EventFee_WorkflowItems_AwaitingSend_List = 'JavaWindow("title:=.* Fee Fee / Awaiting Send To Approval.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_EventFee_WorkflowItems_AwaitingApproval_List = 'JavaWindow("title:=.* Fee Fee / Awaiting Approval.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_EventFee_WorkflowItems_AwaitingRelease_List = 'JavaWindow("title:=.* Fee Fee / Awaiting Release.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'



### Cashflow for Event Fee ###

LIQ_EventFee_Cashflow_Window = 'JavaWindow("title:=Cashflows For .*")'
LIQ_EventFee_Cashflow_Ok_Button = 'JavaWindow("title:=Cashflows For Legal Fee Fee").JavaButton("attached text:=OK")'
LIQ_EventFee_Cashflows_List = 'JavaWindow("title:=Cashflows For Legal Fee Fee").JavaTree("attached text:=Drill down to view/change details")'
LIQ_EventFee_Cashflows_DoIt_Button = 'JavaWindow("title:=Cashflows For Legal Fee Fee").JavaButton("label:=Set Selected Item To .*")'
LIQ_EventFee_Queries_GLEntries_Cashflow = 'JavaWindow("title:=Cashflows For Legal Fee Fee").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_EventFee_Cashflow_HostBankCash_JavaEdit = 'JavaWindow("title:=Cashflows .* Legal Fee Fee.*").JavaStaticText("to_class:=JavaStaticText","index:=28")'