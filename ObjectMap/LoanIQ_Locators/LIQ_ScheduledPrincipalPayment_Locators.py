###Scheduled Principal Payment Notebook - General Tab###    
LIQ_ScheduledPrincipalPayment_Window = 'JavaWindow("title:=.*Scheduled Principal Payment.*")'
LIQ_ScheduledPrincipalPayment_OutstandingAmount_Field = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaEdit("attached text:=Outstanding:")'
LIQ_ScheduledPrincipalPayment_RequestedAmount_Field = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaEdit("attached text:=Requested:")'
LIQ_ScheduledPrincipalPayment_ActualAmount_Field = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaEdit("attached text:=Actual:")'
LIQ_ScheduledPrincipalPayment_EffectiveDate_Field = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaEdit("attached text:=Effective Date:")'
LIQ_ScheduledPrincipalPayment_PaperClip_Menu = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaMenu("label:=Options").JavaMenu("label:=Paper Clip Notebook")' 
LIQ_ScheduledPrincipalPayment_Tab = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaTab("tagname:=TabFolder")'  
LIQ_ScheduledPrincipalPayment_Queries_GLEntries = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_ScheduledPrincipalPayment_Save_Menu = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaMenu("label:=File").JavaMenu("label:=Save")'

###Scheduled Principal Payment Notebook - Workflow###  
LIQ_ScheduledPrincipalPayment_Workflow_JavaTree = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaTree("tagname:=Drill down to perform.*","index:=0")'
LIQ_ScheduledPrincipalPayment_RapaymentHistory_JavaTree = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Repayment History:.*")' 
LIQ_ScheduledPrincipalPayment_Exit_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Exit")'


###Scheduled Principal Payment Notebook - Events### 
LIQ_ScheduledPrincipalPayment_Events_JavaTree = 'JavaWindow("title:=.*Scheduled Principal Payment.*").JavaTree("tagname:=Select event to view details.*","index:=0")'