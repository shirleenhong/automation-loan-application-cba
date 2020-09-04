*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Test Setup    Test Setup for DWE Extract
Test Teardown    Test Teardown for DWE Extract

*** Test Cases ***

DWELIQ_Multi_EV_001_Z2
    [Documentation]    This test case is used to verify that the User is able to generate and verify the extracted data from LIQ for specific ZONE with FULL batch load type.
    ...    PREREQUISITES: DWE Batch is added in LIQ, DWE GS Transformation is down, Extractlistener is down
    ...    Run DWE Batch for Zone 2 with FULL as batch load type.
    ...    @author: clanding    09JUL2020    - initial create
    ...    @update: clanding    28AUG2020    - updated to run specific to Zone 2
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_EV_001_Z2
    Mx Execute Template With Specific Test Case Name    Generate and Verify LIQ Extract for Specific Zone    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

DWELIQ_Multi_EV_001_Z3
    [Documentation]    This test case is used to verify that the User is able to generate and verify the extracted data from LIQ for specific ZONE with FULL batch load type.
    ...    PREREQUISITES: DWE Batch is added in LIQ, DWE GS Transformation is down, Extractlistener is down
    ...    Run DWE Batch for Zone 3 with FULL as batch load type.
    ...    @author: clanding    28AUG2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_EV_001_Z3
    Mx Execute Template With Specific Test Case Name    Generate and Verify LIQ Extract for Specific Zone    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE