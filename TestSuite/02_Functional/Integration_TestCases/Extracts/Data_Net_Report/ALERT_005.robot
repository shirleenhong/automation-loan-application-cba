*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
ALERT_005
    [Documentation]    This test case is used to validate Customer sheet in the DNR Alert Reports 
    ...    Fields should be available to validate in sequence: Customer Name, CIF Number, Alert Heading, Alert Content,
    ...    User Name, Data Added/Amended
    ...    NOTE: Alert Report should be available already in the report path
    ...    @author: songchan    20NOV2020    - initial create
    

    Set Global Variable    ${TestCase_Name}    ALERT_005
    Mx Execute Template With Specific Test Case Name    Validate Customer from Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT