### Existing Loans for Facility
LIQ_ExistingLoansForFacility_Window = 'JavaWindow("title:=Existing Loans For Facility.*")'
LIQ_ExistingLoansForFacility_JavaTree = 'JavaWindow("title:=Existing Loans For Facility.*").JavaTree("tagname:=Drill down to.*")'
LIQ_ExistingLoansForFacility_CreateRepricing_Button = 'JavaWindow("title:=Existing Loans For Facility.*").JavaButton("label:=Create Repricing")'

### Create Repricing
LIQ_CreateRepricing_Window = 'JavaWindow("title:=Create Repricing.*")'
LIQ_CreateRepricing_QuickRepricing_RadioButton = 'JavaWindow("title:=Create Repricing.*").JavaRadioButton("label:=Quick Repricing")'
LIQ_CreateRepricing_ComprehensiveRepricing_RadioButton = 'JavaWindow("title:=Create Repricing.*").JavaRadioButton("label:=Comprehensive Repricing")'
LIQ_CreateRepricing_Ok_Button = 'JavaWindow("title:=Create Repricing.*").JavaButton("label:=OK")'

### Loan Repricing for Deal Window
LIQ_LoanRepricingForDeal_Window = 'JavaWindow("title:=Loan Repricing for Deal.*")'
LIQ_LoanRepricingForDeal_Tab = 'JavaWindow("title:=Loan Repricing For Deal:.*").JavaTab("tagname:=TabFolder")'
LIQ_LoanRepricingForDeal_JavaTree = 'JavaWindow("title:=Loan Repricing for Deal.*").JavaTree("tagname:=Select one or more.*")'
LIQ_LoanRepricingForDeal_WorkFlowAction = 'JavaWindow("title:=Loan Repricing For Deal:.*").JavaTree("tagname:=Drill down to perform Workflow item")'
LIQ_LoanRepricingForDeal_OK_Button = 'JavaWindow("title:=Loan Repricing for Deal.*").JavaButton("label:=OK")'

### Confirmation Window

LIQ_LoanRepricing_ConfirmationWindow_Yes_Button = 'JavaWindow("title:=Loan Repricing For Deal.*").JavaWindow("title:=Confirmation").JavaButton("label:=Yes")'
LIQ_LoanRepricing_Confirmation_Window = 'JavaWindow("title:=Question")'

### Repricing Detail Add Options
LIQ_RepricingDetail_Window = 'JavaWindow("title:=Repricing Detail.*")'
LIQ_RepricingDetail_RolloverNew_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Rollover/Conversion to New:")'
LIQ_RepricingDetail_RolloverExisting_Dropdown = 'JavaWindow("title:=Repricing Detail.*").JavaList("index:=0")'
LIQ_RepricingDetail_RolloverExisting_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Rollover/Conversion to Existing:")'
LIQ_RepricingDetail_Principal_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Principal Payment")'
LIQ_RepricingDetail_Interest_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Interest Payment")'
LIQ_RepricingDetail_AutoGenerateInvidualRepayment_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Auto Generate Individual Repayment")'
LIQ_RepricingDetail_AutoGenerateInterestPayment_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Auto Generate Interest Payment.*")'
LIQ_RepricingDetail_ScheduledItems_RadioButton = 'JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=Scheduled Items")'
LIQ_RepricingDetail_OK_Button = 'JavaWindow("title:=Repricing Detail.*").JavaButton("label:=OK")'
LIQ_RepricingDetail_Facility = 'JavaWindow("title:=Repricing Detail.*").JavaList("attached text:=Facility:")'
LIQ_RepricingDetail_Borrower = 'JavaWindow("title:=Repricing Detail.*").JavaList("attached text:=Borrower:")'
LIQ_RepricingDetail_PricingOption = 'JavaWindow("title:=Repricing Detail.*").JavaList("index:=0")'

### MAIN Loan Repricing Notebook Window
LIQ_LoanRepricingForDealAdd_JavaTree = 'JavaWindow("title:=Loan Repricing.*").JavaTree("tagname:=Drill down to view.*")'
LIQ_LoanRepricingForDeal_Workflow_JavaTree = 'JavaWindow("title:=Loan Repricing.*").JavaTree("tagname:=Drill down to view.*")'
LIQ_LoanRepricingForDeal_Workflow_Tab = 'JavaWindow("title:=Loan Repricing.*").JavaTab("tagname:=TabFolder")'
LIQ_LoanRepricingForDeal_Add_Button = 'JavaWindow("title:=Loan Repricing.*").JavaButton("attached text:=Add")'
LIQ_LoanRepricingForDeal_Events_JavaTree = 'JavaWindow("title:=Loan Repricing.*").JavaTree("labeled_containers_path:=Tab:Events;")'

LIQ_LoanRepricing_Window = 'JavaWindow("title:=Loan Repricing.*")'
LIQ_LoanRepricing_Tab = 'JavaWindow("title:=Loan Repricing.*").JavaTab("tagname:=TabFolder")'
LIQ_LoanRepricing_WorkflowItems = 'JavaWindow("title:=Loan Repricing.*").JavaTree("attached text:=Drill down to perform Workflow item")'
LIQ_LoanRepricing_WorkflowNoItems = 'JavaWindow("title:=Loan Repricing.*").JavaTree("attached text:=Drill down to perform Workflow item","items count:=0")'
LIQ_LoanRepricing_ChangeEffectiveDate_Menu = 'JavaWindow("title:=Loan Repricing.*").JavaMenu("label:=Options").JavaMenu("label:=Change Effective Date")'
LIQ_LoanRepricing_Facility_Menu = 'JavaWindow("title:=Loan Repricing.*").JavaMenu("label:=Options").JavaMenu("label:=Facility Notebook")'
LIQ_LoanRepricing_EffectiveDate_Text = 'JavaWindow("title:=Loan Repricing.*").JavaStaticText("index:=2")'
LIQ_LoanRepricing_GeneralTab_Description_JavaTree = 'JavaWindow("label:=Loan Repricing For Deal.*").JavaTree("tagname:=Drill down to view/edit details")'

LIQ_LoanRepricing_Released_Window = 'JavaWindow("title:=Loan Repricing.*Released.*")'
LIQ_LoanRepricing_Options_Cashflow = 'JavaWindow("title:=Loan Repricing.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'

### Loan Repricing Notebook - Enter New Effective Date
LIQ_EffectiveDate_TextBox = 'JavaWindow("title:=Enter New Effective Date","displayed:=1").JavaEdit("tagname:=Text")'
LIQ_EffectiveDate_Ok_Button = 'JavaWindow("title:=Enter New Effective Date","displayed:=1").JavaButton("attached text:=OK")'
LIQ_EffectiveDate_Cancel_Button = 'JavaWindow("title:=Enter New Effective Date","displayed:=1").JavaButton("attached text:=Cancel")'

### Loan Repricing Notebook - General Tab
LIQ_LoanRepricing_Add_Button = 'JavaWindow("title:=Loan Repricing.*").JavaButton("attached text:=Add")'
LIQ_LoanRepricing_AutoReduceFacility_Checkbox = 'JavaWindow("title:=Loan Repricing.*").JavaCheckBox("attached text:=Auto Reduce Facility")'
LIQ_LoanRepricing_Outstanding_List = 'JavaWindow("title:=Loan Repricing.*").JavaTree("attached text:=Drill down to view/edit details")'
LIQ_LoanRepricing_EffectiveDate_StaticText = 'JavaWindow("title:=Loan Repricing.*").JavaStaticText("index:=2")'

###Repricing Detail Add Options###
LIQ_RepricingDetailAddOptions_Window = 'JavaWindow("title:=Repricing Detail Add Options")'
LIQ_RepricingDetailAddOptions_InterestPayment_RadioButton = 'JavaWindow("title:=Repricing Detail Add Options").JavaRadioButton("attached text:=Interest Payment")'
LIQ_RepricingDetailAddOptions_RolloverConversionToNew_RadioButton = 'JavaWindow("title:=Repricing Detail Add Options").JavaRadioButton("attached text:=Rollover/Conversion to New.*")'
#LIQ_RepricingDetailAddOptions_RolloverConversionToExisting_RadioButton = 'JavaWindow("title:=Repricing Detail Add Options").JavaRadioButton("attached text:=Rollover/Conversion to Existing.*")'
LIQ_RepricingDetailAddOptions_Ok_Button = 'JavaWindow("title:=Repricing Detail Add Options").JavaButton("attached text:=OK")'
LIQ_RepricingDetailAddOptions_PricingOption_Dropdown = 'JavaWindow("title:=Repricing Detail Add Options").JavaList("x:=322","y:=30")'

###Cycles for Loan Window###
LIQ_CyclesForLoan_ProjectedDue_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=Projected Due")'
LIQ_CyclesForLoan_LenderSharesPrepayCycle_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=Lender Shares \(Prepay Cycle\)")'
LIQ_CyclesForLoan_CycleDue_RadioButton = 'JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=Cycle Due")'
LIQ_CyclesForLoan_Ok_Button = 'JavaWindow("title:=Cycles for Loan.*").JavaButton("attached text:=OK")'
LIQ_CyclesForLoan_forPaymentAmount_Text = 'JavaWindow("title:=Cycles for Loan.*").JavaEdit("attached text:=for Payment Amount:")'
LIQ_CyclesForLoan_Interest_Text = 'JavaWindow("title:=Cycles for Loan.*").JavaEdit("attached text:=Interest Due:")'

