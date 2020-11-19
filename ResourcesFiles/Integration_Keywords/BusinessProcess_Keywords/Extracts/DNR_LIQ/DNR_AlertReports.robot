*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Report Prompt from Alert Reports
    [Documentation]    This keyword is to validate the fields in the Report_Prompt sheet in the Alerts Report
    ...    Fields to Validate: Report Name, From Date and To Date
    ...    @author: songchan    18NOV2020    - intial create
    [Arguments]    ${ExcelPath}

    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]