###Rollover/Conversion Notebook###
LIQ_RolloverConversion_Window = 'JavaWindow("title:=.* Rollover/Conversion.*")'
LIQ_RolloverConversion_Tab = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaTab("tagname:=TabFolder")'
LIQ_RolloverConversion_FileExit_Menu = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_RolloverConversion_Save_Menu = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaMenu("label:=File").JavaMenu("label:=Save")'

###General Tab###
LIQ_RolloverConversion_RequestedAmt_Textfield = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("attached text:=Requested Amt:")'
LIQ_RolloverConversion_ActualAmt_Textfield = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("attached text:=Actual Amt:")'
LIQ_RolloverConversion_EffectiveDate_Textfield = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("attached text:=Effective Date:")'
LIQ_RolloverConversion_IntCycleFreq_Dropdown = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaList("attached text:=Int. Cycle Freq:")'
LIQ_RolloverConversion_Alias_Textfield = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaStaticText("x:=110","y:=119")'
LIQ_RolloverConversion_Options_RepaymentSchedule_Menu = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")'
LIQ_RolloverConversion_Accrue_List = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaList("attached text:=Accrue:")'
LIQ_RolloverConversion_ActualDueDate_Text = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("attached text:=Actual Due Date:")'
LIQ_RolloverConversion_RepricingFrequency_List  = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaList("attached text:=Repricing Frequency:")'

###Conversion from - General Tab###
LIQ_ConversionFrom_Window = 'JavaWindow("title:=.*Conversion from .*")'
LIQ_ConversionFrom_ActualAmt_Textfield = 'JavaWindow("title:=.*Conversion from .*").JavaEdit("attached text:=Actual:")'

###Rates Tab###
LIQ_RolloverConversion_BaseRate_Button = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaTab("text:=Rates").JavaButton("attached text:=Base Rate:")'
LIQ_RolloverConversion_AllInRate_Text = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("attached text:=All-In Rate:")'
LIQ_RolloverConversion_Spread_Button = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaTab("text:=Rates").JavaButton("attached text:=Spread:")'

###Set Base Rate Window###
LIQ_SetBaseRate_Window = 'JavaWindow("title:=Set Base Rate")'
LIQ_SetBaseRate_BorrowerBaseRate_Textfield = 'JavaWindow("title:=Set Base Rate").JavaEdit("attached text:=Borrower Base Rate:")'
LIQ_SetBaseRate_BaseRateFromPricing_Textfield = 'JavaWindow("label:=Set Base Rate").JavaEdit("attached text:=Base Rate from Pricing:")'
LIQ_SetBaseRate_Ok_Button = 'JavaWindow("title:=Set Base Rate").JavaButton("attached text:=OK")'

# Pending Rollover
LIQ_PendingRollover_Window = 'JavaWindow("title:=.*Rollover/Conversion.*")'
LIQ_PendingRollover_Tab = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaTab("tagname:=TabFolder")'
LIQ_PendingRollover_Workflow_JavaTree = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_PendingRollover_BaseRate_Button = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaObject("tagname:=Group","text:=Interest Rates").JavaButton("label:=Base Rate:")'
LIQ_PendingRollover_Save_Submenu = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_PendingRollover_Exit_Submenu = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_PendingRollover_RequestedAmt_JavaEdit = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaObject("tagname:=Group","text:=Amounts").JavaEdit("attached text:=Requested Amt:")'
LIQ_PendingRollover_RepricingFrequency_Dropdown = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaList("attached text:=Repricing Frequency:")'

LIQ_SetBaseRate_Window = 'JavaWindow("title:=.*Set Base Rate.*")'
LIQ_SetBaseRate_BorrowerBaseRate_TextField = 'JavaWindow("title:=.*Set Base Rate.*").JavaEdit("attached text:=Borrower Base Rate:")'
LIQ_SetBaseRate_BorrowerBaseRate_OK_Button= 'JavaWindow("title:=.*Set Base Rate.*").JavaButton("attached text:=OK")'

LIQ_Rollover_Intent_Notice_Window = 'JavaWindow("title:=.*Notice Group.*","displayed:=1")'
LIQ_Rollover_EditHighlightedNotice_Button = 'JavaWindow("title:=.*Notice Group.*","displayed:=1").JavaButton("label:=Edit Highlighted Notice.*")'
LIQ_Rollover_NoticeCreate_Window = 'JavaWindow("title:=.*Notice created.*","displayed:=1")'

LIQ_RolloverConversion_Current = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("labeled_containers_path:=Tab:Rates;Group:Interest Rates;","index:=7")'
LIQ_RolloverConversion_Pricing = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaEdit("labeled_containers_path:=Tab:Rates;Group:Interest Rates;","index:=7")'


