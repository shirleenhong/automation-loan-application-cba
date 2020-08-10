*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Release Cashflow for Drawdown
    [Arguments]    ${ExcelPath}
   
    Open Loan Initial Drawdown Notebook via WIP - Awaiting Release Cashflow    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Loan_Alias]
    #Release Drawdown Cashflows    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RequestedAmount]
    Release Loan Initial Drawdown    

Release Cashflow for Payment
    [Arguments]    ${ExcelPath}
   
    #Open Payment Notebook via WIP - Awaiting Release Cashflow    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Loan_Alias]
    #Release Payment Cashflows    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RequestedAmount]
    Release Payment
