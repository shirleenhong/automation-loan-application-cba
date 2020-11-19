*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Report Prompt from Comments Report
    [Documentation]    This keyword is used to validate fields in Report Prompt_1n sheet name in the Comments Report.
    ...    Fields to Validate: Report Name, From Date, To Date
    ...    @author: clanding    18NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]