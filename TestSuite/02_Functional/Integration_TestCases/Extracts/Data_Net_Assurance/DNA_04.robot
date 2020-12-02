*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

DNA_04
    [Documentation]    This test case is used to verify the control value of the Control Matrix for the Existing Records.
    ...    Prerequistes to run in order:
    ...    1. DNA_01
    ...    2. DNA_03
    ...    3.1 For Zone 2: DWELIQ_Multi_E2E_002
    ...    3.2 For Zone 3: DWELIQ_Multi_E2E_001
    ...    @author: clanding    15OCT2020    - initial create
    ...    @update: clanding    29NOV2020    - added prerequisites

    Set Global Variable    ${TestCase_Name}    DNA_04
    Mx Execute Template With Specific Test Case Name    Validate Control Value of Control Matrix for Existing Records    ${DNA_DATASET}    Test_Case    ${TestCase_Name}    DNA