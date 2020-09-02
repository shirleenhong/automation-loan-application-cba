*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Setup    Test Setup for DWE Extract
Test Teardown    Test Teardown for DWE Extract

*** Test Cases ***

DWELIQ_Multi_EV_003
    [Documentation]    This test case is used to verify that the User is able to extract data from LIQ for All available Zone simultaneously with FULL batch load type
    ...    PREREQUISITES: DWE Batch is added in LIQ, DWE GS Transformation is down, Extractlistener is down
    ...    Run DWE Batch for all available Zone with FULL as batch load type simultaneously.
    ...    @author: clanding    26UAG2020    - initial create

    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_EV_003_Z2|DWELIQ_Multi_EV_003_Z3
    Mx Execute Template With Multiple Test Case Name    Generate and Verify LIQ Extract for Specific Zone    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE