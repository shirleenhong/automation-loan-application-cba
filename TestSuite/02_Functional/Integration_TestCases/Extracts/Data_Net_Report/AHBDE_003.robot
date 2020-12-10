*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    4

*** Test Cases ***
AHBDE_003
    [Documentation]    This keyword is used to verify DDA Transaction Desc is correct when completing a loan rollover with comprehensive repricing
    ...    PREREQUISITE: DE Report should be available already in the report path.
    ...    @author: makcamps    09DEC2020    - initial create

    Set Global Variable    ${TestCase_Name_SummaryTab}    AHBDE_003
    MX Execute Template With Specific Test Case Name    Validate that the Agency Host Bank DE Report DDA Transaction Desc is Correct    ${DNR_DATASET}    Test_Case    ${TestCase_Name_SummaryTab}    AHBDE