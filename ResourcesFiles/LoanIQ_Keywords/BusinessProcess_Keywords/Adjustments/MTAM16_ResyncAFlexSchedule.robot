*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Resync a Flex Schedule
    [Documentation]    This keyword is used to Resync an existing Flex Schedule.
    ...    @author: hstone      16JUL2020      - Initial Create
    [Arguments]    ${ExcelPath}

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Resync a Flex Schedule ###
    Navigate to an Existing Loan    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Navigate to Repayment Schedule from Loan Notebook
    Navigate to Flexible Schedule Item Modification    &{ExcelPath}[Schedule_Row_TargetItem1]
    Modify Repayment Schedule Item at Flexible Schedule    &{ExcelPath}[Schedule_Row_TargetItem1]    &{ExcelPath}[Schedule_Column]    &{ExcelPath}[Schedule_Item1_NewValue]
    Modify Repayment Schedule Item at Flexible Schedule    &{ExcelPath}[Schedule_Row_TargetItem2]    &{ExcelPath}[Schedule_Column]    &{ExcelPath}[Schedule_Item2_NewValue]
    Select Resync Settings in Flexible Schedule    &{ExcelPath}[Resync_Setting]
    Click on Calculate Payments in Flexible Schedule
    Click OK in Flexible Schedule Window
    Resynchronize Repayment Schedule
    Save Repayment Schedule For Loan
    Validate Repayment Schedule Item Cell Value For Loan    &{ExcelPath}[Schedule_Row_TargetItem1]    &{ExcelPath}[Schedule_Column]    &{ExcelPath}[Schedule_Item1_NewValue]
    Validate Repayment Schedule Item Cell Value For Loan    &{ExcelPath}[Schedule_Row_TargetItem2]    &{ExcelPath}[Schedule_Column]    &{ExcelPath}[Schedule_Item2_NewValue]
    Close All Windows on LIQ