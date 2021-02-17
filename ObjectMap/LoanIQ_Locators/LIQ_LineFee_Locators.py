###Line Fee Notebook - General Tab### 
LIQ_LineFeeNotebook_Window = 'JavaWindow("title:=Line Fee.*")'
LIQ_LineFee_InquiryMode_Button = 'JavaWindow("title:=Line Fee.*").JavaButton("attached text:=Notebook in Inquiry Mode.*")'
LIQ_LineFee_Capitalization_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Capitalization")'
LIQ_LineFee_Save_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_LineFee_Exit_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_LineFee_Update_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Update")'
LIQ_LineFee_ChangeExpiryDate_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Change Expiry Date")'
LIQ_LineFee_ExpiryDate = 'JavaWindow("title:=Fee Expiry Date.*").JavaEdit("attached text:=Expiry Date.*")'
LIQ_LineFee_ExpiryDate_OK_Button = 'JavaWindow("title:=Fee Expiry Date.*").JavaButton("attached text:=OK")'
# LIQ_LineFee_CurrentRate_Field = 'JavaWindow("title:=Line Fee .*Released:.*").JavaEdit("attached text:=Current Rate:")'
LIQ_LineFee_CurrentRate_Field = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Current Rate:")'
LIQ_LineFee_BalanceAmount_Field = 'JavaWindow("title:=Line Fee .*Released:.*").JavaEdit("attached text:=Balance Amount:")'
LIQ_LineFee_RateBasis_Field = 'JavaWindow("title:=Line Fee.*","displayed:=1").JavaStaticText("labeled_containers_path:=Tab:General;","index:=9")'
LIQ_LineFee_Update_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Update")'
LIQ_LineFee_Effective_Date = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Effective Date:")'
LIQ_LineFee_FloatRate_Date = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Float Rate Start Date:")'
LIQ_LineFee_ActualDue_Date = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Actual Due Date:")'
LIQ_LineFee_AdjustedDue_Date = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Adjusted Due Date:")'
LIQ_LineFee_AccrualEnd_Date = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Accrual End Date:")'
LIQ_LineFee_Cycle = 'JavaWindow("title:=Line Fee.*").JavaList("attached text:=Cycle Frequency:")' 
LIQ_LineFee_Accrue_Dropdown = 'JavaWindow("title:=Line Fee.*").JavaList("attached text:=Accrue.*")' 
LIQ_LineFee_PayType_Dropdown = 'JavaWindow("title:=Line Fee.*").JavaList("attached text:=Actual/365.*")' 
LIQ_LineFeeReleasedNotebook_Window = 'JavaWindow("title:=Line Fee.* / Released:.*")'
LIQ_LineFee_Currency_Text = 'JavaWindow("title:=Line Fee.*").JavaStaticText("labeled_containers_path:=Tab:General;", "Index:=16")'
LIQ_LineFee_ActualExpiryDate_Text = 'JavaWindow("title:=Line Fee.*").JavaStaticText("labeled_containers_path:=Tab:General;", "Index:=1")'
LIQ_LineFee_CycleStartDate_Text = 'JavaWindow("title:=Line Fee.*").JavaStaticText("labeled_containers_path:=Tab:General;", "Index:=2")'
LIQ_Fee_Tab = 'JavaWindow("title:=.* Fee.*").JavaTab("tagname:=TabFolder")' 
LIQ_Fee_Window = 'JavaWindow("title:=.* Fee.*")'
LIQ_LineFee_PricingFormulaInEffect_TextField = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Pricing Formula In Effect:")'

###Line Fee Notebook - Facility Ongoing Fee Capitalization Editor### 
LIQ_LineFee_CapitalizationEditor_Window = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor")'
LIQ_LineFee_CapitalizationEditor_ActivateFeeCap_CheckBox = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaCheckBox("attached text:=Activate Fee Capitalization", "index:=0")'
LIQ_LineFee_CapitalizationEditor_FromDate_Textfield = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaEdit("attached text:=From Date")'
LIQ_LineFee_CapitalizationEditor_ToDate_Textfield = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaEdit("attached text:=To Date", "index:=0")'
LIQ_LineFee_CapitalizationEditor_PctofPayment_RadioButton = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaRadioButton("attached text:=Percent of Payment")'
LIQ_LineFee_CapitalizationEditor_PctofPayment_Textfield = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaEdit("attached text:=To Date", "index:=2")'
LIQ_LineFee_CapitalizationEditor_ToFacility_DropdownList = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaList("attached text:=To Facility")'
# LIQ_LineFee_CapitalizationEditor_ToLoan_DropdownList = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaList("attached text:=To Loan")'
LIQ_LineFee_CapitalizationEditor_ToLoan_DropdownList = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaList("attached text:=Currency.*")' ### attached text value was updated (LIQ 7.5.1.2 HF2 version)
LIQ_LineFee_CapitalizationEditor_OK_Button = 'JavaWindow("title:=Facility Ongoing Fee Capitalization Editor").JavaButton("attached text:=OK")'

