####Loan Notebook  - General Tab####
LIQ_Loan_Window = 'JavaWindow("title:=.*Loan.*Active")'
LIQ_Loan_Options_Payment = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
LIQ_Loan_ChoosePayment_Window = 'JavaWindow("title:=Choose a Payment")'
LIQ_Loan_ChoosePayment_InterestPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Interest Payment")'
LIQ_Loan_ChoosePayment_PaperClipPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Paper Clip Payment")'
LIQ_Loan_ChoosePayment_OK_Button = 'JavaWindow("title:=Choose a Payment").JavaButton("attached text:=OK")'
LIQ_Loan_CyclesforLoan_Window = 'JavaWindow("title:=Cycles for Loan.*")'
LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=Projected Due")'
LIQ_Loan_CyclesforLoan_List = 'JavaWindow("title:=Cycles for Loan.*").JavaTree("attached text:=Choose a cycle to make a payment against")'
LIQ_Loan_CyclesforLoan_OK_Button = 'JavaWindow("title:=Cycles for Loan.*").JavaButton("attached text:=OK")'
LIQ_Loan_Tab = 'JavaWindow("title:=.*Loan \(.*").JavaTab("tagname:=Int\. Cycle Freq:")'
LIQ_Loan_GlobalOriginal_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Global Original:")'
LIQ_Loan_GlobalCurrent_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Global Current:")'
LIQ_Loan_IntCycleFreq_Dropdownlist = 'JavaWindow("title:=.*Loan.*Active").JavaList("attached text:=Int. Cycle Freq:")'
LIQ_Loan_AccrualTab_Cycles_Table = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Cycles:")'
LIQ_Loan_GeneralTab_AdjustedDueDate_Textfield = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Adjusted Due Date:")'
LIQ_Loan_GeneralTab_RateSettingDueDate_Textfield = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Rate Setting Due Date:")'
LIQ_Loan_Options_RepaymentSchedule = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")'
LIQ_Loan_InquiryMode_Button = 'JavaWindow("title:=.*Loan.*Active").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'    
LIQ_Loan_UpdateMode_Button = 'JavaWindow("title:=.*Loan.*Active").JavaButton("attached text:=Notebook in Update Mode - F7")'
LIQ_Loan_RiskType_Text = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General;", "Index:=1")'
LIQ_Loan_Currency_Text = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General;Group:Loan Amounts;", "Index:=4")'
LIQ_Loan_EffectiveDate_Text = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General;","Index:=3")'
LIQ_Loan_MaturityDate_Text = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("labeled_containers_path:=Tab:General;", "index:=0")'
LIQ_Loan_PaymentMode_List = 'JavaWindow("title:=.*Loan.*ctive").JavaList("attached text:=Payment Mode:")'
LIQ_Loan_PricingOption_Text = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:General;","Index:=12")'
LIQ_Loan_RatesTab_PenaltySpread_Status_OFF = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:Rates;Group:Interest Rates;Group:Penalty Spread;","attached text:=OFF")'
LIQ_Loan_RatesTab_BaseRate_Field = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Current","index:=0")'
LIQ_Loan_RatesTab_Spread_Field = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Spread:")'
LIQ_Loan_Accounting_PerformOnlineAccrual_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Accounting").JavaMenu("label:=Perform Online Accrual")'
LIQ_Loan_AnyStatus_Window = 'JavaWindow("title:=.*Loan \(.*")'
LIQ_Loan_AnyStatus_Tab = 'JavaWindow("title:=.*Loan \(.*").JavaTab("tagname:=TabFolder")'
LIQ_Loan_AnyStatus_RatesTab_BaseRate_Field = 'JavaWindow("title:=.*Loan \(.*").JavaEdit("attached text:=Current","index:=0")'
LIQ_Loan_AnyStatus_RatesTab_Spread_Field = 'JavaWindow("title:=.*Loan \(.*").JavaEdit("attached text:=Spread:")'
LIQ_Loan_RepricingFrequency_JavaList = 'JavaWindow("title:=.*Loan.*Active").JavaList("attached text:=Repricing Frequency:")'
LIQ_Loan_RepricingDate_Text = 'JavaWindow("title:=.*Loan.*Active").JavaStaticText("Index:=1")'
LIQ_Loan_Options_LoanChangeTransaction_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Loan Change Transaction")'
LIQ_Loan_Queries_FeeActivityLIst_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Queries").JavaMenu("label:=Fee Activity List")'
LIQ_Loan_CyclesforLoan_ProRateType_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=${Pro_Rate}")'
LIQ_Loan_ChoosePayment_Cancel_Button = 'JavaWindow("title:=Choose a Payment").JavaButton("attached text:=Cancel")'

####Loan Notebook - Rate Tab#####
LIQ_Loan_AllInRate = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=All-In Rate:")'
LIQ_Loan_RateBasis_Dropdownlist = 'JavaWindow("title:=.*Loan.*Active").JavaObject("tagname:=Group", "text:=Interest Rates").JavaList("attached text:=Rate Basis:")'
LIQ_Loan_AnyStatus_AllInRate = 'JavaWindow("title:=.*Loan \(.*").JavaEdit("attached text:=All-In Rate:")'
LIQ_Loan_AnyStatus_RateBasis_Dropdownlist = 'JavaWindow("title:=.*Loan \(.*").JavaObject("tagname:=Group", "text:=Interest Rates").JavaList("attached text:=Rate Basis:")'
LIQ_Loan_Spread_Text = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Spread:")'
 
###Loan Notebook - Events Tab####
LIQ_Loan_Events_List = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Select event to view details")'
 
###Loan Notebook - GL Entries###
LIQ_PrincipalPayment_GLEntries_Window = 'JavaWindow("title:=GL Entries For.*Principal Payment")'
LIQ_PrincipalPayment_GLEntries_Table = 'JavaWindow("title:=GL Entries For.*Principal Payment").JavaTree("attached text:=Drill down to view details")'
LIQ_PrincipalPayment_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries For.*Principal Payment").JavaButton("attached text:=Exit")'  
 
###Loan Notebook - Currency Tab####
LIQ_Loan_Currency_FXRateAUDtoUSD = 'JavaWindow("title:=.*Loan.*Active").JavaObject("text:=F.*X Rate").JavaStaticText("to_class:=JavaStaticText","index:=0")'
LIQ_Loan_Currency_Textbox = 'JavaWindow("title:=Facility Currency.*").JavaEdit("attached text:=AUD to USD Rate:")'
LIQ_Loan_Currency_RateHistory_Window = 'JavaWindow("title:=.* History")'
LIQ_Loan_Currency_Current='JavaWindow("title:=.*Loan.*Active").JavaStaticText("labeled_containers_path:=Tab:Currency;Group:Amounts in Facility Currency;","index:=3")'
LIQ_Loan_History_Button='JavaWindow("title:=.*Loan.*Active").JavaButton("attached text:=History")'
LIQ_Loan_Currency_RateHistory_Table = 'JavaWindow("title:=.* History").JavaTree("attached text:=.*Drill down to update.*")'
LIQ_Loan_Currency_RateHistory_OK_Button = 'JavaWindow("title:=.* History").JavaButton("attached text:=OK")'

 
###Inactive Loan Window####
LIQ_InactiveLoan_Window = 'JavaWindow("title:=.*Loan.*Inactive")'
LIQ_InactiveLoan_Tab = 'JavaWindow("title:=.*Loan.*Inactive").JavaTab("tagname:=TabFolder")'
 
###Repayment Schedule Window###
LIQ_RepaymentSchedule_Window = 'JavaWindow("title:=Repayment Schedule For Loan.*")'
LIQ_RepaymentSchedule_Options_Reschedule = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Reschedule")'
LIQ_RepaymentSchedule_ScheduleType_Window = 'JavaWindow("title:=Choose a Type of Schedule")'
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
LIQ_RepaymentSchedule_CurrentSchedule_List = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Nominal Amount:")'
LIQ_RepaymentSchedule_Frequency_JavaTree = 'JavaWindow("title:=Repayment Schedule.*").JavaTree("labeled_containers_path:=Group:Current Schedule.*")'
LIQ_RepaymentSchedule_Save_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Save")'
LIQ_RepaymentSchedule_Exit_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Exit")'
LIQ_RepaymentSchedule_AddUnschTran_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Add Unsch. Tran.")'
LIQ_AddTransaction_Window = 'JavaWindow("title:=Add Transaction")'
LIQ_AddTransaction_Principal_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Principal:")'
LIQ_AddTransaction_EffectiveDate_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_AddTransaction_ApplyPrincipalToNextSchedPayment_RadioButton = 'JavaWindow("title:=Add Transaction").JavaRadioButton("attached text:=Apply Principal To Next Scheduled Payment")'
LIQ_AddTransaction_OK_Button = 'JavaWindow("title:=Add Transaction").JavaButton("attached text:=OK")'
LIQ_AddTransaction_InterestDue_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Interest Due.*")'
LIQ_RepaymentSchedule_Options_CreateTemporaryPaymentPlan = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Create Temporary Payment Plan")'
LIQ_RepaymentSchedule_ModifyItem_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Modify Item.*")'
LIQ_RepaymentSchedule_Options_Resynchronize = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Resynchronize")'
LIQ_RepaymentSchedule_ResyncSettings_Dropdown = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaList("attached text:=Resync.*Settings:")'
LIQ_RepaymentSchedule_Options_DeleteSchedule = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Delete Schedule")'

