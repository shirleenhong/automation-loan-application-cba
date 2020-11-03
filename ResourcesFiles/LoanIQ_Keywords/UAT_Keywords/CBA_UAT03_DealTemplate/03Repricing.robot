*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Initiate Comprehensive Repricing - D00000476
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing  with principal and interest payments with 2 cashflows
    [Arguments]    ${ExcelPath}
    
    ### Login
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ## Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ### Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    
    ...    &{ExcelPath}[Loan_NewOutstanding]    &{ExcelPath}[Repricing_Frequency]    None    &{ExcelPath}[Repricing_Date]
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    &{ExcelPath}[rowid]    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    1    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    3    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='2'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    2    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='8'    Write Data To Excel    SERV23_Paperclip    Loan_Alias    3    ${NewLoanAlias}    ${CBAUAT_ExcelPath}

    Run Keyword if    '&{ExcelPath}[rowid]'!='7'    Add Repricing Details    Interest Payment
    ${CycleAmount}    Run Keyword if    '&{ExcelPath}[rowid]'!='7'    Select Cycles for Loan Item    Projected Due    &{ExcelPath}[Cycle]
    Run Keyword if    '&{ExcelPath}[rowid]'!='7'    Verify Interest Payment    ${CycleAmount}    &{ExcelPath}[Payment_Effective_Date]
  
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows

    ## Remittance Instruction Addition per Cashflow ###
    Run Keyword If    '&{ExcelPath}[rowid]'!='3' and '&{ExcelPath}[rowid]'!='7'    Add Remittance Instructions    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Add Remittance Instructions    None    &{ExcelPath}[Borrower_RemittanceDescription]    ${CycleAmount}    &{ExcelPath}[Loan_Currency]
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Add Remittance Instructions    None    &{ExcelPath}[Borrower_RemittanceDescription_2]    &{ExcelPath}[Loan_Increase]    &{ExcelPath}[Loan_Currency]
    Run Keyword If    '&{ExcelPath}[rowid]'!='3' and '&{ExcelPath}[rowid]'!='7'    Create Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Set All Items to Do It   

    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
        
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    Run Keyword If    '&{ExcelPath}[Loan_Currency]' == 'USD'    Set FX Rates Loan Repricing    &{ExcelPath}[Loan_Currency]    Spot
    Run Keyword If    '&{ExcelPath}[Loan_Currency]' == 'GBP'    Set FX Rates Loan Repricing    &{ExcelPath}[Loan_Currency]    Spot
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows
    Run Keyword If    '&{ExcelPath}[rowid]'!='3'    Release Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Release Cashflow    &{ExcelPath}[Loan_Increase]|${CycleAmount}    release    int

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Release    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    
    Close All Windows on LIQ
    
Initiate Comprehensive Repricing for D1 - D00000476
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for D1 until Sent to Approval
    [Arguments]    ${ExcelPath}
    
    ### Login
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ## Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ### Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    
    ...    &{ExcelPath}[Loan_NewOutstanding]    &{ExcelPath}[Repricing_Frequency]    None    &{ExcelPath}[Repricing_Date]
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    &{ExcelPath}[rowid]    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    1    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    3    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='2'    Write Data To Excel    SERV08C_ComprehensiveRepricing    Loan_Alias    2    ${NewLoanAlias}    ${CBAUAT_ExcelPath}
    Run Keyword If    '&{ExcelPath}[rowid]'=='8'    Write Data To Excel    SERV23_Paperclip    Loan_Alias    3    ${NewLoanAlias}    ${CBAUAT_ExcelPath}

    Run Keyword if    '&{ExcelPath}[rowid]'!='7'    Add Repricing Details    Interest Payment
    ${CycleAmount}    Run Keyword if    '&{ExcelPath}[rowid]'!='7'    Select Cycles for Loan Item    Projected Due    &{ExcelPath}[Cycle]
    Run Keyword if    '&{ExcelPath}[rowid]'!='7'    Verify Interest Payment    ${CycleAmount}    &{ExcelPath}[Payment_Effective_Date]
  
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows

    ## Remittance Instruction Addition per Cashflow ###
    Run Keyword If    '&{ExcelPath}[rowid]'!='3' and '&{ExcelPath}[rowid]'!='7'    Add Remittance Instructions    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Add Remittance Instructions    None    &{ExcelPath}[Borrower_RemittanceDescription]    ${CycleAmount}    &{ExcelPath}[Loan_Currency]
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Add Remittance Instructions    None    &{ExcelPath}[Borrower_RemittanceDescription_2]    &{ExcelPath}[Loan_Increase]    &{ExcelPath}[Loan_Currency]
    Run Keyword If    '&{ExcelPath}[rowid]'!='3' and '&{ExcelPath}[rowid]'!='7'    Create Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    Run Keyword If    '&{ExcelPath}[rowid]'=='3'    Set All Items to Do It   

    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Approval
    
Approve D1 Repricing - D00000476
    [Documentation]    This is a high-level keyword for the Approval and Releasing of D1 Repricing
    [Arguments]    ${ExcelPath}
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
        
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    Run Keyword If    '&{ExcelPath}[Loan_Currency]' == 'USD'    Set FX Rates Loan Repricing    &{ExcelPath}[Loan_Currency]    Spot
    Run Keyword If    '&{ExcelPath}[Loan_Currency]' == 'GBP'    Set FX Rates Loan Repricing    &{ExcelPath}[Loan_Currency]    Spot
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Release    Loan Repricing    &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    
    Close All Windows on LIQ
    