###Interest Payment Notebook###
LIQ_InterestPayment_FileExit_Menu = 'JavaWindow("title:=.* Interest Payment.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_LoanRepricingCashflow_Window = 'JavaWindow("title:=Cashflows For Loan Repricing.*")'
LIQ_LoanRepricing_Cashflows_DetailsforCashflow_Window = 'JavaWindow("title:=Details for Cashflow.*")'
LIQ_LoanRepricing_Cashflows_DetailsforCashflow_SelectRI_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=Select Remittance Instructions")'
LIQ_LoanRepricing_Cashflows_ChooseRemittance_Window = 'JavaWindow("title:=Choose Remittance Instructions")'
LIQ_LoanRepricing_Cashflows_ChooseRemittance_List = 'JavaWindow("title:=Choose Remittance Instructions").JavaTree("attached text:=Drill down to view details")'
LIQ_LoanRepricing_Cashflows_ChooseRemittance_OK_Button = 'JavaWindow("title:=Choose Remittance Instructions").JavaButton("attached text:=OK")'
LIQ_LoanRepricing_Cashflows_DetailsforCashflow_OK_Button = 'JavaWindow("title:=Details for Cashflow.*").JavaButton("attached text:=OK")'
LIQ_LoanRepricing_CashflowsForLoan_OK_Button = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaButton("attached text:=OK")'
LIQ_LoanRepricing_Cashflows_List = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaTree("attached text:=Drill down to view/change details")'
LIQ_LoanRepricing_Cashflows_DoIt_Button = 'JavaWindow("title:=Cashflows For Loan Repricing.*").JavaButton("label:=Set Selected Item To .*")'
LIQ_LoanRepricing_CashFlows_Menu= 'JavaWindow("title:=Loan Repricing.*").JavaMenu("label:=Options").JavaMenu("label:=Cashflow")'
LIQ_LoanRepricing_GLEntries_Menu= 'JavaWindow("title:=Loan Repricing.*").JavaMenu("label:=Queries").JavaMenu("label:=GL Entries")'
LIQ_LoanRepricing_Events_Tab_JavaTree = 'JavaWindow("title:=Loan Repricing.*").JavaTree("attached text:=Select event to view details")'

###Conversion from FIXED NoteBook###
LIQ_ConversionFromFIXED_Notebook = 'JavaWindow("title:=.*Conversion from FIXED.*")'
LIQ_ConversionFromFIXED_RequestedAmount_TextField = 'JavaWindow("title:=.*Conversion from FIXED.*").JavaEdit("attached text:=Requested:")'
LIQ_ConversionFromFIXED_File_Save = 'JavaWindow("title:=.*Conversion from FIXED.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_ConversionFromFIXED_File_Exit = 'JavaWindow("title:=.*Conversion from FIXED.*").JavaMenu("label:=File").JavaMenu("label:=Exit")'
LIQ_IncludeScheduledPayments_Ok_Button = 'JavaWindow("title:=Include scheduled payments.*","displayed:=1").JavaButton("attached text:=Yes")'
LIQ_ConversionFromFIXED_ModifyRequestedAmt_Menu = 'JavaWindow("title:=.*Conversion from FIXED.*").JavaMenu("label:=Options").JavaMenu("label:=Modify Requested Amount")'
LIQ_ConversionFromFIXED_NewRequestedAmount_Textfield = 'JavaWindow("title:=.*Conversion from FIXED.*").JavaWindow("title:=Update Requested Amount").JavaEdit("tagname:=Text")'
LIQ_ConversionFromFIXED_Ok_Button = 'JavaWindow("title:=.*Conversion from FIXED.*").JavaWindow("title:=Update Requested Amount").JavaButton("attached text:=OK")'

###Quick Repricing###
LIQ_LoanRepricing_QuickRepricing_ReqChangeAmount_Textfield = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaEdit("attached text:=Req\. Change Amount.*")'
LIQ_LoanRepricing_QuickRepricing_Window = 'JavaWindow("title:=.*Quick Repricing For Alias.*")'
LIQ_LoanRepricing_QuickRepricing_Save_Menu = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaMenu("label:=File").JavaMenu("label:=Save")'
LIQ_LoanRepricing_QuickRepricing_Tab = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaTab("tagname:=TabFolder")'
LIQ_LoanRepricing_QuickRepricing_BaseRate_Button = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaTab("text:=Rates").JavaButton("attached text:=Base Rate:")'
LIQ_LoanRepricing_QuickRepricingForDeal_Workflow_JavaTree = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaTree("tagname:=Drill down to view.*")'
LIQ_LoanRepricing_QuickRepricing_Alias_Textfield = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaStaticText("x:=160","y:=151")'
LIQ_LoanRepricing_QuickRepricing_EffectiveDate_Textfield = 'JavaWindow("title:=.*Quick Repricing For Alias.*").JavaEdit("attached text:=Effective Date.*")'
 