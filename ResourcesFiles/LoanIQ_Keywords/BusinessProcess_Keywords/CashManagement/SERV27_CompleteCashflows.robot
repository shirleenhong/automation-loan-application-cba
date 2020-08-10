*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keyword ***
Complete Cashflow - Drawdown
    [Documentation]    This keyword is used to Complete Cashflows on a released Loan Drawdown.
    ...    @update: hstone    15MAY2020    - Added 'Release Cashflow'
    ...                                    - Updated Borrower and Lender Excel Data Identifiers
    ...                                    - Added Take Screenshot Before/After Completing cashflow
    [Arguments]    ${ExcelPath}
    mx LoanIQ activate    ${LIQ_Drawdown_Window}   
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/LaonDrawdown/CompleteCashflow
    Mx LoanIQ DoubleClick   ${LIQ_Drawdown_WorkflowItems}    Complete Cashflows
    mx LoanIQ activate    ${LIQ_Cashflows_Window}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_Remittance_Description]    &{ExcelPath}[Lender1_Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_Remittance_Description]    &{ExcelPath}[Lender2_Remittance_Instruction]
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]
    Take Screenshot    ${Screenshot_Path}/LaonDrawdown/CompleteCashflow

Complete Cashflow - Payment
    [Arguments]    ${ExcelPath}
    Select Item in Work in Process    Payment    Awaiting Complete Cashflows    Interest Payment    &{ExcelPath}[Payment_Alias]
    mx LoanIQ activate    ${LIQ_Drawdown_Window}   
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ DoubleClick   ${LIQ_Drawdown_WorkflowItems}    Complete Cashflows         
    mx LoanIQ activate    ${LIQ_Cashflows_Window}
   # Select Preferred Remittance Instruction via Drawdown Cashflow Window    &{ExcelPath}[Customer_Shortname]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Borrower_Profile]    &{ExcelPath}[ApproverPassword]    &{ExcelPath}[LIQCustomer_ID]
    # Set Cashflow to DoIt and Complete    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status_DoIt]    
    mx LoanIQ activate    ${LIQ_Payment_Window}   
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ DoubleClick   ${LIQ_Payment_WorkflowItems}    Complete Cashflows         
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_Window}
    
    Run Keyword And Continue On Failure    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer1_Shortname]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[Loan_Currency]
    Run Keyword And Continue On Failure    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer2_Shortname]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[Loan_Currency]
    Run Keyword And Continue On Failure    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer3_Shortname]    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[Loan_Currency]   

