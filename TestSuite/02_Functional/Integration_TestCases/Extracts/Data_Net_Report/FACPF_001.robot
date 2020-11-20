*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
FACPF_001
    [Documentation]    This test case is used to validate that the columns below are added on the LIQ Performance Report.
    ...    Columns to Validate: Deal Processing Area, Total Utilization Amount, Facility Status
    ...    NOTE: LIQ Performance Report should be available already in the report path.
    ...    @author: ccarriedo    20NOV2020    - initial create

    Set Global Variable    ${TestCase_Name}    FACPF_001
    Mx Execute Template With Specific Test Case Name    Validate Columns In LIQ Performance Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    FACPF