###Commitment Fee Notebook - General Tab### 
LIQ_CommitmentFeeNotebook_Window = 'JavaWindow("title:=Commitment Fee Fee / Released:.*")'   
LIQ_CommitmentFee_General_OptionsPayment_Menu = 'JavaWindow("title:=Commitment Fee.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
LIQ_CommitmentFee_Tab = 'JavaWindow("title:=Commitment Fee.*").JavaTab("tagname:=TabFolder")' 
LIQ_ChoosePayment_Window = 'JavaWindow("title:=Choose a Payment.*")'
LIQ_ChoosePayment_Prinicpal_RadioButton = 'JavaWindow("title:=Choose a Payment.*").JavaRadioButton("label:=Principal Payment")'
LIQ_ChoosePayment_Fee_RadioButton = 'JavaWindow("title:=Choose a Payment.*").JavaRadioButton("label:=Fee Payment")'
LIQ_ChoosePayment_Paperclip_RadioButton = 'JavaWindow("title:=Choose a Payment.*").JavaRadioButton("label:=Paper Clip Payment")'
LIQ_ChoosePayment_OK_Button = 'JavaWindow("title:=Choose a Payment.*").JavaButton("label:=OK")' 
LIQ_ChoosePayment_Cancel_Button = 'JavaWindow("title:=Choose a Payment.*").JavaButton("label:=Cancel")' 

LIQ_CommitmentFeeNotebook_Pending_Window = 'JavaWindow("title:=Commitment Fee Fee / Pending:.*")'

###Commitment Fee Notebook - Cycle###  
LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton = 'JavaWindow("title:=Cycles for.*").JavaRadioButton("label:=Projected Due")'
LIQ_CommitmentFee_Cycles_OK_Button = 'JavaWindow("title:=Cycles for.*").JavaButton("label:=OK")'
LIQ_CommitmentFee_Cyces_Javatree = 'JavaWindow("title:=Cycles for .*").JavaTree("attached text:=Choose a cycle to make a payment against")'

LIQ_CommitmentFee_Cycles_CycleDue_RadioButton = 'JavaWindow("title:=Cycles for.*").JavaRadioButton("label:=Cycle Due")'

