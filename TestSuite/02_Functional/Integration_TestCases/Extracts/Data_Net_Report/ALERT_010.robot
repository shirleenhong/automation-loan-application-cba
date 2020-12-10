*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

ALERT_010_AddAlerts
    [Documentation]    This test case is used to verify that the appropriate Alerts are displayed in the report when the user added Alerts  for a customer.
    ...    PREREQUISITE: Complete run of Create_Customer_NotInUse.robot 
    ...    @author: clanding    05DEC2020    - initial create
    
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    ALERT_010_AddAlerts
    Mx Execute Template With Multiple Data    Add Alerts in Customer for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Alerts    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Alert Details for Customer are Correct from Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT

ALERT_010_UpdateAlerts
    [Documentation]    This test case is used to verify that the appropriate Alerts are displayed in the report when the user added Alerts  for a customer.
    ...    PREREQUISITE: Complete run of ALERT_010_AddAlerts
    ...    @author: clanding    05DEC2020    - initial create
    
    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    ALERT_010_UpdAlerts
    Mx Execute Template With Multiple Data    Update Alerts in Customer for DNR   ${DNR_DATASET}    ${rowid}    SC1_Customer
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Alerts    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Validate Alert Details for Customer are Correct from Alert Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    ALERT