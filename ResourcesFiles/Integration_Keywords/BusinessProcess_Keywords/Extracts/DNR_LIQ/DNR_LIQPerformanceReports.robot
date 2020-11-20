*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Columns In LIQ Performance Report
    [Documentation]    This keyword is used to validate that the columns below are added on the LIQ Performance Report.
    ...    Columns to Validate: Deal Processing Area, Total Utilization Amount, Facility Status
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    ${LIQFerformance_Report}    Set Variable    &{ExcelPath}[Report_Path]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx
    Set Global Variable    ${rowid}    5
    Create Dictionary Using Report File and Validate Values    ${LIQFerformance_Report}    ${rowid}    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]        
    