*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    3

*** Test Cases ***
AHBDE_005
    [Documentation]    This keyword is used to verify net amount is correct when completing a loan split with interest collection
    ...    NOTE: DE Report should be available already in the report path.
    ...    @author: fluberio    04DEC2020    - initial create

    Set Global Variable    ${TestCase_Name_SummaryTab}    AHBDE_005
    MX Execute Template With Specific Test Case Name    Validate that the Agency Host Bank DE Report Net Amount is Correct    ${DNR_DATASET}    Test_Case    ${TestCase_Name_SummaryTab}    AHBDE