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

Write Details for Liquidity Report
    [Documentation]    This keyword is used to write needed details in Liquidity Report sheet.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_LIQUIDITY_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    LQDTY    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LIQUIDITY_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True