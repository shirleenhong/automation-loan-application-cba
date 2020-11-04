*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Comprehensive Repricing for Syndicated Deal
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for Syndicated deal using Auto-Gen Repricing
    ...    @author: ritragel
    ...    @update: jdelacru    - 05MAR2019    - Deleted high level for Comprehensive Repricing for Scenario 5
    ...    @update: dfajardo    - 21AUG2020    - Updated Repricing testscripts includes only Principal Payments 
    ...    @update: dfajardo    - 14SEP2020    - Removed Hard coded variables
    ...                                        - Added release cashflow and remove creation fo repricing schedule
    ...                                        - Added interest payment on repricing     
    [Arguments]    ${ExcelPath}

    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Search for Existing Deal###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Search for Existing Outstanding###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    
    ###Select Loan to Reprice###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ###Repricing Notebook - Setup Repricing###  
    ${NewLoanAlias}    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Rollover_Amount]    &{ExcelPath}[Repricing_Frequency]
      
    ${SysDate}    Get System Date
    ${AdjustedDueDate}    Add Days to Date    ${SysDate}    &{ExcelPath}[Days]
    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoanAlias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Write Data To Excel    SERV21_InterestPayments    NewLoanAlias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV40_BreakFunding    NewLoanAlias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    NewLoanAlias    ${rowid}    ${NewLoanAlias}

    Add Repricing Detail    &{ExcelPath}[Repricing_Add_Option]    ${rowid}    &{ExcelPath}[Pricing_Option]
    Add Interest Payment for Loan Repricing
    
    ###Cashflows - Create Cashflows###
    Navigate to Create Cashflow for Loan Repricing
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct2] 
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    ${CREDIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    ${CREDIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    ${DEBIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${DEBIT_AMT_LABEL}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ##Loan Approval###
    Send Loan Repricing for Approval

    Close All Windows on LIQ
    ## LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
   
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work in process notebook###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}
    
    ##Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Cashflow_DataType]    ${LOAN_REPRICING}
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Cashflow_DataType]    ${LOAN_REPRICING}
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Cashflow_DataType]    ${LOAN_REPRICING}

    
    # ###Approve Rate Setting Notice###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
    

Create Comprehensive Repricing for Syndicated Deal - Secondary Sale
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for Syndicated deal using Auto-Gen Repricing
    ...    @author: ritragel
    ...    @udpate: jdelacru    05MAR2019    - (1) This is a new robot file created for repricing of Scenario 5 
    ...                                      - (2) Apply Coding Standards 
    ...                                      - (3) Deleted Cashflow Transactions
    ...    @update: dahijrara    3AUG2020    - remove hardcoded value for Loan request amount. 
    ...                                      - updated navigation to Loan Repricing Workflow and remove line for taking screenshot in business level keyword.
    [Arguments]    ${ExcelPath}
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Outstanding Select Window###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    
    ###Existing Loans for Deal Window###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]  
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]

    ###Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_RequestedAmount]
    Write Data To Excel    TRP002_SecondarySale    New_Loan_Alias    ${rowid}    ${NewLoanAlias}     
    Write Data To Excel    MTAM08_LoanShareAdjustment    Loan_Alias    ${rowid}    ${NewLoanAlias}
    Add Interest Payment for Loan Repricing
    Navigate to Loan Repricing Workflow and Proceed With Transaction    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_RemittanceDescription]    &{ExcelPath}[Lender1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]

    ### GL Entries
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    Navigate to Loan Repricing Workflow and Proceed With Transaction    Send to Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
   
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work in process notebook###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    Rate Approval
    
    ###Approve Rate Setting Notice###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    Release
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}


Create Quick Repricing for Syndicated Deal - Secondary Sale
    [Documentation]    This is a high-level keyword to Create Quick Repricing for Syndicated deal using Auto-Gen Repricing
    ...    @author: sahalder	01JUN2020    Initial Create
	[Arguments]    ${ExcelPath}
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Outstanding Select Window###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
	
	###Existing Loans for Deal Window###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]  
   	
	###Quick Repricing Notebook###
	${NewLoanAlias}    Add Changes for Quick Repricing    &{ExcelPath}[Base_Rate]    3500.00
	Write Data To Excel    TRP002_SecondarySale    New_Loan_Alias    ${rowid}    ${NewLoanAlias}     
    Write Data To Excel    MTAM08_LoanShareAdjustment    Loan_Alias    ${rowid}    ${NewLoanAlias}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanQuickRepricing-Add
	Navigate Notebook Workflow    ${LIQ_LoanRepricing_QuickRepricing_Window}    ${LIQ_LoanRepricing_QuickRepricing_Tab}    ${LIQ_LoanRepricing_QuickRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_RemittanceDescription]    &{ExcelPath}[Lender1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
	
	
	### GL Entries
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_QuickRepricing_Window}    ${LIQ_LoanRepricing_QuickRepricing_Tab}    ${LIQ_LoanRepricing_QuickRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Approval    Quick Repricing    &{ExcelPath}[Deal_Name]
   
    ### Rate Approval ###
    Approve Loan Repricing And Send to Rate Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work in process notebook###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Quick Repricing    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    
    ###Approve Rate Setting Notice###
    Navigate Notebook Workflow    ${LIQ_LoanRepricing_QuickRepricing_Window}    ${LIQ_LoanRepricing_QuickRepricing_Tab}    ${LIQ_LoanRepricing_QuickRepricingForDeal_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanQuickRepricing-Released
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create Comprehensive Repricing for RPA Scenario
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for RPA Scenario
    ...    @author: mcastro    03NOV2020    - Initial Create    
    [Arguments]    ${ExcelPath}

    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Search for Existing Deal###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Search for Existing Outstanding###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    
    ###Select Loan to Reprice###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]

    ###Repricing Notebook - Setup Repricing###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]
    ${Effective_Date}    ${Loan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Rollover_Amount]    &{ExcelPath}[Repricing_Frequency]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Repricing_Add_Option]    &{ExcelPath}[Rollover_Amount]  
    Add Interest Payment for Loan Repricing
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_TotalGlobalInterest]

    ###Cashflows - Create Cashflows###
    Navigate to Create Cashflow for Loan Repricing
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    
    ### GL Entries ###
    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ###Loan Approval###
    Send Loan Repricing for Approval
    Close All Windows on LIQ
    
    ### Loan Repricing: Approval and Send to Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]     &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Navigate to Loan Pending Tab and Proceed with the Transaction     ${LOAN_REPRICING_FOR_THE_DEAL} &{ExcelPath}[Deal_Name].
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Send to Rate Setting Approval
    Set Base Rate Details    &{ExcelPath}[Base_Rate]
    Send to Rate Approval

    ### Loan Repricing: Rate Approval, Release Cashflows and Release Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]     &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Navigate to Loan Pending Tab and Proceed with the Transaction     ${LOAN_REPRICING_FOR_THE_DEAL} &{ExcelPath}[Deal_Name].
    Close Facility Notebook and Navigator Windows
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}

    ### Release Loan Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    Close All Windows on LIQ

    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}