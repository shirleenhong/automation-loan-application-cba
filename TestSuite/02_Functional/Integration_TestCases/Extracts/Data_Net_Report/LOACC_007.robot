*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
LOACC_007
    [Documentation]    This test case is used to verify that the pending facility is not appearing in the report.
    ...    PREREQUISITES: Completed and passed run of Expanded_Scenario1.robot
    ...    @author: clanding    09DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    LOACC_007
    Mx Execute Template With Specific Test Case Name    Validate Pending Facility is Not Existing in Loans and Accruals Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LOACC