###Line Fee Notebook - Accrual Tab###
LIQ_LineFee_Tab = 'JavaWindow("title:=Line Fee.*").JavaTab("tagname:=TabFolder")'
LIQ_LineFee_Accrual_Cycles_JavaTree = 'JavaWindow("title:=Line Fee.*").JavaTree("attached text:=Cycles:")'
LIQ_LineFee_General_OptionsPayment_Menu = 'JavaWindow("title:=Line Fee.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
LIQ_LineFee_EffectiveDate_Field = 'JavaWindow("title:=Line Fee.*").JavaEdit("attached text:=Effective Date:.*")'
LIQ_LineFee_Cycle_List = 'JavaWindow("title:=Line Fee.*").JavaList("attached text:=Cycle.*")'
LIQ_LineFee_Window = 'JavaWindow("title:=Line Fee.*")'
LIQ_LineFee_OnlineAcrual_Menu = 'JavaWindow("title:=Line Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Perform Online Accrual")'
LIQ_LineFeeNotebook_Pending_Window = 'JavaWindow("title:=Line Fee.*/ Pending:.*")'
LIQ_LineFeeTag_Tab = 'JavaWindow("title:=Line Fee.*").JavaTab("tagname:=TabFolder")'
LIQ_LineFeeNotebook_Workflow_JavaTree = 'JavaWindow("title:=Line Fee.*").JavaTree("tagname:=Drill down to perform.*","index:=0")'
LIQ_LineFeeNotebook_CycleShareAdjustment_Button = 'JavaWindow("title:=Line Fee.*").JavaButton("attached text:=Cycle Shares Adjustment")'
LIQ_FeeNotebook_Accrual_JavaTree = 'JavaWindow("title:=.* Fee / Released:.*").JavaTree("labeled_containers_path:=Tab:Accrual;","attached text:=Cycles:")'

### Line Fee Payment - Cycles for Line Fee ###
LIQ_LineFee_Cycles_Window = 'JavaWindow("title:=Cycles for Line Fee.*")'
LIQ_LineFee_Cycles_List = 'JavaWindow("title:=Cycles for Line Fee.*").JavaTree("attached text:=Choose a cycle to make a payment against")'
LIQ_LineFee_Cycles_OKButton = 'JavaWindow("title:=Cycles for Line Fee.*").JavaButton("label:=OK")'
LIQ_LineFee_Cycles_CancelButton = 'JavaWindow("title:=Cycles for Line Fee.*")JavaButton("label:=Cancel")'

###Line Fee - Events###   
LIQ_LineFee_Events_Javatree = 'JavaWindow("title:=Line Fee.*").JavaTree("tagname:=Select event to view details")' 
LIQ_Fee_Events_Javatree = 'JavaWindow("title:=.* Fee.*").JavaTree("tagname:=Select event to view details")'

###Line Fee - GL Entries###
LIQ_LineFee_Queries_GLEntries = 'JavaWindow("title:=Line Fee.* Ongoing Fee Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Fee_Queries_GLEntries = 'JavaWindow("title:=.* Fee Ongoing Fee Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'

###Line Fee - Reverse Payment###
LIQ_LineFee_ReversePayment = 'JavaWindow("title:=Line Fee.* Ongoing Fee Payment.*").JavaMenu("label:=Options").JavaMenu("label:=Reverse Payment")'
LIQ_LineFee_ReversePayment_CurrentCycleDue = 'JavaWindow("title:=Line Fee.* Reverse Fee.*").JavaEdit("tagname:=Line Fee", "index:=5")'
LIQ_LineFee_ReversePayment_RequestedAmount = 'JavaWindow("title:=Line Fee.* Reverse Fee.*").JavaEdit("tagname:=Text", "index:=2")'
LIQ_LineFee_ReversePayment_Tab = 'JavaWindow("title:=Line Fee.* Reverse Fee.*").JavaTab("tagname:=TabFolder")'
LIQ_LineFee_ReversePayment_WorkflowItems = 'JavaWindow("title:=Line Fee.* Reverse Fee.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_LineFee_ReversePayment_Cashflows_Window = 'JavaWindow("title:=Cashflows .* Reverse.*","displayed:=1")'
LIQ_LineFee_ReversePayment_Cashflow_OK_Button = 'JavaWindow("title:=Cashflows For.* Reverse.*").JavaButton("attached text:=OK")'
LIQ_Fee_ReversePayment = 'JavaWindow("title:=.* Fee Ongoing Fee Payment.*").JavaMenu("label:=Options").JavaMenu("label:=Reverse Payment")'
LIQ_ReverseFee_Options_Cashflow = 'JavaWindow("title:=.*Fee Reverse Fee.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'

### Line Fee - Notice Group ###
LIQ_FeePayment_Notice_Exit_Button = 'JavaWindow("title:=.*Notice Group.*","displayed:=1").JavaButton("label:=Exit.*")'