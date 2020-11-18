*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_001
    [Documentation]    This test case is used to validate report tab in the comments report if the following fields are available:
    ...    Report Name
    ...    From Date
    ...    To Date
    ...    NOTE: Comments Report should be available already in the report path.
    ...    @author: clanding    18NOV2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_001
    Mx Execute Template With Specific Test Case Name    Validate Report Prompt from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT