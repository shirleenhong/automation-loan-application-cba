*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Teardown    Close All Connections

*** Test Cases ***

DNA_06
    [Documentation]    This test case is used to verify that the Data Net Assurance File is not existing in FFC.
    ...    @author: clanding    30NOV2020    - initial create

    Set Global Variable    ${TestCase_Name}    DNA_06
    Mx Execute Template With Specific Test Case Name    Verify that No Notification Message Generated for Data Net Assurance Extract    ${DNA_DATASET}    Test_Case    ${TestCase_Name}    DNA