*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

ALERT_008_UpdateAlerts
    [Documentation]    This test case is used to Verify that the appropriate Alerts are displayed in the report when the user added Alerts  for bilateral deal with single borrower. 
    ...    PREREQUISITES:
    ...    1. Completed and passed run of Expanded_Scenario1.robot
    ...    2. Run after 1 calendar date. (Example: Expanded_Scenario1.robot is ran at 12/1, run this script ALERT_009_UpdateAlerts at 12/2)
    ...    @author: clanding    03DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    ALERT_008
    Mx Execute Template With Specific Test Case Name    Update Alerts in Deal for DNR    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT

ALERT_008_ValidateReport
    [Documentation]    This test case is used to Verify that the appropriate Alerts are displayed in the report when the user added Alerts  for bilateral deal with single borrower. 
    ...    PREREQUISITES:
    ...    1. Run after 1 calendar date. (Example: ALERT_009_UpdateAlerts is ran at 12/2, run this script ALERT_009_Validate at 12/3)
    ...    @author: clanding    03DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    ALERT_008
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Alerts    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Alert Details for Deal are Correct from Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT