*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
ALERT_001
    [Documentation]    This test case used to validate report tab in the DNR Alert Reports
    ...    Fields should be available to validate: Report Name, From Date, and To Date
    ...    NOTE: Alert Report should be available already in the report path
    ...    @author: songchan    18NOV2020    - initial create
    

    Set Global Variable    ${TestCase_Name}    ALERT_001
    Mx Execute Template With Specific Test Case Name    Validate Report Prompt from Alert Reports    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT