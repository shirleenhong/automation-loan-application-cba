*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Agency DE Extract from Agency Host Bank DE Report
    [Documentation]    This test case is used to validate Agency DE Extract tab in the DE report if the following fields are available:
    ...    Fields to Validate in Agency DE Extract Tab: Customer Short Name, Host Bank Share Amount, Cashflow Currency, Cashflow Direction, Processing Date
    ...    Effective Date, DDA Transaction Description, Cashflow Description, Deal Tracking Number, Transaction Code, Expense Code, Cashflow ID, Processing Area Code
    ...    Cashflow Status, Payment Method, Cashflow Create Date/Time
    ...    @author: fluberio    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_DE_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]