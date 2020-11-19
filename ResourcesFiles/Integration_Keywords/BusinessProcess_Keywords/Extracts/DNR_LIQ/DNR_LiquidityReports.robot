*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Summary and Details from Liquidity Report
    [Documentation]    This keyword is used to validate fields in Summary and Details sheet names in the Liquidity Report.
    ...    Fields to Validate in Summary Tab: Effective Date, New Drawdown, Increase, Total Drawdown,Payments,Interest,Total Repayment,NetFlow
    ...    Fields to Validate in Details Tab: Effective Date,TRN Group Internal ID,Transaction Id,Customer ID,Customer Name,Currency,Net Cashflow,Transaction Description,Transaction Status
    ...    @author: fluberio    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_LIQUIDITY_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]