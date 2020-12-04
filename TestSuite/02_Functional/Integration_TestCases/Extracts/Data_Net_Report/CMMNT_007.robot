*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_007_DeleteComments
    [Documentation]    This test case is used to delete existing comments in the deal.
    ...    PREREQUISITES:
    ...    1. Completed and passed run of CMMNT_008.robot
    ...    2. Run after 1 calendar date. (Example: CMMNT_008.robot is ran at 12/1, run this script CMMNT_007_DeleteComments at 12/2)
    ...    @author: clanding    04DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_007
    Mx Execute Template With Specific Test Case Name    Delete Comments in Deal for DNR    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT

CMMNT_007_ValidateReport
    [Documentation]    This test case is used to verify that the appropriate Comments are deleted in the report.
    ...    PREREQUISITES:
    ...    1. Run after 1 calendar date after running CMMNT_007_DeleteComments (Example: CMMNT_007_DeleteComments is ran at 12/2, run this script CMMNT_007_ValidateReport at 12/3)
    ...    @author: clanding    04DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_007
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Comments    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Comments for Deal is Not Existing in the Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT