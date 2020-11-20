 
### Accrual Shares Adjustment Window###

LIQ_AccrualSharesAdjustment_InquiryMode_Button = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'
LIQ_AccrualSharesAdjustment_UpdateMode_Button = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaButton("attached text:=Notebook in Update Mode - F7")'
LIQ_AccrualSharesAdjustment_Pending_Window = 'JavaWindow("title:=Accrual Shares Adjustment - Pending")'
LIQ_AccrualSharesAdjustment_RequestedAmount_Textfield = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("labeled_containers_path:=Tab:General;Group: Amounts ;","index:=0")'
LIQ_AccrualSharesAdjustment_EffectiveDate_Textfield = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("attached text:=Effective Date:")'
LIQ_AccrualSharesAdjustment_Comment_Textfield = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("attached text:=Comment:")'
LIQ_AccrualSharesAdjustment_Window_Tab = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaTab("tagname:=TabFolder")'
LIQ_AccrualSharesAdjustment_File_Save = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_AccrualSharesAdjustment_WorkflowAction = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_AccrualSharesAdjustment_Window = 'JavaWindow("title:=Accrual Shares Adjustment -.*")'

LIQ_AccrualSharesAdjustment_SendToApprovalWarningMessage_StaticText = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=68")'

LIQ_AccrualSharesAdjustment_File_Exit = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_AccrualSharesAdjustment_Approval_QuestionMessage_StaticText = 'JavaWindow("title:=Question.*","displayed:=1").JavaEdit("attached text:=QUESTION")'
LIQ_AccrualSharesAdjustment_Approval_WarningMessage_StaticText = 'JavaWindow("title:=Warning.*","displayed:=1").JavaEdit("attached text:=WARNING", "height:=68")'

LIQ_AccrualSharesAdjustment_Released_Status_Window = 'JavaWindow("title:=Accrual Shares Adjustment - Released")'
LIQ_AccrualSharesAdjustment_WorkflowAction_Release_Null = 'JavaWindow("title:=Accrual Shares Adjustment -.*").JavaTree("attached text:=Drill down to perform Workflow item", "items count:=0")'
##WIP Window###
LIQ_WIP_Facilities_List = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaTree("labeled_containers_path:=Group:Details;Tab:Facilities;")'
LIQ_Outstanding_AccrualShared_Button = 'JavaWindow("title:=.* Loan.*.*Active.*").JavaTab("tagname:=TabFolder").JavaButton("attached text:=Cycle Shares Adjustment")'
LIQ_Outstanding_Accrual_JavaTree = 'JavaWindow("title:=.* Loan.*.*Active.*").JavaTab("text:=Accrual").JavaTree("labeled_containers_path:=Tab:Accrual;")'