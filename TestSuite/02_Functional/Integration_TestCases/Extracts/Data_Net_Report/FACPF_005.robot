*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
FACPF_005
    [Documentation]    This test case is used to validate that the generated report does not include facility with pending status.
    ...    Columns to Validate: Total Utilization Amount
    ...    NOTE: LIQ Performance Report should be available already in the report path.
    ...    @author: ccarriedo    04DEC2020    - initial create

    Set Global Variable    ${TestCase_Name}    FACPF_005
    Mx Execute Template With Specific Test Case Name    Validate Facility Performance Report File With Pending Status     ${DNR_DATASET}    Test_Case    ${TestCase_Name}    FACPF