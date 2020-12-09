*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
LQDTY_003
    [Documentation]    This test case is used to validate that drawdown with Pending Status with more than 1M AUD requested amount is NOT displayed in the generated report.
    ...    NOTE: Liquidity Report should be available already in the report path.
    ...    PREREQUISITES: Completed and passed run of Expanded_Scenario1.robot
    ...    @author: clanding    08DEC2020    - initial create

    Set Global Variable    ${rowid}    1
    Set Global Variable    ${TestCase_Name}    LQDTY_003
    Mx Execute Template With Multiple Data    Get RID from Loan for Liquidity Report    ${DNR_DATASET}    ${rowid}    SC1_LoanDrawdown
    MX Execute Template With Specific Test Case Name    Validate if RID is Not Existing in Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LQDTY