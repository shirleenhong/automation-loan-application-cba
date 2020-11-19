*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Test Cases ***
LQDTY_001
    [Documentation]    This test case is used to validate summary and details tab in the liquidity report if the following fields are available:
    ...    Fields to Validate in Summary Tab: Effective Date, New Drawdown, Increase, Total Drawdown,Payments,Interest,Total Repayment,NetFlow
    ...    Fields to Validate in Details Tab: Effective Date,TRN Group Internal ID,Transaction Id,Customer ID,Customer Name,Currency,Net Cashflow,Transaction Description,Transaction Status
    ...    NOTE: Liquidity Report should be available already in the report path.
    ...    @author: fluberio    19NOV2020    - initial create

    Set Global Variable    ${TestCase_Name}    LQDTY_001
    MX Execute Template With Specific Test Case Name    Validate Summary and Details from Liquidity Report    ${DNR_DATASET}    Test_Case    ${TestCase_Name}    LQDTY