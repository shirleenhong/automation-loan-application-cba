*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Comprehensive Repricing for Syndicated Deal
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for Syndicated deal using Auto-Gen Repricing
    ...    @author: ritragel
    ...    @update: jdelacru    - 05MAR2019    - Deleted high level for Comprehensive Repricing for Scenario 5
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
    Add Repricing Detail    &{ExcelPath}[Repricing_Add_Option]    ${rowid}    &{ExcelPath}[Pricing_Option]
    ###Add Interest Payment for Loan Repricing
    
    ###Cashflows Notebook - Create Cashflows###
    Navigate to Create Cashflow for Loan Repricing
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
    
    ### GL Entries
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    # mx LoanIQ click    ${LIQ_Cashflows_OK_Button}
    
   ###Repricing Notebook - Setup Repricing###  
    ${NewLoanAlias}    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Rollover_Amount]    &{ExcelPath}[Repricing_Frequency]
      
    ${SysDate}    Get System Date
    ${AdjustedDueDate}    Add Days to Date    ${SysDate}    &{ExcelPath}[Days]
    Write Data To Excel    SERV08_ComprehensiveRepricing    Loan_Alias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Write Data To Excel    SERV21_InterestPayments    Loan_Alias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV40_BreakFunding    Loan_Alias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    Loan_Alias    ${rowid}    ${NewLoanAlias}

    ###Creation of Repricing Schedule###
    Create Repayment Schedule - Loan Repricing
    Get Data from Automatic Schedule Setup
    Verify Select Fixed Payment Amount
    Navigate to Workflow and Review Repayment Schedule

    ###Cashflows - Create Cashflows###
    Navigate to Create Cashflow for Loan Repricing
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
    
    ### GL Entries
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
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
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}
    
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