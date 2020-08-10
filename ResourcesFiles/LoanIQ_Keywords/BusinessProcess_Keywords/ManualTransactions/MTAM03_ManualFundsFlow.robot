*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
   
Manual Funds Flow
    [Documentation]    This keyword is used to create a Manual Fund flow Transaction.
    ...    @author: Archana
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Manual Fund FLow Notebook###    
    ${Effective_Date}    Get System Date
    Navigate to Manual Funds Flow Notebook
    Select New Manual Fund Flow
    Manual FundFlow Details    &{ExcelPath}[ManualFundFlow_Branch]    ${Effective_Date}    &{ExcelPath}[Currency]    &{ExcelPath}[Description]    &{ExcelPath}[Processing_Area]
    Select Expense Code    &{ExcelPath}[ExpenseCode]
    Select Security ID
    Select Deal    ${ExcelPath}[Deal_Name]
    Add IncomingFunds    ${ExcelPath}[IncomingFund_Amount]    &{ExcelPath}[Customer]
    Add OutgoingFunds    ${ExcelPath}[OutgoingFund_Amount]    &{ExcelPath}[Customer1]
    
    ###Create Cashflows ###
    Navigate Notebook Workflow - Cashflow Creation    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Short_Name1]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Short_Name2]    &{ExcelPath}[Remittance_Description1]    &{ExcelPath}[Remittance_Instruction1]   
    Create Cashflow    &{ExcelPath}[Short_Name1]|&{ExcelPath}[Short_Name2]
        
    Close Cashflow Window
    
    ###Send Transaction to approval###
    Send Manual Fund Flow to Approval
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Transaction in Process###
    Navigate Transaction in WIP    &{ExcelPath}[Transaction_Type]    &{ExcelPath}[Transaction_Status_Awaiting_Approval]    &{ExcelPath}[Type]    &{ExcelPath}[Deal_Name]    
    
    ###Manual Fund Flow Notebook###
    Approve Manual Fund Flow    
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Manual Fund FLow Notebook###
    Navigate to Manual Funds Flow Notebook
    Select Existing Manual Fund Flow    ${Effective_Date}    ${Effective_Date}
    Select Manual Fund Flow Transaction From List    &{ExcelPath}[Transaction_List]
    Navigate to Release Cashflow - Manual Fund Flow
    Release Cashflow    &{ExcelPath}[Short_Name2]    release    
    Release Manual Fund Flow
    Validate Events Tab for Manual Fund Flow
    Validation Of GL Entries
    ${DebitAmount}    Get GL Entries Amount    &{ExcelPath}[Short_Name1]    Debit Amt
    ${CreditAmount}    Get GL Entries Amount    &{ExcelPath}[Short_Name2]    Credit Amt
    ${TotalDebit}    Get GL Entries Amount    Total For    Debit Amt
    ${TotalCredit}    Get GL Entries Amount    Total For    Credit Amt
    Close GL Entries_Manual Fund Flow Notebook
    Close All Windows on LIQ      