### Admin Fee Notebook - General Tab ###
LIQ_AdminFeeNotebook_Window = 'JavaWindow("title:=.*Admin Fee.*")'
LIQ_AdminFeeNotebook_JavaTab = 'JavaWindow("title:=.*Admin Fee.*").JavaTab("tagname:=TabFolder")'
LIQ_AdminFeeNotebook_InquiryMode_Button = 'JavaWindow("title:=.*Admin Fee.*").JavaButton("label:=.*Inquiry Mode.*")'
LIQ_AdminFeeNotebook_Amount_Textfield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("labeled_containers_path:=Tab:General;Group:Next period amount template;","index:=0")'
LIQ_AdminFeeNotebook_Amortize_Amount_Textfield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=Global.*","displayed:=1","editable:=1")'
LIQ_AdminFeeNotebook_Amortize_NextPeriodAmount_Textfield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("labeled_containers_path:=.*Next period amount template.*","editable:=1")'
LIQ_AdminFeeNotebook_Currency_Combobox = 'JavaWindow("title:=.*Admin Fee.*").JavaList("attached text:=Currency:")'
LIQ_AdminFeeNotebook_EffectiveDate_Datefield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=Effective Date.*")'
LIQ_AdminFeeNotebook_ExpiryDate_Datefield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=Expiry Date.*")'
LIQ_AdminFeeNotebook_PeriodFrequency_Combobox = 'JavaWindow("title:=.*Admin Fee.*").JavaList("attached text:=.*Frequency.*")'
LIQ_AdminFeeNotebook_ActualDueDate_Datefield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=Actual Due Date.*")'
LIQ_AdminFeeNotebook_BillingNumber_Textfield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=Billing Number of Days:")'
LIQ_AdminFeeNotebook_BillBorrower_CheckBox = 'JavaWindow("title:=.*Admin Fee.*").JavaCheckBox("attached text:=Bill Borrower")'
LIQ_AdminFee_AdjustedDueDate_Datefield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=Adjusted Due Date:")'
LIQ_AdminFee_EndDate_Datefield = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=.*End Date:")'
LIQ_AdminFeeNotebook_Options_AdminFeeChange = 'JavaWindow("title:=.*Admin Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Admin Fee Change Transaction")'
LIQ_AdminFee_File_Save = 'JavaWindow("title:=.*Admin Fee.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_AdminFee_File_Exit = 'JavaWindow("title:=.*Admin Fee.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_AdminFee_Options_Payment = 'JavaWindow("title:=.*Admin Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
LIQ_AdminFee_BillBorrower_Checkbox = 'JavaWindow("title:=.*Admin Fee.*").JavaCheckBox("attached text:=Bill Borrower")'
LIQ_AdminFee_FlatAmount_RadioButton = 'JavaWindow("title:=.*Admin Fee.*").JavaRadioButton("label:=Flat Amount")'
LIQ_AdminFee_FormulaRadioButton = 'JavaWindow("title:=.*Admin Fee.*").JavaRadioButton("label:=Formula")'
LIQ_AccruingAdminFee_EffectiveDate = 'JavaWindow("title:=.*Admin Fee.*").JavaEdit("index:=2")'
LIQ_AdminFee_NonBusinessDayRule_Combobox = 'JavaWindow("title:=.*Admin Fee.*").JavaList("attached text:=Non Business Day Rule:")'
LIQ_AdminFee_Accrue_Combobox = 'JavaWindow("title:=.*Admin Fee.*").JavaList("attached text:=Accrue:")'

### Admin Fee Notebook - Distribution Tab ###
LIQ_AdminFeeNotebook_Distribution_JavaTree = 'JavaWindow("title:=.*Admin Fee.*").JavaTree("tagname:=Drill down to assign primary.*")'
LIQ_AdminFeeNotebook_Distribution_Add_Button = 'JavaWindow("title:=.*Admin Fee.*").JavaButton("attached text:=Add")'

### Admin Fee Notebook - Workflow Tab ###
LIQ_AdminFeeNotebook_Workflow_JavaTree = 'JavaWindow("title:=.*Admin Fee.*").JavaTree("attached text:=Drill down to perform Workflow item")'

### Admin Fee Notebook - Periods Tab ###
LIQ_AdminFeeNotebook_Periods_JavaTree = 'JavaWindow("title:=.*Admin Fee.*").JavaTree("attached text:=Periods:")'

### Admin Fee Notebook - Fund Receiver Details###
LIQ_FundReceiverDetails_Window = 'JavaWindow("title:=.*Funds Receiver Details.*")'    
LIQ_FundReceiverDetails_ServicingGroup_Button = 'JavaWindow("title:=.*Funds Receiver Details.*").JavaButton("attached text:=Servicing Group.*")'    
LIQ_FundReceiverDetails_ServicingGroup_StaticText = 'JavaWindow("title:=.*Funds Receiver Details.*").JavaStaticText("x:=218","y:=56")'
LIQ_FundReceiverDetails_PercentageFees_Textfield = 'JavaWindow("title:=Funds Receiver Details").JavaEdit("attached text:=Percentage of Fee.*|","index:=1")'    
LIQ_FundReceiverDetails_OK_Button = 'JavaWindow("title:=Funds Receiver Details").JavaButton("attached text:=OK")'    
LIQ_FundReceiverDetails_ExpenseCode_Button = 'JavaWindow("title:=Funds Receiver Details").JavaButton("attached text:=Expense Code:")'    
LIQ_FundReceiverDetails_Branch_Combobox = 'JavaWindow("title:=Funds Receiver Details").JavaList("attached text:=Branch:")'
LIQ_FundReceiverDetails_ExpenseCode_Textfield = 'JavaWindow("title:=Funds Receiver Details").JavaEdit("x:=212","y:=150")'

### Admin Fee Payment Notebook ###
LIQ_AdminFeePayment_Window = 'JavaWindow("title:=.*Admin Fee Payment.*")'
LIQ_AdminFeePayment_Tab = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaTab("index:=0")'
LIQ_AdminFeePayment_Effective_Datefield = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaEdit("attached text:=Effective Date:")'
LIQ_AdminFeePayment_AmountDue_StaticText = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaObject("tagname:=Group","text:=.*Amounts.*").JavaEdit("index:=2")'
LIQ_AdminFeePayment_Requested_Textfield = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaObject("tagname:=Group","text:=.*Amounts.*").JavaEdit("index:=0")'
LIQ_AdminFeePayment_Currency_StaticText = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaObject("tagname:=Group","text:=.*Amounts.*").'
LIQ_AdminFeePayment_Comment_Textfield = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaEdit("attached text:=Comment:")'
LIQ_AdminFeePayment_Workflow_Tree = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_AdminFeePayment_File_Save = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_AdminFeePayment_File_Exit = 'JavaWindow("title:=.*Admin Fee Payment.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'


