*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
LOACC_005
    [Documentation]    This test case is used to verify that the Amount columns displays numbers in 2 decimal places from Loans and Accruals Report
    ...    NOTE: Loans and Accruals Report should be available already in the report path.
    ...    @author: kaustero    08DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    LOACC_005
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Loans and Accruals    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Amount Columns Displays Numbers in 2 Decimal Places from Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LOACC