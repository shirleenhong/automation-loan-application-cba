*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Report Prompt from Comments Report
    [Documentation]    This keyword is used to validate fields in Report Prompt_1 sheet name in the Comments Report.
    ...    Fields to Validate: Report Name, From Date, To Date
    ...    @author: clanding    18NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Deal Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Deal_2 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Deal Name, Deal Tracking Number, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Facility Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Facility_3 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Deal Name, Deal Tracking Number, Facility Name, Facility FCN, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Outstanding Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Outstanding_4 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Deal Name, Deal Tracking Number, Alias Number, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: clanding    20NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]