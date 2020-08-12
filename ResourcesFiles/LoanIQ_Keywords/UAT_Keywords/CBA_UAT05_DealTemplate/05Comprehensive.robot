*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***
Comprehensive Repricing Principal and Interest Payment - 2 Cashflows
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing  with principal and interest payments with 2 cashflows
    ...    @author: hstone    22AUG2019    INITIAL CREATION
    [Arguments]    ${ExcelPath}
    
    ### Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ### Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_CurrentOutstanding]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]
    Add Interest Payment for Loan Repricing
    ${PrincipalPayment}    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_NewOutstanding]
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_TotalGlobalInterest]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    
    ### Remittance Instruction Addition per Cashflow ###
    Add Remittance Instructions    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    ${PrincipalPayment}    &{ExcelPath}[Loan_Currency]
    Add Remittance Instructions    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Loan_Currency]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceInstruction]    ${PrincipalPayment}    
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceInstruction]    &{ExcelPath}[Loan_TotalGlobalInterest]
    Take Screenshot    CashflowsForLoanRepricing
    
    Confirm Cashflows for Loan Repricing
    
    Send Loan Repricing for Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    Approve Rate Setting Notice
    
    Generate Rate Setting Notices    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[NoticeStatus]
    Release Loan Repricing
    
    Close All Windows on LIQ
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Comprehensive Repricing Principal and Interest Payment - 1 Cashflow
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing with principal and interest payments with 1 cashflow
    ...    @author: hstone    22AUG2019    INITIAL CREATION
    [Arguments]    ${ExcelPath}
    ### Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ### Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_CurrentOutstanding]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]
    Add Interest Payment for Loan Repricing
    ${PrincipalPayment}    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_NewOutstanding]
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_TotalGlobalInterest]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    
    ### Remittance Instruction Addition per Cashflow ###
    Add Remittance Instructions    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Loan_PrincipalAndGlobalInterest]    &{ExcelPath}[Loan_Currency]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceInstruction]    &{ExcelPath}[Loan_PrincipalAndGlobalInterest]    
    Take Screenshot    CashflowsForLoanRepricing
    
    Confirm Cashflows for Loan Repricing
    
    Send Loan Repricing for Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    Approve Rate Setting Notice
    
    Generate Rate Setting Notices    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[NoticeStatus]
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows 
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    
    Close All Windows on LIQ
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Comprehensive Repricing Interest Payment
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing with interest payment only
    ...    @author: hstone    29AUG2019    INITIAL CREATION
    [Arguments]    ${ExcelPath}  
    ### Perforn Online Accrual ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Perform Online Accrual for a Loan Alias    &{ExcelPath}[Loan_Alias]
    
    ### Select Loan to Reprice ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_CurrentOutstanding]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Rollover/Conversion Notebook###
    ${NewLoanAlias}    Add New Outstandings    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]
    Add Interest Payment for Loan Repricing
    Validate Interest Payments Amount    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_TotalGlobalInterest]
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Create Cashflows
    
    ### Remittance Instruction Addition per Cashflow ### 
    Add Remittance Instructions    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Loan_Currency]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceInstruction]    &{ExcelPath}[Loan_TotalGlobalInterest]    
    Take Screenshot    CashflowsForLoanRepricing
    
    Confirm Cashflows for Loan Repricing
    
    Send Loan Repricing for Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    ### Rate Approval ###
    Approve Loan Repricing
    Send to Rate Approval
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Work in process notebook ###
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Repricing    &{ExcelPath}[Deal_Name]
    
    Approve Rate Setting Notice
    
    Generate Rate Setting Notices    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[NoticeStatus]
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release Cashflows 
    Cashflows Mark All To Release
    Click OK In Cashflows
    
    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    Close All Windows on LIQ
    
    ### LIQ Window ###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Check Limit after Rollover/Repayment
    [Documentation]    This is a high-level keyword to Check limit after Rollover/Repayment
    ...    @author: hstone    27AUG2019    INITIAL CREATION
    [Arguments]    ${ExcelPath}
    ### Deal Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ### Facility Current Commitment Amount Validation ###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Validate Facility Window Summary Tab Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_NewCurrentAmt]
    Close Facility Notebook and Navigator Windows
    
    ### Base Rate Validation ###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Loan_NewOutstanding]    
    Navigate to Rates Tab - Loan Notebook
    ${AllInRate}    Add Borrower Base Rate and Facility Spread    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Interest_SpreadValue]
    ${AllInRate}    Set Variable    ${AllInRate}%
    Validate String Data In LIQ Object    ${LIQ_Loan_Window}    ${LIQ_Loan_AllInRate}    ${AllInRate}
    Close All Windows on LIQ
