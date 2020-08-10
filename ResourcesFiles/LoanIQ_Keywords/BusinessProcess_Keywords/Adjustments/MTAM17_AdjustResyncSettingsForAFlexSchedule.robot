*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Adjust Resync Settings for a Flex Schedule
    [Documentation]    This keyword is used to adjus Resync Settings for an existing Flex Schedule.
    ...    @author: hstone      27JUL2020      - Initial Create
    [Arguments]    ${ExcelPath}

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Adjust Resync Settings for a Flex Schedule ###
    Navigate to an Existing Loan    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Navigate to Repayment Schedule from Loan Notebook
    Select Reschedule Menu in Repayment Schedule
    Select Type of Schedule    &{ExcelPath}[Schedule_Type]
    Select Resync Settings in Flexible Schedule    &{ExcelPath}[Resync_Settings]
    Add Items in Flexible Schedule    &{ExcelPath}[FlexSched_PayThruMaturity]    &{ExcelPath}[FlexSched_ItemFrequency]    &{ExcelPath}[FlexSched_ItemType]
    ...    &{ExcelPath}[FlexSched_ConsolidationType]    &{ExcelPath}[FlexSched_RemittanceInstruction]    sItem_PandI_Amount=&{ExcelPath}[FlexSched_P&IAmount]
    Save Repayment Schedule For Loan
    Validate Repayment Schedule Resync Settings Value    &{ExcelPath}[Resync_Settings]
    Validate Repayment Schedule Last Payment Remaining Value    &{ExcelPath}[LastPayment_RemainingVal]
    Close All Windows on LIQ