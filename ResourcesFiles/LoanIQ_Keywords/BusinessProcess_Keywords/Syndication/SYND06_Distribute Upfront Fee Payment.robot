*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Distribute Upfront Fee Payment - Auto
    [Documentation]    Initiate Upfront Fee Payment.
    ...    @author: sahalder    04JUN2020    Initial Create
    [Arguments]    ${ExcelPath}
    ###Close all windows and Login as original user###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Open the existing Closed Deal###  
    Search Existing Deal    &{ExcelPath}[Deal_Name] 
    
    ###Distribute Upfront Fees among Lenders###
    Enter Upfront Fee Distribution Details    &{Excelpath}[UpfrontFee_Amount]
    Enter Fee Details    &{ExcelPath}[Fee_Type]

    ###Upfront Fee Payment Workflow Tab- Create Cashflow Item###
    Navigate Notebook Workflow in Distribute Upfront Fee Payment Notebook    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_ShortName]

    ### GL Entries
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    Navigate Notebook Workflow in Distribute Upfront Fee Payment Notebook    Send to Approval
    
    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}    
    Navigate to Payment Notebook via WIP    Payments    Awaiting Approval    Upfront Fee Distribution to Primaries    &{ExcelPath}[Deal_Name]    
    Approve Upfront Fee Distribution
    Release Upfront Fee Distribution
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}



