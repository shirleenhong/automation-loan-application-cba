*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

CMMNT_004
    [Documentation]    This test case is used to verify the Outstanding tab has the following fields in the same order as specified below:
    ...    Deal Name
    ...    Deal Tracking Number
    ...    Alias Number
    ...    Comment Heading
    ...    Comment Detail
    ...    User ID
    ...    Date Added / Amended
    ...    NOTE: Comments Report should be available already in the report path.
    ...    @author: clanding    20NOV2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    CMMNT_004
    Mx Execute Template With Specific Test Case Name    Validate Facility Columns from Comments Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    CMMNT