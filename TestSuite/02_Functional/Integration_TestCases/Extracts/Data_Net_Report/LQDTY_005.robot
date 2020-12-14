*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
LQDTY_005
    [Documentation]    This test case is used to validate that principal payments are also included in the report.
    ...    NOTE: Liquidity Report should be available already in the report path.
    ...    PREREQUISITES: Completed and passed run of Expanded_Scenario1.robot
    ...    @author: makcamps    11DEC2020    - initial create
    Set Global Variable    ${TestCase_Name}    LQDTY_005
    Mx Execute Template With Specific Test Case Name    Generate DNR Report for Liquidity    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    Mx Execute Template With Specific Test Case Name    Write Details for Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    DNR
    MX Execute Template With Specific Test Case Name    Validate Principal Payment is Existing in Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LQDTY