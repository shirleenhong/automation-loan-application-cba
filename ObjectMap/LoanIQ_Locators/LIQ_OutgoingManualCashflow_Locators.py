
###OutgoingManualCashflow###
LIQ_OutgoingManualCashflow_Window = 'JavaWindow("title:=Outgoing Manual Cashflow .*","displayed:=1")'
LIQ_OutgoingManualCashflow_Tab = 'JavaWindow("title:=Outgoing Manual Cashflow .*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_OutgoingManualCashflow_Options_GLEntries = 'JavaWindow("title:=Outgoing Manual Cashflow .*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=GL Entries")'

###OutgoingManualCashflow-General Tab###
LIQ_OutgoingManualCashflow_Branch_List = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaList("attached text:=Branch:")'
LIQ_OutgoingManualCashflow_EffectiveDate_Field = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaEdit("index:=0")'
LIQ_OutgoingManualCashflow_Currency_List = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaList("attached text:=Currency:")'
LIQ_OutgoingManualCashflow_Amount_Field = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaEdit("attached text:=Amount:")'
LIQ_OutgoingManualCashflow_Description_Field =  'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaEdit("attached text:=Description:")'
LIQ_OutgoingManualCashflow_ProcArea_List = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaList("attached text:=Proc.* Area:")'
LIQ_OutgoingManualCashflow_BranchServicingGroup_StaticText = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaStaticText("attached text:=LOAN")'
LIQ_OutgoingManualCashflow_Customer_StaticText = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaStaticText("index:=11")'
LIQ_OutgoingManualCashflow_Expense_Field= 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaEdit("attached text:=Effective Date:","index:=1")'
LIQ_OutgoingManualCashflow_ServicingGroup_Button = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaButton("attached text:=Servicing Group")'
LIQ_OutgoingManualCashflow_AddDebittOffset_Button = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaButton("index:=3","tagname:= Add Debit Offset")'
LIQ_OutgoingManualCashflow_FileSave_Menu = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_OutgoingManualCashflow_JavaTree = 'JavaWindow("title:=Outgoing Manual Cashflow .*","displayed:=1").JavaTree("attached text:=Difference Offset Total - Amount:")'
LIQ_OutgoingManualCashflow_Expense_Button = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaButton("attached text:=Expense")'
LIQ_OutgoingManualCashflow_Customer_Button = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaButton("attached text:=Customer")'
LIQ_OutgoingManualCashflow_Deal_Button = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaButton("attached text:=Deal")'
LIQ_OutgoingManualCashflow_Facility_Dropdown = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaList("attached text:=Facility:")'

###OutgoingManualCashflow-Workflow Tab###
LIQ_OutgoingManualCashflow_WorkflowItems = 'JavaWindow("title:=Outgoing Manual Cashflow .*").JavaTree("attached text:=Drill down to perform Workflow item")'