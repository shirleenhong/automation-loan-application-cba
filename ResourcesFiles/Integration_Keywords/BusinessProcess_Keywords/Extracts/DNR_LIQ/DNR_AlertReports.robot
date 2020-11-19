*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Report Prompt from Alert Report
    [Documentation]    This keyword is to validate the fields in the Report_Prompt sheet in the Alerts Report
    ...    Fields to Validate: Report Name, From Date and To Date
    ...    @author: songchan    18NOV2020    - intial create
    [Arguments]    ${ExcelPath}

    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Deal from Alert Report
    [Documentation]    This keyword is to validate the fields in the Report_Prompt sheet in the Alerts Report
    ...    Fields to Validate: Deal Name, Deal Tracking Number, Alert Heading, Alert Content, User Name, Date Added / Amended
    ...    @author: songchan    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]