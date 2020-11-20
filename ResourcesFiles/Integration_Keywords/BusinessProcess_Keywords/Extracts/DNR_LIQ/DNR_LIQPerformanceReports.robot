*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Columns In LIQ Performance Report
    [Documentation]    This keyword is used to validate that the columns below are added on the LIQ Performance Report.
    ...    Columns to Validate: Deal Processing Area, Total Utilization Amount, Facility Status
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    ${LIQPerformance_Report}    Set Variable    &{ExcelPath}[Report_Path]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx
    Set Global Variable    ${Column_Header_Names}    5    ### The report file does not start at row 1 so the column headers are at row 5 ###
    Create Dictionary Using Report File and Validate Values if Existing    ${LIQPerformance_Report}    ${Column_Header_Names}    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Sheet_Name]    &{ExcelPath}[Delimiter]        
    