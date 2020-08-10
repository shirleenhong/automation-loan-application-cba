####Unscheduled Principal Payment#####
LIQ_UnscheduledPrincipalPayment_Window = 'JavaWindow("title:=.*Unscheduled Principal Payment.*")'
LIQ_UnscheduledPrincipalPayment_Actual_Field = 'JavaWindow("title:=.*Unscheduled Principal Payment.*").JavaEdit("attached text:=Actual:")'
LIQ_UnscheduledPrincipalPayment_Window_Released = 'JavaWindow("title:=.*Unscheduled Principal Payment.* Released.*")'
LIQ_UnscheduledPrincipalPayment_Breakfunding_OK_Button = 'JavaWindow("label:=Breakfunding reason.*").JavaButton("attached text:=OK.*")'
LIQ_UnscheduledPrincipalPayment_Breakfunding_Window =  'JavaWindow("label:=Breakfunding reason.*")'
LIQ_UnscheduledPrincipalPayment_Breakfunding_ComboBox = 'JavaWindow("label:=Breakfunding reason.*").JavaList("attached text:=Select reason for breakfunding:.*")'

#####Unscheduled Payment Cashflows#######
LIQ_Unscheduled_Cashflows_HostBankCash_Workflow = 'JavaWindow("title:=Cashflows .*").JavaStaticText("to_class:=JavaStaticText","index:=28")'