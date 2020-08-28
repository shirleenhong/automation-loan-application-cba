*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Teardown    Close All Connections

*** Test Cases ***

DWELIQ_Multi_EV_001
    [Documentation]    This test case is used to verify that the User is able to generate and verify the extracted data from LIQ for specific ZONE with FULL batch load type.
    ...    PREREQUISITES: DWE Batch is added in LIQ, DWE GS Transformation is down, Extractlistener is down
    ...    Run DWE Batch for specific ZONE (2/3) with FULL as batch load type
    ...    @author: clanding    09JUL2020    - initial create

    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_EV_001
    Mx Execute Template With Specific Test Case Name    Generate and Verify LIQ Extract for Specific Zone    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE