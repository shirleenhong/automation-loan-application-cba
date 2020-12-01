*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_002
    [Documentation]    This test case is used to verify the Deal tab has the following fields in the same order as specified below:
    ...    Deal Name   
    ...    Deal Tracking Number
    ...    Comment Heading
    ...    Comment Detail
    ...    User ID
    ...    Date Added / Amended
    ...    NOTE: Comments Report should be available already in the report path.
    ...    @author: clanding    19NOV2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_002
    Mx Execute Template With Specific Test Case Name    Validate Deal Columns from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT