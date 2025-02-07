###Initial Drawdown Notebook###
LIQ_InitialDrawdown_File_Exit = 'JavaWindow("title:=.*Initial Drawdown.*","displayed:=1").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_InitialDrawdown_Options_InterestCapitalization = 'JavaWindow("title:=.*Initial Drawdown.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Interest Capitalization.*")'
LIQ_InitialDrawdown_Options_CapitalizeInterest = 'JavaWindow("title:=.*Loan.*Active","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Capitalize Interest.*")'
LIQ_InitialDrawdown_Options_Payments = 'JavaWindow("title:=.*Loan.*Active","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Payment.*")'
LIQ_InitialDrawdown_Options_LoanNotebook = 'JavaWindow("title:=.*Initial Drawdown.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=Loan Notebook.*")'
LIQ_InitialDrawdown_Options_UpfrontFreeFromBorrower = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=Options").JavaMenu("label:=Upfront Fee From Borrower.*")'
LIQ_InitialDrawdown_Window = 'JavaWindow("title:=.*Initial Drawdown.*")'
LIQ_InitialDrawdown_Tab = 'JavaWindow("title:=.*Initial Drawdown.*","displayed:=1").JavaTab("tagname:=TabFolder")'
LIQ_InitialDrawdown_WorkflowAction = 'JavaWindow("title:=.*Initial Drawdown.*","displayed:=1").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_InitialDrawdown_AwaitingRelease_Status_Window = 'JavaWindow("title:=.*Initial Drawdown.*Awaiting Release.*","displayed:=1")'
LIQ_InitialDrawdown_Options_Cashflow = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_InitialDrawdown_Options_RepaymentSchedule = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")' 
LIQ_InitialDrawdown_AwaitingApproval_Status_Window = 'JavaWindow("title:=.*Initial Drawdown .*Awaiting Approval.*")'
LIQ_InitialDrawdown_AwaitingRateApproval_Status_Window = 'JavaWindow("title:=.*Initial Drawdown .*Awaiting Rate Approval.*")'
LIQ_InitialDrawdown_Released_Status_Window = 'JavaWindow("title:=.*Initial Drawdown .*Released.*")'
LIQ_InitialDrawdown_File_Save = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_InitialDrawdown_Options_Facility = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=Options").JavaMenu("label:=Facility Notebook")'
LIQ_InitialDrawdown_Options_OutstandingServicingGroupDetails = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=Options").JavaMenu("label:=Outstanding Servicing Group Details")'
LIQ_InitialDrawdown_Options_ViewOrUpdateLenderShares = 'JavaWindow("title:=.*Initial Drawdown.*").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'
LIQ_Loan_Options_OutstandingServicingGroupDetails = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Outstanding Servicing Group Details")'

###General Tab###
LIQ_InitialDrawdown_ActualAmt_Textfield  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Actual Amt:")'
LIQ_InitialDrawdown_RequestedAmt_Textfield  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Requested Amt:")'
LIQ_InitialDrawdown_EffectiveDate_Datefield  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Effective Date:")'
LIQ_InitialDrawdown_Repricing_Dropdownlist  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaList("attached text:=Repricing Frequency:")'
LIQ_InitialDrawdown_IntCycleFreq_Monthly_Dropdownlist  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaList("attached text:=Int. Cycle Freq:", "text:=Monthly")'
LIQ_InitialDrawdown_MaturityDate_Datefield  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Maturity Date:")'
LIQ_InitialDrawdown_ActualDueDate_Datefield  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Actual Due Date:")'
LIQ_InitialDrawdown_RepricingDate_Datefield  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Repricing Date:")'
LIQ_InitialDrawdown_AccrualEndDate_Datefield = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Accrual End Date:")'
LIQ_InitialDrawdown_AdjustedDueDate_Datefield = 'JavaWindow("title:=.*Initial Drawdown.*").JavaEdit("attached text:=Adjusted Due Date:")'
LIQ_InitialDrawdown_Accrue_Dropdown = 'JavaWindow("title:=.*Initial Drawdown.*").JavaList("attached text:=Accrue:")'
LIQ_InitialDrawdown_PaymentMode_Dropdown = 'JavaWindow("title:=.*Initial Drawdown.*").JavaList("attached text:=Payment Mode:")'
LIQ_InitialDrawdown_RequestedCCY_StaticDropdown = 'JavaWindow("title:=.*Initial Drawdown .*").JavaList("attached text:=Requested CCY:")'
LIQ_InitialDrawdown_ActualCCY_StaticText = 'JavaWindow("title:=.*Initial Drawdown .*").JavaObject("tagname:=Group","text:=Amounts").JavaStaticText("index:=4")'
LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaList("attached text:=Int. Cycle Freq:")'
LIQ_InitialDrawdown_RepaymentScheduleSync_Checkbox = 'JavaWindow("title:=.*Initial Drawdown.*").JavaCheckbox("attached text:=Repayment Schedule Sync")'
LIQ_InitialDrawdown_Accrue_Dropdownlist  = 'JavaWindow("title:=.*Initial Drawdown.*").JavaList("attached text:=Accrue:")'
LIQ_InitialDrawdown_RiskType_Button = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Risk Type:")'
LIQ_InitialDrawdown_SelectRiskType_Window = 'JavaWindow("title:=Select Risk Type")'
LIQ_InitialDrawdown_SelectRiskType_JavaTree = 'JavaWindow("title:=Select Risk Type").JavaTree("attached text:=Drill down to select")'
LIQ_InitialDrawdown_SelectRiskType_OK_Button = 'JavaWindow("title:=Select Risk Type").JavaButton("attached text:=OK")'
LIQ_InitialDrawdown_SetRateJavaTree = 'JavaWindow("title:=.*Initial Drawdown.*").JavaTree("attached text:=Select event to view details.*")'
LIQ_InitialDrawdown_Calendar_AddButton = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Add.*")'
LIQ_InitialDrawdown_Calendar_HolidayCalendar_Window = 'JavaWindow("title:=Holiday Calendar.*")'
LIQ_InitialDrawdown_Calendar_HolidayCalendar = 'JavaWindow("title:=Holiday Calendar.*").JavaList("attached text:=Calendar.*")'
LIQ_InitialDrawdown_Calendar_BorrowerIntentNotice_CheckBox = 'JavaWindow("title:=Holiday Calendar.*").JavaCheckbox("attached text:=Borrower Intent Notice.*")'
LIQ_InitialDrawdown_Calendar_FXRateSettingNotice_CheckBox = 'JavaWindow("title:=Holiday Calendar.*").JavaCheckbox("attached text:=FX Rate Setting Notice.*")'
LIQ_InitialDrawdown_Calendar_InterestRateSettingNotice_CheckBox = 'JavaWindow("title:=Holiday Calendar.*").JavaCheckbox("attached text:=Interest Rate Setting Notice.*")'
LIQ_InitialDrawdown_Calendar_EffectiveDate_CheckBox = 'JavaWindow("title:=Holiday Calendar.*").JavaCheckbox("attached text:=Effective Date.*")'
LIQ_InitialDrawdown_Calendar_PaymentAdviceDates_CheckBox = 'JavaWindow("title:=Holiday Calendar.*").JavaCheckbox("attached text:=Payment Advice Dates.*")'
LIQ_InitialDrawdown_Calendar_Billing_CheckBox = 'JavaWindow("title:=Holiday Calendar.*").JavaCheckbox("attached text:=Billing.*")'
LIQ_InitialDrawdown_Calendar_HolidayCalendar_OkButton = 'JavaWindow("title:=Holiday Calendar.*").JavaButton("attached text:=OK.*")'
LIQ_InitialDrawdown_Calendar_JavaTree = 'JavaWindow("title:=.*Initial Drawdown.*").JavaTree("attached text:=Drill down for details.*")'
LIQ_InitialDrawdown_Calendar_DeleteButton = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Delete.*")'
LIQ_InitialDrawdown_Comment_AddButton = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Add.*")'

##Rates Tab##
LIQ_InitialDrawdown_BaseRate_Button = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Base Rate:")'
LIQ_InitialDrawdown_BorrowerBaseRate_Textfield = 'JavaWindow("label:=Set Base Rate").JavaEdit("attached text:=Borrower Base Rate:")'
LIQ_InitialDrawdown_BaseRate_Textfield = 'JavaWindow("label:=Set Base Rate").JavaEdit("abs_x:=388","abs_y:=349")'
LIQ_InitialDrawdown_SetBaseRate_OK_Button = 'JavaWindow("label:=Set Base Rate").JavaButton("attached text:=OK")'
LIQ_InitialDrawdown_BorrowerBaseRate_Field = 'JavaWindow("title:=Set Base Rate.*").JavaEdit("index:=0")'
LIQ_InitialDrawdown_Spread_Current = 'JavaWindow("title:=.*Initial Drawdown .*").JavaEdit("attached text:=Current")'
LIQ_InitialDrawdown_SpreadIsFixed_Checkbox = 'JavaWindow("title:=.*Initial Drawdown .*").JavaCheckBox("attached text:=Spread is Fixed.*")'
LIQ_InitialDrawdown_AllInRate = 'JavaWindow("title:=.*Initial Drawdown .*").JavaEdit("attached text:=All-In Rate:")'
LIQ_InitialDrawdown_AllInRateFromPricing_Text = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group", "text:=Interest Rates").JavaEdit("Index:=5")'
LIQ_InitialDrawdown_AcceptBaseRate = 'JavaWindow("title:=Set Base Rate.*").JavaButton("attached text:=Accept Rate from Pricing.*")'
LIQ_InitialDrawdown_AcceptRateFromInterpolation = 'JavaWindow("title:=Set Base Rate.*").JavaButton("attached text:=Accept Rate from Interpolation.*")'
LIQ_InitialDrawdown_BaseRateFromPricing_Text = 'JavaWindow("title:=Set Base Rate.*").JavaEdit("attached text:=Base Rate from Pricing:")'
LIQ_InitialDrawdown_BaseRate_Current_Text = 'JavaWindow("title:=.*Initial Drawdown.*").javaObject("tagname:=Group","text:=Interest Rates").JavaEdit("index:=7")'
LIQ_InitialDrawdown_SpreadRate_Button = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Spread:")'
LIQ_InitialDrawdown_SpreadRate_TextField = 'JavaWindow("title:=Override Spread").JavaEdit("attached text:=Spread Override:")'
LIQ_InitialDrawdown_SpreadRate_OKButton = 'JavaWindow("title:=Override Spread").JavaButton("attached text:=OK")'
LIQ_SetBaseRate_Window = 'JavaWindow("title:=Set Base Rate.*")'
LIQ_OverrideSpread_Window = 'JavaWindow("title:=Override Spread.*")'

###Repayment Window###
LIQ_RepaymentSchedule_Options_Reschedule = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Reschedule")'
LIQ_RepaymentSchedule_ChooseScheduleType_Window = 'JavaWindow("title:=Choose a Type of Schedule", "displayed:=1")'
LIQ_RepaymentSchedule_ScheduleType_PrincipalOnly_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Principal Only")'
LIQ_RepaymentSchedule_ScheduleType_FPPID_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Fixed Principal Plus Interest Due")'
LIQ_RepaymentSchedule_ScheduleType_POBM_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Principal Only With Bullet At Maturity")'
LIQ_RepaymentSchedule_ScheduleType_FPPIDue_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Fixed Principal Plus Interest Due")'
LIQ_RepaymentSchedule_ScheduleType_FPPI_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Fixed Payment .*Principal and Interest.*")'
LIQ_RepaymentSchedule_ScheduleType_FlexSchedule_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Flex Schedule")'
LIQ_RepaymentSchedule_ScheduleType_Prorate_CheckBox = 'JavaWindow("title:=Choose a Type of Schedule").JavaCheckBox("attached text:=Prorate based on Facility Repayment Schedule")'
LIQ_RepaymentSchedule_ScheduleType_OK_Button = 'JavaWindow("title:=Choose a Type of Schedule").JavaButton("attached text:=OK")'
LIQ_RepaymentSchedule_NonBusDayRule_Dropdown = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaList("tagname:=Combo")'
LIQ_RepaymentSchedule_CurrentSchedule_POBM_Text = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaObject("tagname:=Group", "text:=Current Schedule - Principal Only with Bullet at Maturity")'
LIQ_RepaymentSchedule_CurrentSchedule_PrincipalOnly_Text = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaObject("tagname:=Group", "text:=Current Schedule - Principal Only")'
LIQ_RepaymentSchedule_CurrentSchedule_FixedPrincipalPlusInterestDue_Text = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaObject("tagname:=Group", "text:=Current Schedule - Fixed Principal Plus Interest Due")'
LIQ_RepaymentSchedule_CurrentSchedule_FixedPrincipalPlusInterestDue_List = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Frequency:")'
LIQ_RepaymentSchedule_CurrentSchedule_CurrentHostBank_TextField = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaEdit("attached text:=Current Host Bank:")'
LIQ_RepaymentSchedule_FlexSchedule_Section = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaObject("tagname:=Group","text:=Current Schedule - Flex Schedule")'
LIQ_RepaymentSchedule_CurrentFlexSchedule_JavaTree = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=.*Nominal Amount.*")'
LIQ_RepaymentSchedule_Options_Resynchronize = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Resynchronize")'
LIQ_RepaymentSchedule_CurrentSchedule_List = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Nominal Amount:")'
LIQ_RepaymentSchedule_Save_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Save")'
LIQ_RepaymentSchedule_Exit_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Exit")'
LIQ_RepaymentSchedule_AddUnschTran_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Add Unsch. Tran.")'
LIQ_AddTransaction_Window = 'JavaWindow("title:=Add Transaction")'
LIQ_AddTransaction_Principal_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Principal:")'
LIQ_AddTransaction_EffectiveDate_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_AddTransaction_ApplyPrincipalToNextSchedPayment_RadioButton = 'JavaWindow("title:=Add Transaction").JavaRadioButton("attached text:=Apply Principal To Next Scheduled Payment")'
LIQ_AddTransaction_OK_Button = 'JavaWindow("title:=Add Transaction").JavaButton("attached text:=OK")'

# Automatic Schedule Setup
LIQ_AutomaticScheduleSetup_FixedPrincipalPaymentAmount = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("index:=2")'

###Notices###
LIQ_Notices_BorrowerDepositor_Checkbox = 'JavaWindow("title:=Notices").JavaCheckBox("attached text:=Borrower / Depositor")'
LIQ_Notices_OK_Button = 'JavaWindow("title:=Notices").JavaButton("attached text:=OK")'

####For Rate Setting Notices####
LIQ_Notice_RateSettingNotice_Window = 'JavaWindow("title:=Rate .* Notice Group.*")'
LIQ_Notice_RateSettingNotice_Exit_Button = 'JavaWindow("title:=Rate .* Notice Group.*").JavaButton("attached text:=Exit")' 
LIQ_Notice_RateSettingNotice_Information_Table = 'JavaWindow("title:=Rate .* Notice Group.*").JavaTree("attached text:=Drill down to mark notices")'
LIQ_Notice_RateSettingNotice_Send_Button = 'JavaWindow("title:=Rate .* Notice Group.*").JavaButton("attached text:=Send")'
LIQ_Notice_RateSettingNotice_EditHighlightedNotice_Button = 'JavaWindow("title:=Rate .* Notice Group.*").JavaButton("attached text:=Edit Highlighted Notices")'
LIQ_Notice_RateSettingNotice_Edit_Window = 'JavaWindow("title:=Rate .* Notice created.*")'
LIQ_Notice_RateSettingNotice_Edit_Email = 'JavaWindow("title:=Rate .* Notice created.*").JavaEdit("attached text:=E-mail:")'
LIQ_Notices_RateSettingNotice_Exit_Button = 'JavaWindow("title:=Rate Setting Notice.*").JavaButton("attached text:=Exit")'
LIQ_Notice_Exit_Button = 'JavaWindow("title:=.* Notice.*", "displayed:=1").JavaButton("attached text:=Exit")'
LIQ_Notice_Information_Table = 'JavaWindow("title:=.* Notice.*").JavaTree("attached text:=Drill down to mark notices")'
LIQ_Notice_Send_Button = 'JavaWindow("title:=.* Notice.*").JavaButton("attached text:=Send")'
LIQ_Notice_EditHighlightedNotice_Button = 'JavaWindow("title:=.* Notice Group.*").JavaButton("attached text:=.*Highlighted Notices")'
LIQ_Notice_RateSettingNotice_Window = 'JavaWindow("title:=Rate .* Notice created.*")'
LIQ_Notice_RateSettingNotice_Email = 'JavaWindow("title:=Rate .* Notice created.*").JavaEdit("attached text:=E-mail:")'
LIQ_Notice_IntentNotice_Window = 'JavaWindow("title:=.* Payment Notice created.*")'
LIQ_Notice_IntentNotice_Email = 'JavaWindow("title:=.* Payment Notice created.*").JavaEdit("attached text:=E-mail:")'

####For Payment Notices####
LIQ_Notice_PaymentIntentNotice_Window = 'JavaWindow("title:=.* Payment Notice Group.*")'
LIQ_Notice_PaymentIntentNotice_Exit_Button = 'JavaWindow("title:=.* Payment Notice Group.*").JavaButton("attached text:=Exit")' 
LIQ_Notice_PaymentIntentNotice_Information_Table = 'JavaWindow("title:=.* Payment Notice Group.*").JavaTree("attached text:=Drill down to mark notices")'
LIQ_Notice_PaymentIntentNotice_Send_Button = 'JavaWindow("title:=.* Payment Notice Group.*").JavaButton("attached text:=Send")'
LIQ_Notice_PaymentIntentNotice_EditHighlightedNotice_Button = 'JavaWindow("title:=.* Payment Notice Group.*").JavaButton("attached text:=Edit Highlighted Notices")'
LIQ_Notice_PaymentIntentNotice_Edit_Window = 'JavaWindow("title:=.* Payment Notice created.*")'
LIQ_Notice_PaymentIntentNotice_Edit_Email = 'JavaWindow("title:=.* Payment Notice created.*").JavaEdit("attached text:=E-mail:")'

###Loan Window####
LIQ_Loan_Window = 'JavaWindow("title:=.*Loan.*Active")'
LIQ_InitialDrawdown_FileMenu_Save = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_InitialDrawdown_FileMenu_Exit = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_Loan_Options_Payment = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
LIQ_Loan_ChoosePayment_Window = 'JavaWindow("title:=Choose a Payment")'
LIQ_Loan_ChoosePayment_InterestPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Interest Payment")'
LIQ_Loan_ChoosePayment_PrincipalPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Principal Payment")'
LIQ_Loan_ChoosePayment_OK_Button = 'JavaWindow("title:=Choose a Payment").JavaButton("attached text:=OK")'
LIQ_Loan_CyclesforLoan_Window = 'JavaWindow("title:=Cycles for Loan.*")'
LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=Projected Due")'
LIQ_Loan_CyclesforLoan_List = 'JavaWindow("title:=Cycles for Loan.*").JavaTree("attached text:=Choose a cycle to make a payment against")'
LIQ_Loan_CyclesforLoan_OK_Button = 'JavaWindow("title:=Cycles for Loan.*", "displayed:=1").JavaButton("attached text:=OK")'
LIQ_Loan_Events_List = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Select event to view details")'
LIQ_Loan_ActualDueDate_Textfield = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Actual Due Date:")'
LIQ_Loan_AdjustedDueDate_Textfield = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Adjusted Due Date:")'
LIQ_Loan_RepricingDate_Label = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General.*","index:=0")'
LIQ_Loan_EffectiveDate_Label = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General.*","index:=4")'
LIQ_Loan_PricingOption_Label = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General.*","index:=15")'
LIQ_Loan_RepricingFrequency_List = 'JavaWindow("title:=.*Loan.*Active").JavaList("attached text:=Repricing Frequency:")'
LIQ_Loan_PaymentMode_List = 'JavaWindow("title:=.*Loan.*Active").JavaList("attached text:=Payment Mode:")'
LIQ_LoanInquire_Button = 'JavaWindow("title:=.*Loan.*Active").JavaButton("attached text:=Notebook in Inquiry Mode - F7.*")'
LIQ_LoanInquiry_InitialDrawdown_Button = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7.*")'
LIQ_Loan_GlobalOriginal_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Global Original:")'
LIQ_Loan_IntCycleFreq_Dropdownlist = 'JavaWindow("title:=.*Loan.*Active").JavaList("attached text:=Int. Cycle Freq:")'
LIQ_Loan_AllInRate = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=All-In Rate:")'
LIQ_Loan_Spread = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Spread:")'
LIQ_Loan_CurrentBaseRate = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Current","index:=0")'
LIQ_Loan_RateBasis_Dropdownlist = 'JavaWindow("title:=.*Loan.*Active").JavaObject("tagname:=Group", "text:=Interest Rates").JavaList("attached text:=Rate Basis:")'
LIQ_Loan_AccrualTab_Cycles_Table = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Cycles:")'
LIQ_Loan_GlobalCurrent_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Global Current:")'
LIQ_Loan_HostBankGross_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Host Bank Gross:")'
LIQ_Loan_HostBankNet_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Host Bank Net:")'
LIQ_Accrual_CycleDueOverview_Button = 'JavaWindow("title:=.*Loan.*Active").JavaButton("attached_text:=Cycle Shares Overview")'
LIQ_ServicingGroup_AccrualCycle = 'JavaWindow("title:=Servicing Group Accrual Cycle Detail")'
LIQ_ServicingGroup_CycleDue = 'JavaWindow("title:=Servicing Group Accrual Cycle Detail").JavaEdit("attached text:=Cycle due:")'
LIQ_ServicingGroup_Paid = 'JavaWindow("title:=Servicing Group Accrual Cycle Detail").JavaEdit("attached text:=Paid to date:")'
LIQ_ServicingGroup_Exit_Button = 'JavaWindow("title:=.*Servicing Group Accrual Cycle Detail").JavaButton("attached text:=Exit")'
####Interest Payment Notebook####
LIQ_Payment_Window = 'JavaWindow("title:=.* Payment.*")'
LIQ_Payment_Options_Payment = 'JavaWindow("title:=.* Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Payment_GLEntries_Window = 'JavaWindow("title:=GL Entries.*")'
LIQ_Payment_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries.*").JavaButton("attached text:=Exit")'
LIQ_Payment_EffectiveDate_Textfield = 'JavaWindow("title:=.* Payment.*").JavaEdit("attached text:=Effective Date:")'
LIQ_Payment_File_Save = 'JavaWindow("title:=.* Payment.*").JavaMenu("label:=File").JavaMenu("label:=Save")'    
LIQ_Payment_CashflowFromBorrower_RadioButton ='JavaWindow("title:=.* Payment.*").JavaRadioButton("attached text:=From Borrower")'
LIQ_Payment_AwaitingApproval_Status_Window = 'JavaWindow("title:=.*Payment .*Awaiting Approval.*")'
LIQ_Payment_Released_Status_Window = 'JavaWindow("title:=.*Payment .*Released.*")'
LIQ_Payment_RequestedAmount_Textfield = 'JavaWindow("title:=.* Payment.*", "displayed:=1").JavaEdit("labeled_containers_path:=.*Amounts.*", "index:=0")'
LIQ_Payment_CycleDue_Amount = 'JavaWindow("title:=.* Payment.*").JavaEdit("tagname:=Text", "x:=231", "y:=84")'
LIQ_Notices_RateSettingNotice_Window = 'JavaWindow("title:=Rate Setting Notice.*")'
LIQ_Notice_Window = 'JavaWindow("title:=.* Notice Group.*")'
LIQ_Notices_RateSettingNotice_Exit_Button = 'JavaWindow("title:=Rate Setting Notice.*").JavaButton("attached text:=Exit")'

####Bid Initial Drawdown Notebook####
LIQ_BidInitialDrawdown_Window = 'JavaWindow("title:=.*Bid Initial Drawdown.*","displayed:=1")'
LIQ_BidInitialDrawdown_Requested_TextField = 'JavaWindow("title:=.*Bid Initial Drawdown.*","displayed:=1").JavaEdit("attached text:=Requested Amt:")'
LIQ_BidInitialDrawdown_EffectiveDate_TextField = 'JavaWindow("title:=.*Bid Initial Drawdown.*","displayed:=1").JavaEdit("attached text:=Effective Date:")'

####Drawdown GL Entries####
LIQ_Drawdown_Queries_GLEntries = 'JavaWindow("title:=.* Drawdown.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Drawdown_GLEntries_Window = 'JavaWindow("title:=GL Entries.*")'
LIQ_Drawdown_GLEntries_Table = 'JavaWindow("title:=GL Entries.*").JavaTree("attached text:=Drill down to view details")'
LIQ_Drawdown_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries.*").JavaButton("attached text:=Exit")'

LIQ_Payment_Queries_GLEntries = 'JavaWindow("title:=.* Payment.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_Payment_GLEntries_Table = 'JavaWindow("title:=GL Entries.*").JavaTree("attached text:=Drill down to view details")'

####Existing Loans Window###
LIQ_ExistingOutstandings_Window = 'JavaWindow("title:=Existing.*")'
LIQ_ExistingOutstandings_Table = 'JavaWindow("title:=Existing.*").JavaTree("attached text:=Drill down to open the notebook")'

# Automatic Schedule Setup
LIQ_AutomaticScheduleSetup_Amount_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Amount:")'
LIQ_AutomaticScheduleSetup_EffectiveDate_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Effective Date:")'
LIQ_AutomaticScheduleSetup_MaturityDate_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("attached text:=Maturity Date:")'
LIQ_AutomaticScheduleSetup_InterestCycleFrequency_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("attached text:=Interest Cycle Frequency:")'
LIQ_AutomaticScheduleSetup_AllInRate_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Monthly")'
LIQ_AutomaticScheduleSetup_RateBasis_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("attached text:=Rate Basis:")'
LIQ_AutomaticScheduleSetup_FirstScheduleDate_Dropdown = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaList("attached text:=First Schedule Date:")'
LIQ_AutomaticScheduleSetup_InterestTriggerDate_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("attached text:=Interest Trigger Date:")'
LIQ_AutomaticScheduleSetup_NumberOfPayments_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("attached text:=Number of Payments:")'
LIQ_AutomaticScheduleSetup_AmortizationPeriods_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Amortization Periods:")'
LIQ_AutomaticScheduleSetup_AmortizationEndDate_TextField = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("attached text:=Amortization End Date:")'

# Automatic Schedule Setup
LIQ_AutomaticScheduleSetup_Window = 'JavaWindow("title:=Automatic Schedule Setup.*")'
LIQ_AutomaticScheduleSetup_Frequency_Dropdown = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaList("tagname:=Combo", "text:=Bullet")'
LIQ_AutomaticScheduleSetup_NumberOfCycles_Textfield = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=No. Cyc. Items:")'
LIQ_AutomaticScheduleSetup_CyclicalAmount_Textfield = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaObject("tagname:=Group", "text:=Cyclical Schedule Terms").JavaEdit("attached text:=Amount:")'
LIQ_AutomaticScheduleSetup_TriggerDate_Textfield = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Trigger Date:")'
LIQ_AutomaticScheduleSetup_Principal_OK_Button = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaButton("attached text:=OK")'
LIQ_AutomaticScheduleSetup_Accept_Button = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaButton("attached text:=Accept")'
LIQ_AutomaticScheduleSetup_CalculatedFixedPrincipalAmount = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("x:=266","y:=238")'
# LIQ_AutomaticScheduleSetup_FixedPrincipalPaymentAmount = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Monthly")'
LIQ_AutomaticScheduleSetup_OK_Button = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaButton("attached text:=OK")'

LIQ_AutomaticScheduleSetup_NumberOfPayments = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaStaticText("x:=253","y:=270")'
LIQ_AutomaticScheduleSetup_Amount = 'JavaWindow("title:=Automatic Schedule Setup.*").JavaEdit("attached text:=Amount:")'


# Select Fixed Payment Amount
LIQ_SelectFixedPaymentAmount_Window = 'JavaWindow("title:=Select Fixed Payment Amount.*")'
LIQ_SelectFixedPaymentAmount_CalculatedFixedPayment_JavaEdit = 'JavaWindow("title:=Select Fixed Payment Amount.*").JavaEdit("to_class:=JavaEdit","x:=215","y:=25")'
LIQ_SelectFixedPaymentAmount_AcceptCalculatedFixedPayment_Checkbox = 'JavaWindow("title:=Select Fixed Payment Amount.*").JavaCheckBox("attached text:=Accept Calculated Fixed Payment")'
LIQ_Inquire_Button = 'JavaWindow("title:=.*Bid Loan.*").JavaButton("attached text:=Notebook in Inquiry Mode - F7.*")'
LIQ_SelectFixedPaymentAmount_OK_Button = 'JavaWindow("title:=Select Fixed Payment Amount.*").JavaButton("attached text:=OK")'

###Flexible Schedule###
LIQ_FlexibleSchedule_Window = 'JavaWindow("title:=Flexible Schedule")'
LIQ_FlexibleSchedule_AddItems_Button = 'JavaWindow("title:=Flexible Schedule").JavaButton("attached text:=Add Item.*")'
LIQ_FlexibleSchedule_NonBusinessDayRule_Field = 'JavaWindow("title:=Flexible Schedule").JavaList("attached text:=Non Business Day Rule:")'
LIQ_FlexibleSchedule_JavaTree = 'JavaWindow("title:=Flexible Schedule").JavaTree("attached text:=All-In Rate:")'
LIQ_FlexibleSchedule_CalculatePayments_Button = 'JavaWindow("title:=Flexible Schedule").JavaButton("attached text:=Calculate Payments")'
LIQ_FlexibleSchedule_OK_Button = 'JavaWindow("title:=Flexible Schedule").JavaButton("attached text:=OK")'
LIQ_FlexibleSchedule_AllInRate_Field = 'JavaWindow("title:=Flexible Schedule").JavaEdit("attached text:=All-In Rate:")'
# LIQ_FlexibleSchedule_RateBasis_Value = 'JavaWindow("title:=Flexible Schedule").JavaStaticText("x:=611","y:=18")'
LIQ_FlexibleSchedule_RateBasis_Value = 'JavaWindow("title:=Flexible Schedule").JavaStaticText("labeled_containers_path:=.*Loan Interest Data.*","index:=5")'
LIQ_FlexibleSchedule_Confirmation_Yes_Button = 'JavaWindow("title:=Flexible Schedule").JavaWindow("title:=Confirmation").JavaButton("label:=Yes")'
LIQ_FlexibleSchedule_ResyncSettings_Dropdown = 'JavaWindow("title:=Flexible Schedule").JavaList("attached text:=Resync.*Settings:")'

###Flexible Schedule - Add Items Window###
LIQ_FSched_AddItems_Window = 'JavaWindow("title:=Add Items")'
LIQ_FSched_AddItems_PayThruMaturity_CheckBox = 'JavaWindow("title:=Add Items").JavaCheckBox("attached text:=Pay Thru Maturity")'
LIQ_FSched_AddItems_AmortizeThru_Field = 'JavaWindow("title:=Add Items").JavaEdit("attached text:=Amortize Thru:")'
LIQ_FSched_AddItems_NoOFPayments_Field = 'JavaWindow("title:=Add Items").JavaEdit("attached text:=.*of Payments:")'
LIQ_FSched_AddItems_Frequency_Field = 'JavaWindow("title:=Add Items").JavaList("attached text:=Frequency:")'
LIQ_FSched_AddItems_Type_Field = 'JavaWindow("title:=Add Items").JavaList("attached text:=Type:")'
LIQ_FSched_AddItems_Date_Field = 'JavaWindow("title:=Add Items").JavaEdit("attached text:=Date:")'
LIQ_FSched_AddItems_PIAmount_Field_MaturityEnabled = 'JavaWindow("title:=Add Items").JavaEdit("index:=0")'
LIQ_FSched_AddItems_PIAmount_Field_MaturityDisabled = 'JavaWindow("title:=Add Items").JavaEdit("index:=1")'
LIQ_FSched_AddItems_PI_CheckBox = 'JavaWindow("title:=Add Items").JavaCheckBox("attached text:=P&&I Amount:")'
LIQ_FSched_AddItems_OK_Button = 'JavaWindow("title:=Add Items").JavaButton("attached text:=OK")'
LIQ_FSched_AddItems_PrincipalAmount_CheckBox = 'JavaWindow("title:=Add Items").JavaCheckBox("attached text:=Principal Amount:")'
LIQ_FSched_AddItems_PrincipaAmount_Field = 'JavaWindow("title:=Add Items").JavaEdit("x:=146","y:=184")'
LIQ_FSched_AddItems_NominalAmount_Field = 'JavaWindow("title:=Add Items").JavaEdit("index:=4")'
LIQ_FSched_AddItems_ConsolidationType_List = 'JavaWindow("title:=Add Items").JavaList("attached text:=Consolidation Type:")'
LIQ_FSched_AddItems_BorrowRemittanceInstruction_Button = 'JavaWindow("title:=Add Items").JavaButton("attached text:=Borrower Remit\. Inst\.")'
LIQ_FSched_AddItems_PandIAmount_CheckBox = 'JavaWindow("title:=Add Items").JavaCheckBox("attached text:=P&&I Amount:")'
LIQ_FSched_AddItems_PandIAmount_NonPayThruMaturity_Field = 'JavaWindow("title:=Add Items").JavaEdit("index:=1")'
LIQ_FSched_AddItems_PandIAmount_PayThruMaturity_Field = 'JavaWindow("title:=Add Items").JavaEdit("index:=0")'

###Flexible Schedule - Choose Remittance Instructions for [Borrower] Window###
LIQ_FSched_ChooseRI_Window = 'JavaWindow("title:=Choose Remittance Instructions for.*")'
LIQ_FSched_ChooseRI_JavaTree = 'JavaWindow("title:=Choose Remittance Instructions for.*").JavaTree("attached text:=Drill down to view details")'
LIQ_FSched_ChooseRI_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions for.*").JavaButton("attached text:=OK")'

###Outstanding WIP###
LIQ_WIP_Outstanding_JavaTree = 'JavaWindow("title:=Transactions In Process that Satisfy the Filter").JavaTree("attached text:=Target Date:")'

## Pending Loan Drawdown
LIQ_PendingLoanTransactions_Window = 'JavaWindow("title:=Pending Loan Transactions.*")'
LIQ_PendingLoanTransactions_JavaTree = 'JavaWindow("title:=Pending Loan Transactions.*").JavaTree("attached text:=Drill down to view.*")'

### Initial Drawdown Notebook - Events Tab ###
LIQ_DrawdownEvents_List = 'JavaWindow("title:=.*Initial Drawdown.*").JavaTree("attached text:=Select event to view details")'
LIQ_DrawdownEvents_Comment = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=Event Details").JavaEdit("attached text:=Comment:")'

