*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Drawdown D00000476
    [Arguments]    ${ExcelPath}
    
    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Deal Notebook###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Creation of Initial Loan Drawdown in Loan NoteBook###
    Navigate to Outstanding Select Window from Deal
    ${Loan_Alias}    Create Loan Outstanding    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]  
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword if    &{ExcelPath}[rowid] <= 5    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='5'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    4    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='4'    Write Data To Excel    SERV23_Paperclip    Loan_Alias    1    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    SERV23_Paperclip    Loan_Alias    2    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='4'    Write Data To Excel    SERV40_BreakFunding    Loan_Alias    1    ${Loan_Alias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='4'    Write Data To Excel    COM06_LoanMerge    Alias_Loan1    1    ${Loan_Alias}    ${CBAUAT_ExcelPath} 
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    COM06_LoanMerge    Alias_Loan2    1    ${Loan_Alias}    ${CBAUAT_ExcelPath}       
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}    
    Input General Loan Drawdown Details with Accrual End Date    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_MaturityDate]
    ...    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_RepricingDate]
    ...    None    None    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_AccrueEndDate]
  
    ###Accept Loan Drawdown Rates for Term Facility    &{ExcelPath}[Borrower_BaseRate]
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    Set Outstanding Servicing Group Details    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]

    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction] 
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}   ${ComputedHBTranAmount}
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release  
    
    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown
    Run Keyword If    '&{ExcelPath}[Loan_Currency]' == 'USD'    Set FX Rates Loan Drawdown    &{ExcelPath}[Loan_Currency]
    Run Keyword If    '&{ExcelPath}[Loan_Currency]' == 'GBP'    Set FX Rates Loan Drawdown    &{ExcelPath}[Loan_Currency]
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Rate Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Rate Approval
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Release Cashflows
    
    ###Release Drawdown###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    Release
    Close All Windows on LIQ