###Temporary Repayment Schedule Window###
LIQ_TemporaryRepaymentSchedule_Window = 'JavaWindow("title:=Temporary Repayment Schedule For Loan.*")'
LIQ_TemporaryRepaymentSchedule_Save_Button = 'JavaWindow("title:=Temporary Repayment Schedule For Loan.*").JavaButton("attached text:=Save")'
LIQ_TemporaryRepaymentSchedule_Exit_Button = 'JavaWindow("title:=Temporary Repayment Schedule For Loan.*").JavaButton("attached text:=Exit")'
LIQ_TemporaryRepaymentSchedule_Options_BecomeLegalPaymentPlan = 'JavaWindow("title:=Temporary Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Become Legal Payment Plan")'

###Loan Notebook - General Tab###    
LIQ_Loan_Window = 'JavaWindow("title:=.*Loan.*ctive")'
LIQ_InactiveLoan_Window = 'JavaWindow("title:=.*Loan.*Inactive")'
LIQ_LoanNotebook_RepaymentSchedule_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")' 
LIQ_LoanNotebook_FacilityNotebook_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Facility Notebook")'  
LIQ_LoanNotebook_Options_ViewLenderShares = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=View Lender Shares")'
LIQ_LoanNotebook_RepaymentSchedule_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")' 
 
LIQ_Loan_GlobalOriginal_Field = 'JavaWindow("title:=.*Loan.*ctive").JavaEdit("attached text:=Global Original:")'
LIQ_Loan_GlobalCurrent_Field = 'JavaWindow("title:=.*Loan.*ctive").JavaEdit("attached text:=Global Current:")'
LIQ_Loan_HostBankGross_Field = 'JavaWindow("title:=.*Loan.*ctive").JavaEdit("attached text:=Host Bank Gross:")'  
LIQ_Loan_HostBankNet_Field = 'JavaWindow("title:=.*Loan.*ctive").JavaEdit("attached text:=Host Bank Net:")' 
LIQ_Loan_Event_JavaTree = 'JavaWindow("title:=.*Loan.*ctive").JavaTree("attached text:=Select event to view details")' 
LIQ_LoanNotebook_FileExit_Menu = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=File").JavaMenu("label:=Exit")' 
LIQ_Loan_HostBankGross_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Host Bank Gross:")'
LIQ_Loan_HostBankNet_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Host Bank Net:")'
 
###Loan Notebook - Pending Tab####
LIQ_Loan_PendingItems_Null = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Pending Transactions","items count:=0")'
LIQ_Loan_PendingTab_JavaTree = 'JavaWindow("title:=.*Loan \(.*").JavaTree("attached text:=Pending Transactions")'
 
