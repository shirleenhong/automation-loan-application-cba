*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Temporary Payment Plan
    [Documentation]    This keyword is used to create a Loan Drawdown without selecting a Payment Schedule.
    ...    @author: hstone      01JUN2020      - Initial Create
    [Arguments]    ${ExcelPath}

    ### Inputter: Create Temporary Payment Plan ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    ${ExcelPath}[Deal_Name]    ${ExcelPath}[Facility_Name]    ${ExcelPath}[Loan_Alias]
    Create Flex Repayment Schedule
    Add Items in Flexible Schedule    ${ExcelPath}[AddItem_Pay_Thru_Maturity]    ${ExcelPath}[AddItem_Frequency]    ${ExcelPath}[AddItem_Type]    ${ExcelPath}[AddItem_Consolidation_Type]
    ...    ${ExcelPath}[AddItem_Remittance_Instruction]    ${ExcelPath}[AddItem_Principal_Amount]
    Create Temporary Payment Plan on Repayment Schedule
    Close All Windows on LIQ