*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create Comprehensive Repricing for Agency Syndicated Deal for DNR
    [Documentation]    This keyword is use to add comprehensive repricing for the specified Loan
    ...    @author: makcamps 04DEC2020    - Initial create
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
    Write Data To Excel    SC2_ComprehensiveRepricing    New_Loan_Alias    ${rowid}    ${NewLoanAlias}    ${DNR_DATASET}

    ###Add Principal Payment###
    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_RequestedAmount]

    ###Add Interest Payment###
    Add Interest Payment for Loan Repricing

    ###Write DDA Description for Report Validation###
    Write Data To Excel    SC2_ComprehensiveRepricing    DDATransactionDesc    ${rowid}    Interest & Principal    ${DNR_DATASET}
    Write Data To Excel    AHBDE    DDA_Transaction_Description    ${rowid}    Interest & Principal    ${DNR_DATASET}    
    ${IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_LoanRepricing_Released_Window}    VerificationData="Yes"
    ${BusinessTransactionDescription}    Run Keyword If    ${IsDisplayed}==${True}    Set Variable    Loan Repricing
    
    ###Create Cashflow###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    Create Cashflows
    
    ##Get Host Bank Cash Net and Write to Excel for Report Validation###
    ${HostBankCashNet}    Mx LoanIQ Get Data    ${LIQ_LoanRepricing_Cashflow_HostBankShare_Value}    HostBankCashNet
    ${HostBankCashNet}    Remove String    ${HostBankCashNet}    \ \ &{ExcelPath}[Loan_Currency]
    ${HostBankCashNet}    Remove Comma and Convert To Number    ${HostBankCashNet}
    Write Data To Excel    SC2_ComprehensiveRepricing    HostBankCashNet    ${rowid}    ${HostBankCashNet}    ${DNR_DATASET}
    Write Data To Excel    AHBDE    HostBankCashNet    ${rowid}    ${HostBankCashNet}    ${DNR_DATASET}
    
    ### Get Cashflow Direction and Write to Excel for Report Validation ###
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    &{ExcelPath}[Cashflow_Direction]%d
    ${WindowIsDisplayed}    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Details for Cashflow from &{ExcelPath}[Borrower_ShortName].*", "displayed:=1")    VerificationData="Yes"
    Run Keyword If    ${WindowIsDisplayed}==${True}    Write Data To Excel    AHBDE    Cashflow_Direction    ${rowid}    FROM    ${DNR_DATASET}
    mx LoanIQ click element if present    ${LIQ_Cashflows_DetailsforCashflow_Exit_Button}

    ###Verify Remittance Instructions###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Set All Items to Do It

    ###GL Entries###
    Navigate to GL Entries from Loan Rerpricing Notebook
    Close GL Entries and Cashflow Window
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Loan Approval/Send Rate Approval ###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Approve Loan Repricing
    Send to Rate Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Rate Approval###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}
    
    ###Release###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]    sNavigateToWorkflow=${LOAN_REPRICING}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    ###Get System Date and Write to Excel###
    ${RepricedLoan_Date}    Get System Date
    Write Data To Excel    SC2_ComprehensiveRepricing    Effective_Date    ${rowid}    ${RepricedLoan_Date}    ${DNR_DATASET}
    
    ###Get Loan Repricing Code and Write to Excel for Report Validation###
    ${BusinessTransactionCode}    Get Business Transaction Code from Table Maintenance    ${BusinessTransactionDescription}
    Write Data To Excel    SC2_ComprehensiveRepricing    Transaction_Code    ${rowid}    ${BusinessTransactionCode}    ${DNR_DATASET}
    Write Data To Excel    AHBDE    Transaction_Code    ${rowid}    ${BusinessTransactionCode}    ${DNR_DATASET}
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Create Comprehensive Repricing for Non Agency Bilateral Deal for DNR
    [Documentation]    This keyword is use to add comprehensive repricing for the specified Loan
    ...    @author: fluberio    11DEC2020    - Initial create
    [Arguments]    ${ExcelPath} 

    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    ${Borrower_ShortName}    Read Data From Excel    SC1_DealSetup    Borrower1_ShortName    &{ExcelPath}[rowid]    ${DNR_DATASET}
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    &{ExcelPath}[FundingRate_Alias]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Currency1]
    ${ExchangeRate}    Get Currency Exchange Rate from Treasury Navigation    ${AUD_TO_USD}        
	${baseRateCode}    Read Data From Excel    SC1_ComprehensiveRepricing    Pricing_Option    &{ExcelPath}[rowid]    ${DNR_DATASET}  
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Outstanding Select Window###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    
    ###Existing Loans for Deal Window###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]  
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]

    ###Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_RequestedAmount]
    Write Data To Excel    SC1_ComprehensiveRepricing    New_Loan_Alias    ${rowid}    ${NewLoanAlias}    ${DNR_DATASET}

    ###Add Principal Payment###
    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_RequestedAmount]

    ###Add Interest Payment###
    Setup Repricing    &{ExcelPath}[Repricing_Add_Option_Setup_2]    ${BaseRatePercentage}    ${baseRateCode}    &{ExcelPath}[LoanAmount_2]    &{ExcelPath}[Repricing_Frequency]    ${Y}    ${ADD_LOAN_REPRICING}

    
    ###Create Cashflow###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    Create Cashflows

    ###Verify Remittance Instructions###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Set All Items to Do It
    
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower_ShortName}

    ###GL Entries###
    Navigate to GL Entries from Loan Rerpricing Notebook
    Close GL Entries and Cashflow Window
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Loan Approval/Send Rate Approval ###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Approve Loan Repricing
    Send to Rate Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Rate Approval###
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_STATUS}
    
    ###Release###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]    sNavigateToWorkflow=${LOAN_REPRICING}
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    ###Get System Date and Write to Excel###
    ${RepricedLoan_Date}    Get System Date
    Write Data To Excel    SC1_ComprehensiveRepricing    Transaction_Date    ${rowid}    ${RepricedLoan_Date}    ${DNR_DATASET}
    Write Data To Excel    SC1_ComprehensiveRepricing    Cashflow_Amount    &{ExcelPath}[rowid]    ${BorrowerTranAmount}    ${DNR_DATASET}
    Write Data To Excel    SC1_ComprehensiveRepricing    Transaction_Status    &{ExcelPath}[rowid]    ${RELEASE_STATUS}    ${DNR_DATASET}
    
    ###LIQ Window###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}