### Moved locators
LIQ_RolloverConversion_BaseRateButton = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaButton("label:=Base Rate:")'
LIQ_RolloverConversion_AcceptBaseRate = 'JavaWindow("title:=Set Base Rate").JavaButton("label:=Accept Rate from Pricing")'
LIQ_RolloverConversion_BorrowerBaseRate = 'JavaWindow("title:=Set Base Rate").JavaEdit("attached text:=Borrower Base Rate:")'
LIQ_RolloverConversion_BaseRate_OKButton = 'JavaWindow("title:=Set Base Rate").JavaButton("label:=OK")'
LIQ_RolloverConversion_Queries_GLEntries = 'JavaWindow("title:=Loan Repricing For Deal:.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_RolloverConversion_GLEntries_Window = 'JavaWindow("title:=GL Entries For Loan Repricing.*")'
LIQ_RolloverConversion_GLEntries_Table = 'JavaWindow("title:=GL Entries For Loan Repricing.*").JavaTree("attached text:=Drill down to view details")'
LIQ_RolloverConversion_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries For Loan Repricing.*").JavaButton("attached text:=Exit")'
LIQ_RolloverConversion_Options_Cashflow = 'JavaWindow("title:=Loan Repricing For Deal:.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_RolloverConversion_Options_LenderShares = 'JavaWindow("title:=Loan Repricing For Deal:.*").JavaMenu("label:=Options").JavaMenu("label:=Lender Shares")'
LIQ_RolloverConversion_LenderShares_Table = 'JavaWindow("title:=Shares for.*Loan Repricing For Facility:.*").JavaTree("attached text:=Drill Down for Primary/Assignment Detail")'
LIQ_RolloverConversion_LenderShares_Cancel = 'JavaWindow("title:=Shares for.*Loan Repricing For Facility:.*").JavaButton("label:=Cancel")'
LIQ_RolloverConversion_Options_Facility = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaMenu("label:=Options").JavaMenu("label:=Facility Notebook")'
LIQ_LoanRepricingForDeal_Release_TextField = 'JavaWindow("title:=Loan Repricing.*").JavaStaticText("attached text:=Released")'
LIQ_LoanRepricingForDeal_Primaries_Window = 'JavaWindow("title:=Primaries List.*")'

# Pending Rollover
LIQ_PendingRollover_Accrue_Dropdown = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaList("attached text:=Accrue:")'
LIQ_PendingRollover_AdjustedDueDate_Textfield = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaEdit("attached text:=Adjusted Due Date:")'

LIQ_Rollover_Currency_FXRate_Button = 'JavaWindow("title:=.* Rollover/Conversion.*").JavaButton("attached text:=F/X Rate.*")'
LIQ_Rollover_Currency_Window = 'JavaWindow("title:=Facility Currency.*")'
LIQ_Rollover_AUD_USD_Currency = 'JavaWindow("title:=Facility Currency.*").JavaEdit("attached text:=AUD to USD Rate:.*")'
LIQ_Rollover_Currency_Ok_Button = 'JavaWindow("title:=Facility Currency.*").JavaButton("attached text:=OK.*")'
LIQ_Rollover_Effective_Date = 'JavaWindow("title:=.*Rollover/Conversion.*").JavaEdit("attached text:=Effective Date:")'
LIQ_Rollover_Options_RepaymentSchedule = 'JavaWindow("title:=.*Rollover/Conversion.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")'


### Payments for Loan Window ###
LIQ_PaymentsForLoan_Window = 'JavaWindow("title:=Payments for Loan.*")'
LIQ_PaymentsForLoan_JavaTree = 'JavaWindow("title:=Payments for Loan.*").JavaTree("index:=0")'
LIQ_PaymentsForLoan_Payoff_Checkbox = 'JavaWindow("title:=Payments for Loan.*").JavaCheckBox("lable:=Payoff")'
LIQ_PaymentsForLoan_Amount_Textfield = 'JavaWindow("title:=Payments for Loan.*").JavaEdit("attached text:=Amount:")'
LIQ_PaymentsForLoan_CCY_List = 'JavaWindow("title:=Payments for Loan.*").JavaList("attached text:=CCY:")'
LIQ_PaymentsForLoan_EffectiveDate_Textfield = 'JavaWindow("title:=Payments for Loan.*").JavaEdit("attached text:=Effective Date:")'
LIQ_PaymentsForLoan_PayToDate_Textfield = 'JavaWindow("title:=Payments for Loan.*").JavaEdit("attached text:=Pay To Date:")'
LIQ_PaymentsForLoan_PrincipalDue_Text = 'JavaWindow("title:=Payments for Loan.*").JavaEdit("attached text:=Principal:")'
LIQ_PaymentsForLoan_InterestDue_Text = 'JavaWindow("title:=Payments for Loan.*").JavaEdit("attached text:=Interest:")'
LIQ_PaymentsForLoan_TotalDue_Text = 'JavaWindow("title:=Payments for Loan.*").JavaEdit("attached text:=Total:")'
LIQ_PaymentsForLoan_OutgoingCashflow_Radiobutton = 'JavaWindow("title:=Payments for Loan.*").JavaRadioButton("label:=Outgoing Cashflow")'
LIQ_PaymentsForLoan_IncomingCashflow_Radiobutton = 'JavaWindow("title:=Payments for Loan.*").JavaRadioButton("label:=Incoming Cashflow")'
LIQ_PaymentsForLoan_TransactionDescription_Textfield = 'JavaWindow("title:=Payments for Loan.*").JavaObject("tagname:=Group","text:=Transaction Description").JavaEdit("index:=0")'
LIQ_PaymentsForLoan_Interest_Checkbox = 'JavaWindow("title:=Payments for Loan.*").JavaCheckBox("label:=Interest")'
LIQ_PaymentsForLoan_Principal_Checkbox = 'JavaWindow("title:=Payments for Loan.*").JavaCheckBox("label:=Principal")'
LIQ_PaymentsForLoan_Create_Button = 'JavaWindow("title:=Payments for Loan.*").JavaButton("label:=Create")'
LIQ_PaymentsForLoan_Cancel_Button = 'JavaWindow("title:=Payments for Loan.*").JavaButton("label:=Cancel")'