*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Reschedule a Temporary Payment Plan
    [Documentation]    This keyword is used to Reschedule a temporary payment plan to become the new 'Legal' plan.
    ...    @author:    sahalder    27JUL2020    Initial Create
    [Arguments]    ${ExcelPath}

    ## Login to LoanIQ client with the inputter user ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    ${ExcelPath}[Deal_Name]    ${ExcelPath}[Facility_Name]    ${ExcelPath}[Loan_Alias]
    Create Flex Reschedule
    Add Items in Flexible Reschedule Add Window    ${ExcelPath}[AddItem_Pay_Thru_Maturity]    ${ExcelPath}[AddItem_Frequency]    ${ExcelPath}[AddItem_Type]    ${ExcelPath}[AddItem_Consolidation_Type]
    ...    ${ExcelPath}[AddItem_Nominal_Amount]    ${ExcelPath}[AddItem_NoOFPayments]
    Create Temporary Payment Plan After Reschedule
    Become Legal Payment Plan on Temporary Payment Plan
    Save And Exit Repayment Schedule Window
    Close All Windows on LIQ
    