###Loan Notebook - Repayment Schedule Window###
LIQ_RepaymentSchedule_CurrentSchedule_JavaTree = 'JavaWindow("title:= Repayment Schedule.*").JavaTree("index:=0")'     
LIQ_RepaymentSchedule_FlexSchedule_JavaTree = 'JavaWindow("title:= Repayment Schedule.*").JavaTree("attached text:=Resync. Settings:")'
LIQ_RepaymentSchedule_CreatePending_Button = 'JavaWindow("title:= Repayment Schedule.*").JavaButton("label:=Create Pending Tran.*")'
LIQ_RepaymentSchedule_DeletePending_Button = 'JavaWindow("title:= Repayment Schedule.*").JavaButton("label:=Delete Pending Tran.*")'
LIQ_RepaymentSchedule_Transaction_NB_Button = 'JavaWindow("title:= Repayment Schedule.*").JavaButton("label:=Transaction NB")'
LIQ_RepaymentSchedule_OriginalLoanAmount_Field =    'JavaWindow("title:= Repayment Schedule.*").JavaEdit("attached text:=Original:")' 
LIQ_RepaymentSchedule_CurrentLoanAmount_Field =    'JavaWindow("title:= Repayment Schedule.*").JavaEdit("attached text:=Current:")' 
LIQ_RepaymentSchedule_CurrentHostAmount_Field =    'JavaWindow("title:= Repayment Schedule.*").JavaEdit("attached text:=Current Host Bank:")'
LIQ_MakeSelection_DeleteInterestOnly_RadioButton = 'JavaWindow("title:=Make Selection.*").JavaRadioButton("attached text:=.*Delete Interest Only.*")'
 
###Existing Loan for Facility Window Window###
LIQ_ExistingLoanForFacility_Window = 'JavaWindow("title:=Existing Loans For Facility.*")'
LIQ_ExistingLoanForFacility_Update_Checkbox = 'JavaWindow("title:=Existing Loans For Facility.*").JavaCheckBox("attached text:=Open notebook in update mode")'
LIQ_ExistingLoanForFacility_RemainOpen_Checkbox = 'JavaWindow("title:=Existing Loans For Facility.*").JavaCheckBox("attached text:=Remain open after.*")'
LIQ_ExistingLoanForFacility_Tree = 'JavaWindow("title:=Existing Loans For Facility.*").JavaTree("attached text:=Drill down to open the notebook")'   
 
###Loan Notebook - Repayment Schedule Window###
LIQ_Payment_PrincipalPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Principal Payment")'
LIQ_Payment_OK_Button = 'JavaWindow("title:=Choose a Payment").JavaButton("label:=OK")'
 
LIQ_RepaymentSchedule_Options_Reschedule = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Reschedule")'
LIQ_RepaymentSchedule_ChooseScheduleType_Window = 'JavaWindow("title:=Choose a Type of Schedule")'
LIQ_RepaymentSchedule_ScheduleType_PrincipalOnly_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Principal Only")'
LIQ_RepaymentSchedule_ScheduleType_FPPID_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Fixed Principal Plus Interest Due")'
LIQ_RepaymentSchedule_ScheduleType_POBM_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Principal Only With Bullet At Maturity")'
LIQ_RepaymentSchedule_ScheduleType_FPPI_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Fixed Payment .*Principal and Interest.*")'
LIQ_RepaymentSchedule_ScheduleType_FlexSchedule_RadioButton = 'JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("attached text:=Flex Schedule")'
LIQ_RepaymentSchedule_ScheduleType_Prorate_CheckBox = 'JavaWindow("title:=Choose a Type of Schedule").JavaCheckBox("attached text:=Prorate based on Facility Repayment Schedule")'
LIQ_RepaymentSchedule_ScheduleType_OK_Button = 'JavaWindow("title:=Choose a Type of Schedule").JavaButton("attached text:=OK")'
LIQ_RepaymentSchedule_NonBusDayRule_Dropdown = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaList("tagname:=Combo")'
LIQ_RepaymentSchedule_CurrentSchedule_POBM_Text = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaObject("tagname:=Group", "text:=Current Schedule - Principal Only with Bullet at Maturity")'
LIQ_RepaymentSchedule_CurrentSchedule_PrincipalOnly_Text = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaObject("tagname:=Group", "text:=Current Schedule - Principal Only")'
LIQ_RepaymentSchedule_CurrentSchedule_List = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Nominal Amount:")'
LIQ_RepaymentSchedule_JavaTree = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Resync. Settings:")'
LIQ_RepaymentSchedule_Save_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Save")'
LIQ_RepaymentSchedule_Exit_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Exit")'
LIQ_RepaymentSchedule_AddUnschTran_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Add Unsch. Tran.")'
LIQ_RepaymentSchedule_TransactionNB_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Transaction NB")'
LIQ_RepaymentSchedule_CreatePendingTran_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Create Pending Tran.")'
LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("index:=0")'
LIQ_RepaymentSchedule_CurrentSchedule_Resync_Javatree = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Resync. Settings:")'
LIQ_RepaymentSchedule_CurrentSchedule_Javatree = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("labeled_containers_path:=.*Current Schedule.*")'
LIQ_AddTransaction_Window = 'JavaWindow("title:=Add Transaction")'
LIQ_AddTransaction_Principal_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Principal:")'
LIQ_AddTransaction_EffectiveDate_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_AddTransaction_ApplyPrincipalToNextSchedPayment_RadioButton = 'JavaWindow("title:=Add Transaction").JavaRadioButton("attached text:=Apply Principal To Next Scheduled Payment")'
LIQ_AddTransaction_OK_Button = 'JavaWindow("title:=Add Transaction").JavaButton("attached text:=OK")'

LIQ_AutomaticScheduleSetup_NumberOfCycles_Textfield = 'JavaWindow("title:=Automatic Schedule Setup - Principal Only").JavaEdit("attached text:=No. Cyc. Items:")'
LIQ_AutomaticScheduleSetup_Principal_OK_Button = 'JavaWindow("title:=Automatic Schedule Setup.*","displayed:=1").JavaButton("attached text:=OK")'

# ####Loan Notebook  - General Tab####
# LIQ_Loan_Window = 'JavaWindow("title:=.*Loan.*Active")'
# LIQ_Loan_Options_Payment = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Payment")'
# LIQ_Loan_ChoosePayment_Window = 'JavaWindow("title:=Choose a Payment")'
# LIQ_Loan_ChoosePayment_InterestPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Interest Payment")'
# LIQ_Loan_ChoosePayment_PaperClipPayment_RadioButton = 'JavaWindow("title:=Choose a Payment").JavaRadioButton("attached text:=Paper Clip Payment")'
# LIQ_Loan_ChoosePayment_OK_Button = 'JavaWindow("title:=Choose a Payment").JavaButton("attached text:=OK")'
# LIQ_Loan_CyclesforLoan_Window = 'JavaWindow("title:=Cycles for Loan.*")'
# LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=Projected Due")'
# LIQ_Loan_CyclesforLoan_List = 'JavaWindow("title:=Cycles for Loan.*").JavaTree("attached text:=Choose a cycle to make a payment against")'
# LIQ_Loan_CyclesforLoan_OK_Button = 'JavaWindow("title:=Cycles for Loan.*", "displayed:=1").JavaButton("attached text:=OK")'
# 
# LIQ_Loan_GlobalOriginal_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Global Original:")'
# LIQ_Loan_GlobalCurrent_Amount = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Global Current:")'
# LIQ_Loan_IntCycleFreq_Dropdownlist = 'JavaWindow("title:=.*Loan.*Active").JavaList("attached text:=Int. Cycle Freq:")'
# LIQ_Loan_AccrualTab_Cycles_Table = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Cycles:")'
# LIQ_Loan_GeneralTab_AdjustedDueDate_Textfield = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Adjusted Due Date:")'
# LIQ_Loan_GeneralTab_RateSettingDueDate_Textfield = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=Rate Setting Due Date:")'
# LIQ_Loan_Options_RepaymentSchedule = 'JavaWindow("title:=.*Loan.*Active").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")'
# LIQ_Loan_InquiryMode_Button = 'JavaWindow("title:=.*Loan.*Active").JavaButton("attached text:=Notebook in Inquiry Mode - F7")'    
# LIQ_Loan_UpdateMode_Button = 'JavaWindow("title:=.*Loan.*Active").JavaButton("attached text:=Notebook in Update Mode - F7")'
# ####Loan Notebook - Rate Tab#####
# LIQ_Loan_AllInRate = 'JavaWindow("title:=.*Loan.*Active").JavaEdit("attached text:=All-In Rate:")'
# LIQ_Loan_RateBasis_Dropdownlist = 'JavaWindow("title:=.*Loan.*Active").JavaObject("tagname:=Group", "text:=Interest Rates").JavaList("attached text:=Rate Basis:")'
# 
# ###Loan Notebook - Events Tab####
# LIQ_Loan_Events_List = 'JavaWindow("title:=.*Loan.*Active").JavaTree("attached text:=Select event to view details")'
# 
# ###Loan Notebook - GL Entries###
# LIQ_PrincipalPayment_GLEntries_Window = 'JavaWindow("title:=GL Entries For.*Principal Payment")'
# LIQ_PrincipalPayment_GLEntries_Table = 'JavaWindow("title:=GL Entries For.*Principal Payment").JavaTree("attached text:=Drill down to view details")'
# LIQ_PrincipalPayment_GLEntries_Exit_Button = 'JavaWindow("title:=GL Entries For.*Principal Payment").JavaButton("attached text:=Exit")'  
# 
# ###Loan Notebook - Currency Tab####
# LIQ_Loan_Currency_FXRateAUDtoUSD = 'JavaWindow("title:=.*Loan.*Active").JavaObject("text:=F.*X Rate").JavaStaticText("to_class:=JavaStaticText","index:=0")'
# LIQ_Loan_Currency_Textbox = 'JavaWindow("title:=Facility Currency.*").JavaEdit("attached text:=AUD to USD Rate:")'
# 
# ###Inactive Loan Window####
# LIQ_InactiveLoan_Window = 'JavaWindow("title:=.*Loan.*Inactive")'
# LIQ_InactiveLoan_Tab = 'JavaWindow("title:=.*Loan.*Inactive").JavaTab("tagname:=TabFolder")'
# 
###Repayment Schedule Window###
LIQ_RepaymentSchedule_Options_Reschedule = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaMenu("label:=Options").JavaMenu("label:=Reschedule")'
LIQ_RepaymentSchedule_ChooseScheduleType_Window = 'JavaWindow("title:=Choose a Type of Schedule")'
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
LIQ_RepaymentSchedule_CurrentSchedule_List = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaTree("attached text:=Nominal Amount:")'
LIQ_RepaymentSchedule_Save_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Save")'
LIQ_RepaymentSchedule_Exit_Button = 'JavaWindow("title:=Repayment Schedule For Loan.*").JavaButton("attached text:=Exit")'
LIQ_RepaymentSchedule_AddUnschTran_Button = 'JavaWindow("title:=Repayment Schedule.*").JavaButton("attached text:=Add Unsch. Tran.")'
LIQ_AddTransaction_Window = 'JavaWindow("title:=Add Transaction")'
LIQ_AddTransaction_Principal_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Principal:")'
LIQ_AddTransaction_EffectiveDate_Textfield = 'JavaWindow("title:=Add Transaction").JavaEdit("attached text:=Effective Date:")'
LIQ_AddTransaction_ApplyPrincipalToNextSchedPayment_RadioButton = 'JavaWindow("title:=Add Transaction").JavaRadioButton("attached text:=Apply Principal To Next Scheduled Payment")'
LIQ_AddTransaction_OK_Button = 'JavaWindow("title:=Add Transaction").JavaButton("attached text:=OK")'
LIQ_RepaymentSchedule_ScheduleType_Cancel_Button = 'JavaWindow("title:=Choose a Type of Schedule").JavaButton("attached text:=Cancel")'
LIQ_AddTransaction_SelectInterestAccrual_Button = 'JavaWindow("title:=Add Transaction").JavaButton("label:=Select Interest Accrual Cycle")'
 
###Automatic Schedule Setup - Fixed Principal Plus Interest Due Window###
LIQ_AutomaticScheduleFPPID_Window = 'JavaWindow("title:=Automatic Schedule Setup - Fixed Principal Plus Interest Due")'
LIQ_AutomaticScheduleFPPID_Accept_Button = 'JavaWindow("title:=Automatic Schedule Setup - Fixed Principal Plus Interest Due").JavaButton("attached text:=Accept")'
LIQ_AutomaticScheduleFPPID_OK_Button = 'JavaWindow("title:=Automatic Schedule Setup - Fixed Principal Plus Interest Due").JavaButton("attached text:=OK")'

# ###Drawdown Window###
# LIQ_Drawdown_Window = 'JavaWindow("title:=.* Drawdown .*")'
# LIQ_Drawdown_WorkflowItems = 'JavaWindow("title:=.* Drawdown.*").JavaTree("attached text:=Drill down to perform Workflow item")'
# LIQ_Drawdown_Tab = 'JavaWindow("title:=.* Drawdown .*").JavaTab("tagname:=TabFolder")'
# LIQ_Drawdown_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows .* Drawdown.*").JavaButton("attached text:=OK")'
# LIQ_Payment_Options_ViewUpdateLenderShares = 'JavaWindow("title:=.* Payment.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'
# LIQ_Interest_Options_ViewUpdateLenderShares = 'JavaWindow("title:=.* Interest.*","displayed:=1").JavaMenu("label:=Options").JavaMenu("label:=View/Update Lender Shares")'
# LIQ_Payment_Cashflows_Window = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1")'
# LIQ_Payment_Cashflows_MarkSelectedItemForRelease_Button = 'JavaWindow("title:=Cashflows .* Payment.*").JavaButton("attached text:=Mark Selected Item For Release")'
# LIQ_Payment_Cashflows_OK_Button = 'JavaWindow("title:=Cashflows .* Payment.*","displayed:=1").JavaButton("attached text:=OK")'

