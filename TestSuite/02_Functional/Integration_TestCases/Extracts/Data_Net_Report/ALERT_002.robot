*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
ALERT_002
    [Documentation]    This test case is used to validate Deal sheet in the DNR Alert Reports 
    ...    Fields should be available to validate in sequence: Deal Name, Deal Tracking Number, Alert Heading, 
    ...    Alert Content, User Name, Date Added / Amended
    ...    NOTE: Alert Report should be available already in the report path
    ...    @author: songchan    19NOV2020    - initial create
    

    Set Global Variable    ${TestCase_Name}    ALERT_002
    Mx Execute Template With Specific Test Case Name    Validate Deal from Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT