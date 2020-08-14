####Payment Notices####

LIQ_Notice_PaymentIntentNotice_Window = 'JavaWindow("title:=.* Payment Notice Group.*")'
LIQ_Notice_PaymentIntentNotice_Exit_Button = 'JavaWindow("title:=.* Payment Notice Group.*").JavaButton("attached text:=Exit")' 
LIQ_Notice_PaymentIntentNotice_Information_Table = 'JavaWindow("title:=.* Payment Notice Group.*", "displayed:=1").JavaTree("attached text:=Drill down to mark notices")'
LIQ_Notice_PaymentIntentNotice_Send_Button = 'JavaWindow("title:=.* Payment Notice Group.*").JavaButton("attached text:=Send")'
LIQ_Notice_PaymentIntentNotice_EditHighlightedNotice_Button = 'JavaWindow("title:=.* Payment Notice Group.*").JavaButton("attached text:=Edit Highlighted Notices")'
LIQ_Notice_PaymentIntentNotice_Edit_Window = 'JavaWindow("title:=.* Payment Notice created.*")'
LIQ_Notice_PaymentIntentNotice_Edit_Email = 'JavaWindow("title:=.* Payment Notice created.*").JavaEdit("attached text:=E-mail:")'

#####NOTICES######
LIQ_IntentNotice_Window = 'JavaWindow("title:=.* Notice Group.*", "displayed:=1")'
LIQ_IntentNotice_Exit_Button = 'JavaWindow("title:=.* Notice Group.*", "displayed:=1").JavaButton("attached text:=Exit")' 
LIQ_IntentNotice_Information_Table = 'JavaWindow("title:=.* Notice Group.*", "displayed:=1").JavaTree("attached text:=Drill down to mark notices")'
LIQ_IntentNotice_Send_Button = 'JavaWindow("title:=.* Notice Group.*", "displayed:=1").JavaButton("attached text:=Send")'
LIQ_IntentNotice_EditHighlightedNotice_Button = 'JavaWindow("title:=.* Notice Group.*", "displayed:=1").JavaButton("attached text:=Edit Highlighted Notices")'
LIQ_IntentNotice_Edit_Window = 'JavaWindow("title:=.* Notice created.*")'
LIQ_IntentNotice_Edit_Email = 'JavaWindow("title:=.* Notice created.*").JavaEdit("attached text:=E-mail:")' 

LIQ_Notice_Exit_Button = 'JavaWindow("title:=.* Notice.*", "displayed:=1").JavaButton("attached text:=Exit")'
LIQ_Notice_Information_Table = 'JavaWindow("title:=.* Notice.*").JavaTree("attached text:=Drill down to mark notices")'
LIQ_Notice_Send_Button = 'JavaWindow("title:=.* Notice.*").JavaButton("attached text:=Send")'
LIQ_Notice_EditHighlightedNotice_Button = 'JavaWindow("title:=.* Notice Group.*").JavaButton("attached text:=.*Highlighted Notices")'
LIQ_Notice_IntentNotice_Window = 'JavaWindow("title:=.* Payment Notice created.*")'
LIQ_Notice_IntentNotice_Email = 'JavaWindow("title:=.* Payment Notice created.*").JavaEdit("attached text:=E-mail:")'

####Payment Window######
LIQ_Payment_Window = 'JavaWindow("title:=.* .* Payment .*")'
LIQ_Payment_Options_Cashflow = 'JavaWindow("title:=.* .* Payment .*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_Payment_Options_PaperClipNotebook = 'JavaWindow("title:=.* .* Payment .*").JavaMenu("label:=Options").JavaMenu("label:=Paper Clip Notebook")'
LIQ_Payment_Queries_GLEntries = 'JavaWindow("title:=.* .* Payment .*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Payment_EffectiveDate_Textfield = 'JavaWindow("title:=.* .* Payment .*").JavaEdit("attached text:=Effective Date:")'
LIQ_Payment_File_Save = 'JavaWindow("title:=.* .* Payment .*").JavaMenu("label:=File").JavaMenu("label:=Save")'    
LIQ_Payment_CashflowFromBorrower_RadioButton ='JavaWindow("title:=.* .* Payment .*").JavaRadioButton("attached text:=From Borrower")'
LIQ_Payment_CashflowFromAgent_RadioButton ='JavaWindow("title:=.* Payment.*").JavaRadioButton("attached text:=From Agent")'
LIQ_Payment_AwaitingApproval_Status_Window = 'JavaWindow("title:=.*Payment .*Awaiting Approval.*")'
LIQ_Payment_Released_Status_Window = 'JavaWindow("title:=.*Payment .*Released.*")'
LIQ_Payment_WorkflowItems_Release_Null = 'JavaWindow("title:=.* .* Payment .*").JavaTree("attached text:=.*Workflow .*", "items count:=0")'
#LIQ_Payment_RequestedAmount_Textfield = 'JavaWindow("title:=.* .* Payment .*").JavaEdit("tagname:=Text", "x:=231", "y:=114")'
LIQ_Payment_PrincipalRequestedAmt_Textfield = 'JavaWindow("title:=.* .* Payment .*").JavaEdit("attached text:=Requested:")'
LIQ_Payment_ProjectedCycleDue_Amount = 'JavaWindow("title:=.* .* Payment .*").JavaEdit("tagname:=Text", "x:=231", "y:=84")'
LIQ_Payment_Tab = 'JavaWindow("title:=.* .* Payment .*").JavaTab("tagname:=TabFolder")'
LIQ_Payment_WorkflowItems = 'JavaWindow("title:=.* .* Payment .*").JavaTree("attached text:=.*Workflow .*")'
LIQ_Payment_Events_JavaTree = 'JavaWindow("title:=.* Payment .*").JavaTree("attached text:=Select event to view details")'

###Interest Payment Notebook -- FROM CARLO###
LIQ_InterestPayment_Window = 'JavaWindow("title:=.* Interest Payment.*")'
LIQ_InterestPayment_EffectiveDate_Textfield = 'JavaWindow("title:=.* Interest Payment.*").JavaEdit("attached text:=Effective Date:")'
LIQ_InterestPayment_FileSave_Menu = 'JavaWindow("title:=.* Interest Payment.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_InterestPayment_CurrentCycDue_Text = 'JavaWindow("title:=.* Interest Payment.*").JavaEdit("x:=231","y:=51")'
LIQ_InterestPayment_RequestedAmount_Textfield = 'JavaWindow("title:=.* Interest Payment.*").JavaEdit("labeled_containers_path:=.*Amounts.*","Index:=0")'
LIQ_InterestPayment_CycleDueDate_Text = 'JavaWindow("title:=.* Interest Payment.*").JavaStaticText("labeled_containers_path:=.*Cycle.*","Index:=5")'

###GL Entries####
LIQ_Payment_GLEntries_Table = 'JavaWindow("title:=GL Entries.*").JavaTree("attached text:=Drill down to view details")'
LIQ_Payment_GLEntries_Window = 'JavaWindow("title:=GL Entries.*")'

###Scheduled Activity Report Form###
LIQ_ScheduledActivityFilter_DateThru_Textfield = 'JavaWindow("title:=Scheduled Activity Filter").JavaEdit("attached text:=Thru:")'
LIQ_ScheduledActivityFilter_Deal_Button = 'JavaWindow("title:=Scheduled Activity Filter").JavaButton("attached text:=Deal:")'
LIQ_ScheduledActivityFilter_Ok_Button = 'JavaWindow("title:=Scheduled Activity Filter").JavaButton("attached text:=OK")'
LIQ_ScheduledActivityReport_Tree = 'JavaWindow("title:=.*Scheduled Activity Report.*","displayed:=1").JavaTree("tagname:=Tree")'
LIQ_ScheduledActivityReport_Form = 'JavaWindow("title:=.*Scheduled Activity Report.*","index:=1").JavaList("attached text:=View By.*")'
LIQ_ScheduledActivityReport_ViewBy_Dropdown = 'JavaWindow("title:=Scheduled Activity Report.*").JavaList("attached text:=View By:")'
LIQ_ScheduledActivityReport_CollapseAll_Button = 'JavaWindow("title:=Scheduled Activity Report.*").JavaButton("attached text:=Collapse All")'