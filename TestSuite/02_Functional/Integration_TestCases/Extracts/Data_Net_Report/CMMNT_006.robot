*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_006
    [Documentation]    This test case is used to verify that the appropriate Comments are displayed in the report when the user created Comments  for an Agency deal.
    ...    PREREQUISITES:
    ...    1. Completed and passed run of Expanded_Scenario1.robot
    ...    2. Run after 1 calendar date. (Example: Expanded_Scenario1.robot is ran at 12/1, run this script CMMNT_006 at 12/2)
    ...    @author: clanding    20NOV2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_006
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Comments    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Comments Details are Correct from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT