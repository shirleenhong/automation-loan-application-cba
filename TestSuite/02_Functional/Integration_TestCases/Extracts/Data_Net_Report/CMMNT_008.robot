*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_008_UpdateComments
    [Documentation]    This test case is used to updated existing comments in the deal.
    ...    PREREQUISITES:
    ...    1. Completed and passed run of Expanded_Scenario1.robot
    ...    2. Run after 1 calendar date. (Example: Expanded_Scenario1.robot is ran at 12/1, run this script CMMNT_008_UpdateComments at 12/2)
    ...    @author: clanding    01DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_008
    Mx Execute Template With Specific Test Case Name    Update Comments in Deal for DNR    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT

CMMNT_008_ValidateReport
    [Documentation]    This test case is used to verify that the appropriate Comments are displayed in the report when the user updated Comments for an Agency deal.
    ...    PREREQUISITES:
    ...    1. Run after 1 calendar date after running CMMNT_008_UpdateComments (Example: CMMNT_008_UpdateComments is ran at 12/2, run this script CMMNT_008_ValidateReport at 12/3)
    ...    @author: clanding    01DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_008
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Comments    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Comments Details for Deal are Correct from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT