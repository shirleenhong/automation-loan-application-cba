*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
Create Pending Facility
    [Documentation]    This test case is used to verify that the pending facility is appearing in the report.
    ...    PREREQUISITES: Completed and passed run of Expanded_Scenario1.robot
    ...    @author: clanding    09DEC2020    - initial create
    Set Global Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Add Pending Facility for DNR    ${DNR_DATASET}    ${rowid}    SC1_FacilitySetup

LOACC_007
    [Documentation]    This test case is used to verify that the pending facility is appearing in the report.
    ...    PREREQUISITES: Completed and passed run of Expanded_Scenario1.robot
    ...    @author: clanding    09DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    LOACC_007
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Loans and Accruals    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Pending Facility is Existing in Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LOACC