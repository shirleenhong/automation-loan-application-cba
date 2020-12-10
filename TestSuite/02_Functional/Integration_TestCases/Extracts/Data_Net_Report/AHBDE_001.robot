*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${row_id}    2

*** Test Cases ***
AHBDE_001
    [Documentation]    This test case is used to validate Agency DE Extract tab in the DE report if the following fields are available:
    ...    Fields to Validate in Agency DE Extract Tab: Customer Short Name, Host Bank Share Amount, Cashflow Currency, Cashflow Direction, Processing Date
    ...    Effective Date, DDA Transaction Description, Cashflow Description, Deal Tracking Number, Transaction Code, Expense Code, Cashflow ID, Processing Area Code
    ...    Cashflow Status, Payment Method, Cashflow Create Date/Time
    ...    NOTE: DE Report should be available already in the report path.
    ...    @author: fluberio    20NOV2020    - initial create

    Set Global Variable    ${TestCase_Name_SummaryTab}    AHBDE_001
    MX Execute Template With Specific Test Case Name    Validate Agency DE Extract from Agency Host Bank DE Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name_SummaryTab}    AHBDE