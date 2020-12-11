*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
LOACC_004
    [Documentation]    This test case is used to verify that the Currency fields are displaying the ISO Currency Code
    ...    NOTE: Loans and Accruals Report should be available already in the report path.
    ...    @author: kaustero    07DEC2020    - initial create

    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    LOACC_004
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Loans and Accruals    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Currency Column if Correct from Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LOACC