### Facility Currency F/X Rate Window ###
LIQ_FXRate_Window = 'JavaWindow("title:=.*F/X Rate.*")'
LIQ_FXRate_UseFacilityRate_Button = 'JavaWindow("title:=.*F/X Rate.*").JavaButton("label:=Use Facility.*Rate")'
LIQ_FXRate_UserSpotRate_Button ='JavaWindow("title:=.*F/X Rate.*").JavaButton("label:=Use Spot.*Rate")'
LIQ_FXRate_FacilityRate_Text = 'JavaWindow("title:=.*F/X Rate.*").JavaEdit("index:=1")'
LIQ_FXRate_SpotRate_Text = 'JavaWindow("title:=.*F/X Rate.*").JavaEdit("index:=0")'
LIQ_FXRate_Rate_Textfield = 'JavaWindow("title:=.*F/X Rate.*").JavaEdit("attached text:=.*Rate:")'
LIQ_FXRate_OK_Button = 'JavaWindow("title:=.*F/X Rate.*").JavaButton("label:=OK")'
LIQ_FXRate_Cancel_Button = 'JavaWindow("title:=.*F/X Rate.*").JavaButton("label:=Cancel")'


### Initial Drawdown Notebook - Currency Tab ###
LIQ_DrawdownCurrencyTab_Currency_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=F/X Rate").JavaStaticText("index:=6")'
LIQ_DrawdownCurrencyTab_FacilityCurrency_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=F/X Rate").JavaStaticText("index:=7")'
LIQ_DrawdownCurrencyTab_FXRate_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=F/X Rate").JavaStaticText("index:=0")'
LIQ_DrawdownCurrencyTab_HistoricalFXRate_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=F/X Rate").JavaStaticText("index:=1")'
LIQ_DrawdownCurrencyTab_Current_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=Amounts in Facility Currency").JavaStaticText("index:=3")'
LIQ_DrawdownCurrencyTab_HostBankGross_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=Amounts in Facility Currency").JavaStaticText("index:=4")'
LIQ_DrawdownCurrencyTab_HostBankNext_StaticText = 'JavaWindow("title:=.*Initial Drawdown.*").JavaObject("tagname:=Group","text:=Amounts in Facility Currency").JavaStaticText("index:=5")'
LIQ_FacilityCurrency_Window = 'JavaWindow("title:=Facility Currency.*","displayed:=1")'
LIQ_FacilityCurrency_FacilityAudToUsd_Button = 'JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Facility AUD to USD Rate")'
LIQ_FacilityCurrency_Facility_Rate_Ok_Button = 'JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=OK")'

LIQ_Drawdown_Window = 'JavaWindow("title:=.* Drawdown .*")'
LIQ_Drawdown_Tab = 'JavaWindow("title:=.* Drawdown .*").JavaTab("tagname:=TabFolder")'
LIQ_Drawdown_WorkflowItems = 'JavaWindow("title:=.* Drawdown.*").JavaTree("attached text:=Drill down to perform Workflow item")'

### Servicing Group Selection List Window ###
LIQ_ServicingGroupSelectionList_Window = 'JavaWindow("title:=.*Servicing Group Selection List.*")'
LIQ_ServicingGroupSelectionList_Table = 'JavaWindow("title:=Servicing Group Selection List.*").JavaTree("attached text:=Drill down to access Servicing Group Details")'
LIQ_ServicingGroupSelectionList_Exit_Button = 'JavaWindow("title:=.*Servicing Group Selection List.*").JavaButton("attached text:=Exit")'

### Outstanding Servicing Group Details Window ###
LIQ_OutstandingServicingGroupDetails_Window = 'JavaWindow("title:=.*Outstanding Servicing Group Details.*")'
LIQ_OutstandingServicingGroupDetails_Add_Button = 'JavaWindow("title:=.*Outstanding Servicing Group Details.*").JavaButton("attached text:=Add")'
LIQ_OutstandingServicingGroupDetails_OK_Button = 'JavaWindow("title:=.*Outstanding Servicing Group Details.*").JavaButton("attached text:=OK")'

### MIS Codes ###
LIQ_InitialDrawdown_MISCodes_Add_Button = 'JavaWindow("title:=.*Initial Drawdown.*").JavaButton("attached text:=Add")'
LIQ_InitialDrawdown_MISCodes_JavaTree = 'JavaWindow("title:=.*Initial Drawdown.*").JavaTree("attached text:=Drill down for details")'

### MIS Code Details Window ###
LIQ_InitialDrawdown_MISCodeDetails_Window = 'JavaWindow("text:=.*Initial Drawdown MIS Code Details")'
LIQ_InitialDrawdown_MISCode_List = 'JavaWindow("title:=.*Initial Drawdown MIS Code Details").JavaList("attached text:=MIS Code:")'
LIQ_InitialDrawdown_Value_Field = 'JavaWindow("text:=.*Initial Drawdown MIS Code Details").JavaEdit("attached text:=Value:")'
LIQ_InitialDrawdown_OK_Button = 'JavaWindow("text:=.*Initial Drawdown MIS Code Details").JavaButton("attached text:=OK")'
LIQ_InitialDrawdown_Cancel_Button = 'JavaWindow("text:=.*Initial Drawdown MIS Code Details").JavaButton("attached text:=Cancel")'