### Pending Loan Notebook ###
LIQ_Loan_Pending_Window = 'JavaWindow("title:=.*Loan.*Pending")'
LIQ_Loan_Pending_Tab = 'JavaWindow("title:=.*Loan.*Pending").JavaTab("tagname:=TabFolder")'
LIQ_Loan_Pending_Accrual_JavaTree = 'JavaWindow("title:=.*Loan.*Pending").JavaTree("attached text:=Cycles:")'

### Accrual Cycle Detail ###
LIQ_AccrualCycleDetail_Window = 'JavaWindow("title:=Accrual Cycle Detail")'
LIQ_AccrualCycleDetail_PaidToDate_Field = 'JavaWindow("title:=Accrual Cycle Detail").JavaEdit("index:=6")'
LIQ_AccrualCycleDetail_AccruedToDate_Field = 'JavaWindow("title:=Accrual Cycle Detail").JavaEdit("attached text:=Accrued to date:")'
LIQ_AccrualCycleDetail_ProjectedEOCAccrual_Field = 'JavaWindow("title:=Accrual Cycle Detail").JavaEdit("attached text:=Projected EOC accrual:")'
LIQ_AccrualCycleDetail_CycleDue_Field = 'JavaWindow("title:=Accrual Cycle Detail").JavaEdit("attached text:=Cycle due:")'
LIQ_AccrualCycleDetail_LineItems_Button = 'JavaWindow("title:=Accrual Cycle Detail").JavaButton("attached text:=Line Items")'

###Line Items for###
LIQ_LineItemsFor_Window = 'JavaWindow("title:=Line Items for .*")'
LIQ_LineItemsFor_JavaTree = 'JavaWindow("title:=Line Items for .*").JavaTree("displayed:=1")'

### Generic Loan Notebook ###
LIQ_Loan_Generic_Window = 'JavaWindow("title:=.*Loan.*/.*")'
LIQ_Loan_Generic_Options_RepaymentSchedule = 'JavaWindow("title:=.*Loan.*${LoanNotebook_Status}.*").JavaMenu("label:=Options").JavaMenu("label:=Repayment Schedule")'
LIQ_Loan_Generic_IntCycleFreq_Dropdownlist = 'JavaWindow("title:=.*Loan.*${LoanNotebook_Status}.*").JavaList("attached text:=Int. Cycle Freq:")'

### Comments Tab ###
LIQ_LoanNotebook_CommentsTab_JavaTree = 'JavaWindow("label:=.*Loan.*ctive").JavaTree("tagname:=Comments")'
LIQ_LoanNotebook_CommentsTab_Add_Button = 'JavaWindow("title:=.*Loan.*ctive").JavaButton("label:=Add.*")'
LIQ_LoanNotebook_CommentEdit_Window = 'JavaWindow("title:=Comment Edit")'
LIQ_LoanNotebook_CommentEdit_CreatedOn_Textbox = 'JavaWindow("title:=Comment Edit").JavaEdit("attached text:=Created on:")'
LIQ_LoanNotebook_CommentEdit_CreatedBy_Textbox = 'JavaWindow("title:=Comment Edit").JavaEdit("attached text:=by:","Index:=0")'
LIQ_LoanNotebook_CommentEdit_ModifiedOn_Textbox = 'JavaWindow("title:=Comment Edit").JavaEdit("attached text:=Modified on:")'
LIQ_LoanNotebook_CommentEdit_ModifiedBy_Textbox = 'JavaWindow("title:=Comment Edit").JavaEdit("attached text:=by:","Index:=1")'
LIQ_LoanNotebook_CommentEdit_Subject_Textbox = 'JavaWindow("title:=Comment Edit").JavaEdit("attached text:=Subject:")'
LIQ_LoanNotebook_CommentEdit_Comment_Textbox = 'JavaWindow("title:=Comment Edit").JavaEdit("attached text:=Comment:")'
LIQ_LoanNotebook_CommentEdit_OK_Button = 'JavaWindow("title:=Comment Edit").JavaButton("attached text:=OK")'
LIQ_LoanNotebook_CommentEdit_Cancel_Button = 'JavaWindow("title:=Comment Edit").JavaButton("attached text:=Cancel")'
LIQ_LoanNotebook_CommentEdit_Delete_Button = 'JavaWindow("title:=Comment Edit").JavaButton("attached text:=Delete")'

### Alerts ###
LIQ_LoanNotebook_AlertManagementScreen_Window = 'JavaWindow("title:=Alert Management Screen")'
LIQ_LoanNotebook_AlertManagementScreen_JavaTree = 'JavaWindow("title:=Alert Management Screen").JavaTree("labeled_containers_path:=Group:Customer/Deal/Facility/Outstanding;")'
LIQ_LoanNotebook_AlertManagementScreen_Alerts_JavaList = 'JavaWindow("title:=Alert Management Screen").JavaList("labeled_containers_path:=Group:Alerts;")'
LIQ_LoanNotebook_AlertManagementScreen_Create_Button = 'JavaWindow("label:=Alert Management Screen").JavaButton("attached text:=Create")'
LIQ_LoanNotebook_AlertManagementScreen_ChooseAnEntity_Customer_RadioButton = 'JavaWindow("title:=Choose an Entity").JavaRadioButton("attached text:=Customer")'
LIQ_LoanNotebook_AlertManagementScreen_ChooseAnEntity_Deal_RadioButton = 'JavaWindow("title:=Choose an Entity").JavaRadioButton("attached text:=Deal")'
LIQ_LoanNotebook_AlertManagementScreen_ChooseAnEntity_Facility_RadioButton = 'JavaWindow("title:=Choose an Entity").JavaRadioButton("attached text:=Facility")'
LIQ_LoanNotebook_AlertManagementScreen_ChooseAnEntity_Outstanding_RadioButton = 'JavaWindow("title:=Choose an Entity").JavaRadioButton("attached text:=Outstanding")'
LIQ_LoanNotebook_AlertManagementScreen_ChooseAnEntity_OK_Button = 'JavaWindow("title:=Choose an Entity").JavaButton("attached text:=OK")'
LIQ_LoanNotebook_AlertManagementScreen_FacilitySelect_Window = 'JavaWindow("title:=Facility Select")'
LIQ_LoanNotebook_AlertManagementScreen_FacilitySelect_Deal_Textbox = 'JavaWindow("title:=Facility Select").JavaEdit("index:=0")'
LIQ_LoanNotebook_AlertManagementScreen_FacilitySelect_IdentifyByValue_Textbox = 'JavaWindow("title:=Facility Select").JavaEdit("index:=1")'
LIQ_LoanNotebook_AlertManagementScreen_FacilitySelect_OK_Button = 'JavaWindow("title:=Facility Select").JavaButton("attached text:=OK")'
LIQ_LoanNotebook_AlertManagementScreen_FacilitySelect_Search_Button = 'JavaWindow("title:=Facility Select").JavaButton("attached text:=Search")'
LIQ_LoanNotebook_AlertManagementScreen_FacilityListByName_OK_Button = 'JavaWindow("text:=Facility Select").JavaWindow("text:=Facility List By Name").JavaButton("attached text:=OK")'
LIQ_LoanNotebook_AlertManagementScreen_AlertEditor_Window = 'JavaWindow("title:=Alert Editor")'
LIQ_LoanNotebook_AlertManagementScreen_AlertEditor_ShortDescription_Textbox = 'JavaWindow("title:=Alert Editor").JavaEdit("attached text:=Short Description:")'
LIQ_LoanNotebook_AlertManagementScreen_AlertEditor_Details_Textbox = 'JavaWindow("title:=Alert Editor").JavaEdit("attached text:=Details:")'
LIQ_LoanNotebook_AlertManagementScreen_AlertEditor_OK_Button = 'JavaWindow("title:=Alert Editor").JavaButton("attached text:=OK")'