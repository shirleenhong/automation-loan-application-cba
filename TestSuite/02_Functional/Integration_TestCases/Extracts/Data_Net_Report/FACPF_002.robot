*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
FACPF_002
    [Documentation]    This test case is used to validate that the generated report includes Active Facility with Active Outstanding.
    ...    NOTE: LIQ Performance Report should be available already in the report path.
    ...    @author: ccarriedo    09DEC2020    - initial create
    
    Set Global Variable    ${TestCase_Name}    FACPF_002
    Mx Execute Template With Specific Test Case Name    Validate Facility Performance Report File for Active Facility     ${DNR_DATASET}    Test_Case    ${TestCase_Name}    FACPF
