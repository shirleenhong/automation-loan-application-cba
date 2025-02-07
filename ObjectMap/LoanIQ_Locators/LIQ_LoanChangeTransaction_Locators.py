####Loan Change Transaction Notebook  - General Tab####
LIQ_LoanChangeTransaction_Window = 'JavaWindow("title:=.*Loan Change Transaction")'
LIQ_LoanChangeTransaction_Tab = 'JavaWindow("title:=.*Loan Change Transaction").JavaTab("tagname:=TabFolder")'
LIQ_LoanChangeTransaction_Worflow_Javatree = 'JavaWindow("title:=.*Loan Change Transaction").JavaTab("text:=Workflow").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_LoanChangeTransaction_Add_Button = 'JavaWindow("title:=.*Loan Change Transaction").JavaButton("attached text:=Add...")'
LIQ_LoanChangeTransaction_Tree = 'JavaWindow("title:=.*Loan Change Transaction").JavaTree("attached text:=Drill down to edit the new value on a change item")'
LIQ_SelectChangeField_Window = 'JavaWindow("title:=Select a Change Field")'
LIQ_SelectChangeField_Tree = 'JavaWindow("title:=Select a Change Field").JavaTree("attached text:=Drill down to select")'
LIQ_SelectChangeField_OK_Button = 'JavaWindow("title:=Select a Change Field").JavaButton("attached text:=OK")'
LIQ_RiskTypeSelector_Window = 'JavaWindow("title:=Risk Type Selector")'
LIQ_RiskTypeSelector_Tree = 'JavaWindow("title:=Risk Type Selector").JavaTree("attached text:=Code:")'
LIQ_RiskTypeSelector_Description_RadioButton = 'JavaWindow("title:=Risk Type Selector").JavaRadioButton("attached text:=Description")'
LIQ_RiskTypeSelector_Description_Textfield = 'JavaWindow("title:=Risk Type Selector").JavaEdit("tagname:=Text")'
LIQ_RiskTypeSelector_OK_Button = 'JavaWindow("title:=Risk Type Selector").JavaButton("attached text:=OK")'
LIQ_EnterSpread_Window = 'JavaWindow("title:=Enter Spread")'
LIQ_EnterSpread_Spread_Textfield = 'JavaWindow("title:=Enter Spread").JavaEdit("tagname:=Text")'
LIQ_EnterSpread_OK_Button = 'JavaWindow("title:=Enter Spread").JavaButton("attached text:=OK")'
LIQ_EnterPaymentMode_Window = 'JavaWindow("title:=Enter Payment Mode")'
LIQ_EnterPaymentMode_PaymentMode_Dropdownlist = 'JavaWindow("title:=Enter Payment Mode").JavaList("tagname:=Combo")'
LIQ_EnterPaymentMode_OK_Button = 'JavaWindow("title:=Enter Payment Mode").JavaButton("attached text:=OK")'
LIQ_EnterMaturityDate_Window = 'JavaWindow("title:=Enter Maturity Date")'
LIQ_EnterMaturityDate_MaturityDate_Datefield = 'JavaWindow("title:=Enter Maturity Date").JavaEdit("tagname:=Text")'
LIQ_EnterMaturityDate_OK_Button = 'JavaWindow("title:=Enter Maturity Date").JavaButton("attached text:=OK")'
LIQ_EnterMaturityDate_Cancel_Button = 'JavaWindow("title:=Enter Maturity Date").JavaButton("attached text:=Cancel")'

####Fixed rate option loan window###
LIQ_FixedRateOptionLoan_Window = 'JavaWindow("title:=Fixed Rate Option Loan.*")'
LIQ_FixedRateOptionLoan_Pending_Tab = 'JavaWindow("title:=Fixed Rate Option Loan.*").JavaTab("tagname:=TabFolder")'
LIQ_FixedRateOptionLoan_ListItem = 'JavaWindow("title:=Fixed Rate Option Loan.*").JavaTree("attached text:=Pending Transactions")'
LIQ_FixedRateOptionLoan_ContractID = 'JavaWindow("title:=Fixed Rate Option Loan.*").JavaEdit("attached text:=Contract ID:")'
LIQ_FixedRateOptionLoan_Events_JavaTree = 'JavaWindow("title:=.*Fixed Rate Option Loan.*").JavaTree("tagname:=Select event to view details.*","index:=0")'
LIQ_LoanChangeTransaction_EffectiveDate = 'JavaWindow("title:=.*Loan Change Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_LoanChangeTransaction_NewValue_JavaTree = 'JavaWindow("title:=.*Loan Change Transaction").JavaTree("attached text:=Drill down to edit the new value on a change item")'

###Enter ContractID###
LIQ_ContractID_Window = 'JavaWindow("title:=Enter Contract ID")'
LIQ_NewContractID = 'JavaWindow("title:=Enter Contract ID").JavaEdit("tagname:=Text")'
LIQ_ContractID_Ok_Button = 'JavaWindow("title:=Enter Contract ID").JavaButton("attached text:=OK")'