###Commitment Fee - Ongoing Fee Payment - General###  
LIQ_OngoingFeePayment_Window = 'JavaWindow("title:=.*Fee.*Ongoing Fee Payment.*","displayed:=1")'
LIQ_OngoingFeePayment_RequestedAmount_Textfield = 'JavaWindow("title:=.* Payment .*").JavaEdit("labeled_containers_path:=Tab:General;Group: Amounts ;", "index:=0")'
LIQ_OngoingFeePayment_EffectiveDate_Field = 'JavaWindow("title:=.*Fee.*Ongoing Fee Payment.*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_OngoingFeePayment_EffectiveDate_DateField = 'JavaWindow("title:=.* Payment .*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_OngoingFeePayment_EffectiveDate_DateField = 'JavaWindow("title:=.* Payment .*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_OngoingFeePayment_UpdateMode_Button = 'JavaWindow("title:=.* Payment .*").JavaButton("attached text:=Notebook in Update Mode - F7")'
LIQ_OngoingFeePayment_InquiryMode_Button = 'JavaWindow("title:=.* Payment .*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'
LIQ_OngoingFeePayment_ViewUpdateLenderShares_Menu = 'JavaWindow("title:=.* Payment .*").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'
LIQ_OngoingFeePayment_AwaitingReleaseWindow = 'JavaWindow("title:=.*Ongoing Fee Payment.*.*Awaiting Release.*","displayed:=1")'

LIQ_OngoingFeePayment_Tab = 'JavaWindow("title:=.*Fee.*Ongoing Fee Payment.*","displayed:=1").JavaTab("tagname:=TabFolder")'  
LIQ_OngoingFeePayment_WorkflowItems = 'JavaWindow("title:=.*Fee.*Ongoing Fee Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_Payment_WorkflowItem_Null = 'JavaWindow("title:=.* Payment.*").JavaTree("attached text:=Drill down to perform Workflow item", "items count:=0")'
LIQ_Fee_Window = 'JavaWindow("title:=.*Fee.*")'

###Commitment Fee - Ongoing Fee Payment - Cashflow### 
LIQ_PaymentNotebook_Tab = 'JavaWindow("title:=.*Payment.*").JavaTab("tagname:=TabFolder")' 
LIQ_PaymentNotebook_Workflow_Tree = 'JavaWindow("title:=.*Payment.*").JavaTree("attached text:=Drill down to perform Workflow item")' 
LIQ_PaymentNotebook_CashFlow_Window = 'JavaWindow("title:=Cashflows For.*Payment.*")' 
LIQ_PaymentNotebook_CashFlow_DrillDowntoView_CashflowList = 'JavaWindow("title:=Cashflows For.*Payment.*").JavaTree("attached text:=Drill down to view/change details")'
LIQ_PaymentNotebook_Cashflow_OK_Button = 'JavaWindow("title:=Cashflows For.*Payment.*").JavaButton("attached text:=OK")'
LIQ_PaymentNotebook_Cashflow_SettoDoIt_Button = 'JavaWindow("title:=Cashflows For.*Payment.*.*").JavaButton("attached text:=Set Selected Item To.*Do It.*")'
LIQ_PaymentNotebook_Cashflow_RemittanceDesc_DDA_StaticText = 'JavaWindow("title:=Cashflows For.*Payment.*").JavaStaticText("attached text:=.*DDA.*")'
LIQ_PaymentNotebook_Cashflow_RemittanceDesc_IMT_StaticText = 'JavaWindow("title:=Cashflows For.*Payment.*").JavaStaticText("attached text:=.*IMT.*")'
LIQ_PaymentNotebook_Cashflow_RemittanceDesc_None_StaticText = 'JavaWindow("title:=Cashflows For.*Payment.*").JavaStaticText("attached text:=None")'
LIQ_PaymentNotebook_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
LIQ_PaymentNotebook_ChooseRemittance_List = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
LIQ_PaymentNotebook_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
LIQ_PaymentNotebook_Cashflow_SettoDoIt_Undo_Button = 'JavaWindow("title:=Cashflows For.*Payment.*").JavaButton("label:=.*Undo It.*")' 
LIQ_OngoingFee_InquiryMode_Button = 'JavaWindow("title:=.*Fee /.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'
LIQ_OngoingFee_Window = 'JavaWindow("title:=.*Fee /.*")'
LIQ_OngoingFee_Tab = 'JavaWindow("title:=.*Fee /.*").JavaTab("tagname:=TabFolder")' 
LIQ_OngoingFee_Accrual_JavaTree = 'JavaWindow("title:=.*Fee /.*").JavaTree("labeled_containers_path:=Tab:Accrual;","attached text:=Cycles:")'
LIQ_OngoingFee_CycleShareOverview_Button = 'JavaWindow("title:=.*Fee /.*").JavaButton("attached text:=Cycle Shares Adjustment")'

###Commitment Fee - Ongoing Fee Payment - Workflow###  
LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree = 'JavaWindow("title:=.*Fee.*Ongoing Fee Payment.*","displayed:=1").JavaTree("tagname:=Drill down to perform.*")' 
LIQ_OngoingFeePaymentNotebook_Window = 'JavaWindow("title:=.*Fee Ongoing Fee Payment.*")'

###Fee List### 
LIQ_Facility_FeeList = 'JavaWindow("label:=Fee List for.*")' 
LIQ_FeeList_JavaTree = 'JavaWindow("title:=Fee List for.*").JavaTree("tagname:=Drill down to view details","index:=0")'

###Commitment Fee - Accrual###   
LIQ_CommitmentFee_Acrual_JavaTree = 'JavaWindow("title:=Commitment Fee.*").JavaTree("tagname:=Cycles:")'
LIQ_CommitmentFee_Window = 'JavaWindow("title:=Commitment Fee.*")'
LIQ_CommitmentFeeNotebook_CycleShareAdjustment_Button = 'JavaWindow("title:=Commitment Fee Fee / Released:.*").JavaButton("attached text:=Cycle Shares Adjustment")'
LIQ_CommitmentFeeNotebook_Accrual_JavaTree = 'JavaWindow("title:=Commitment Fee Fee / Released:.*").JavaTree("labeled_containers_path:=Tab:Accrual;","attached text:=Cycles:")'

###Commitment Fee - Workflow###   
LIQ_CommitmentFeeNotebook_Workflow_JavaTree = 'JavaWindow("title:=Commitment Fee.*").JavaTree("tagname:=Drill down to perform.*","index:=0")'
LIQ_CommitmentFee_InquiryMode_Button = 'JavaWindow("title:=Commitment Fee.*").JavaButton("attached text:=Notebook in Inquiry Mode.*")'

###Commitment Fee - General###   
LIQ_CommitmentFee_InquiryMode_Button = 'JavaWindow("title:=Commitment Fee.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'
LIQ_CommitmentFee_EffectiveDate_Field = 'JavaWindow("title:=Commitment Fee.*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_CommitmentFee_AccrualEndDate_Field = 'JavaWindow("title:=Commitment Fee.*").JavaEdit("attached text:=Accrual End Date:.*")'
LIQ_CommitmentFee_RequestedDate_Field = 'JavaWindow("title:=Commitment Fee Ongoing Fee Payment.*").JavaEdit("tagname:=Text","x:=231","y:=117")'
LIQ_CommitmentFee_FloatRateStartDate_Field = 'JavaWindow("title:=Commitment Fee.*").JavaEdit("attached text:=Float Rate Start Date:.*")'
LIQ_CommitmentFee_Cycle_List = 'JavaWindow("title:=Commitment Fee.*").JavaList("attached text:=Cycle.*")'
LIQ_CommitmentFee_BalanceAmount_Field = 'JavaWindow("title:=Commitment Fee.*").JavaEdit("attached text:=Balance Amount:")'
LIQ_CommitmentFee_CurrentRate_Field = 'JavaWindow("title:=Commitment Fee.*").JavaEdit("attached text:=Current Rate:")'
LIQ_CommitmentFee_RateBasis_Field = 'JavaWindow("title:=Commitment Fee.*").JavaStaticText("labeled_containers_path:=Tab:General;","index:=9")'
LIQ_CommitmentFee_RateBasis_Text = 'JavaWindow("title:=Commitment Fee.*").JavaStaticText("attached text:=Actual/.*")'
LIQ_CommitmentFee_OnlineAcrual_Menu = 'JavaWindow("title:=Commitment Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Perform Online Accrual")'
LIQ_CommitmentFee_ViewUpdateLenderShares_Menu = 'JavaWindow("title:=Commitment Fee.*").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares)'
LIQ_CommitmentFee_Payment_Menu = 'JavaWindow("title:=Commitment Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
LIQ_CommitmentFee_Capitalization_Menu = 'JavaWindow("title:=Commitment Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Capitalization")'
LIQ_CommitmentFee_Save_Menu = 'JavaWindow("title:=Commitment Fee.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_CommitmentFee_Exit_Menu = 'JavaWindow("title:=Commitment Fee.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_CommitmentFee_AdjustedDueDate = 'JavaWindow("title:=Commitment Fee.*").JavaEdit("attached text:=Adjusted Due Date:.*")'
LIQ_CommitmentFee_CapitalizationEditor_Window = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor")'
LIQ_CommitmentFee_CapitalizationEditor_ActivateFeeCap_CheckBox = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaCheckBox("attached text:=Activate Fee Capitalization", "index:=0")'
LIQ_CommitmentFee_CapitalizationEditor_FromDate_Textfield = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaEdit("attached text:=From Date")'
LIQ_CommitmentFee_CapitalizationEditor_ToDate_Textfield = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaEdit("attached text:=To Date", "index:=0")'
LIQ_CommitmentFee_CapitalizationEditor_PctofPayment_RadioButton = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaRadioButton("attached text:=Percent of Payment")'
LIQ_CommitmentFee_CapitalizationEditor_PctofPayment_Textfield = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaEdit("attached text:=To Date", "index:=2")'
LIQ_CommitmentFee_CapitalizationEditor_ToFacility_DropdownList = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaList("attached text:=To Facility")'
LIQ_CommitmentFee_CapitalizationEditor_ToLoan_DropdownList = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaList("attached text:=Currency :")'
LIQ_CommitmentFee_CapitalizationEditor_OK_Button = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaButton("attached text:=OK")'
LIQ_CommitmentFee_Currency_Text = 'JavaWindow("title:=Commitment Fee.*").JavaStaticText("labeled_containers_path:=Tab:General;", "x:=185", "y:=168")'
LIQ_CommitmentFee_ActualExpiryDate_Text = 'JavaWindow("title:=Commitment Fee.*").JavaStaticText("labeled_containers_path:=Tab:General;", "x:=567", "y:=152")'

###Commitment Fee - Lender Shares###
LIQ_CommitmentFee_LenderShares_Window = 'JavaWindow("title:=Shares for.*")'
LIQ_CommitmentFee_LenderShares_Javatree = 'JavaWindow("title:=Shares for.*").JavaTree("attached text:=Drill Down for Primary/Assignment Detail")'
LIQ_CommitmentFee_LenderShares_OK_Button = 'JavaWindow("title:=Shares for.*").JavaButton("attached text:=OK")'

###Commitment Fee - Events###   
LIQ_CommitmentFee_Events_Javatree = 'JavaWindow("title:=Commitment Fee.*").JavaTree("tagname:=Select event to view details")'   

###Commitment Fee - GL Entries###
LIQ_CommitmentFee_Queries_GLEntries = 'JavaWindow("title:=Commitment Fee Ongoing Fee Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_LineFee_Queries_GLEntries = 'JavaWindow("title:=Line Fee Ongoing Fee Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_OngoingFeePayment_GLEntries_Window = 'JavaWindow("title:=GL Entries For Ongoing Fee Payment")'
LIQ_OngoingFeePayment_GLEntries_Table = 'JavaWindow("title:=GL Entries For Ongoing Fee Payment").JavaTree("attached text:=Drill down to view details")'
LIQ_OngoingFeePayment_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries For Ongoing Fee Payment").JavaButton("attached text:=Exit")'   
LIQ_GLEntries_Window = 'JavaWindow("title:=GL Entries For.*")'

###Ongoing Fee List###
LIQ_Facility_FeeList_JavaTree = 'JavaWindow("label:=Fee List for.*").JavaTree("attached text:=Drill down to view details")'

###Reverse Payment###
LIQ_ReverseFee_Window = 'JavaWindow("title:=.*Fee Reverse Fee.*")'
LIQ_CommitmentFee_ReversePayment = 'JavaWindow("title:=Commitment Fee Ongoing Fee Payment.*").JavaMenu("label:=Options").JavaMenu("label:=Reverse Payment")'
LIQ_ReversePayment_Comment_Textfield = 'JavaWindow("title:=.*Fee Reverse Fee.*").JavaEdit("attached text:=Comment:")'
LIQ_ReversePayment_UpdateMode_Button = 'JavaWindow("title:=.*Fee Reverse Fee.*").JavaButton("attached text:=Notebook in Update Mode - F7")'
LIQ_ReversePayment_Tab = 'JavaWindow("title:=.*Fee Reverse Fee.*").JavaTab("tagname:=TabFolder")'
LIQ_ReversePayment_EffectiveDate = 'JavaWindow("title:=Commitment Fee Reverse Fee.*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_ReversePayment_Queries_GLEntries = 'JavaWindow("title:=.*Fee Reverse Fee.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_ReversePayment_Amount = 'JavaWindow("title:=.*Fee Reverse.*").JavaEdit("labeled_containers_path:=.*Amounts.*", "index:=0")'
LIQ_ReversePayment_Options_Cashflow = 'JavaWindow("title:=.*Fee Reverse Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'

###GL Entries#####
LIQ_GLEntries_Javatree = 'JavaWindow("title:=GL Entries.*").JavaTree("attached text:=Drill down to view details")'


###Notices####
LIQ_IntentNotice_Window = 'JavaWindow("title:=.* Notice Group.*")'