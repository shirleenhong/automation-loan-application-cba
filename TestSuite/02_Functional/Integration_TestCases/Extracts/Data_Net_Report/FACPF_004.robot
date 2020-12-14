*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
FACPF_004
    [Documentation]    This test case is used to validate that the generated report includes Expired Facility with Active Outstanding.
    ...    NOTE: LIQ Performance Report should be available already in the report path.
    ...    PREREQUISITES: Completed and passed run of Expanded_Scenario1.robot
    ...    @author: clanding    11DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    FACPF_004
    Mx Execute Template With Specific Test Case Name    Validate Facility Performance Report File for Expired Facility     ${DNR_DATASET}    Test_Case    ${TestCase_Name}    FACPF