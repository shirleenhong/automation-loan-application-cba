*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

DWELIQ_Multi_E2E_001
    [Documentation]    This test case is used to verify that the User is able to generate and processed the Extracts from LIQ for Zone 3.
    ...    PREREQUISITES: DWE Batch is added in LIQ, LIQ Version is updated on MCH Table, Pipelines are generated in Streamsets
    ...    Extractlistener is up, DWE Transformation is up, Notification is up
    ...    @author: clanding    10JUL2020    - initial create

    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001
    Mx Execute Template With Specific Test Case Name    Generate and Process LIQ Extracts for Zone 3    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE