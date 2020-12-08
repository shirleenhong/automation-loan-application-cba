*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
LOACC_002
    [Documentation]    This test case is used to verify that the  Data Type field name has the description Facility or Outstanding.
    ...    NOTE: Loans and Accruals Report should be available already in the report path.
    ...    @author: clanding    07DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    LOACC_002
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Loans and Accruals    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Data Type Column if Correct from Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LOACC