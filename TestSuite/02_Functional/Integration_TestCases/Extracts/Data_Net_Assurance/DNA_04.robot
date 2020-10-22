*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

DNA_04
    [Documentation]    This test case is used to verify the control value of the Control Matrix for the Existing Records.
    ...    @author: clanding    15OCT2020    - initial create

    Set Global Variable    ${TestCase_Name}    DNA_04
    Mx Execute Template With Specific Test Case Name    Validate Control Value of Control Matrix for Existing Records    ${DNA_DATASET}    Test_Case    ${TestCase_Name}    DNA