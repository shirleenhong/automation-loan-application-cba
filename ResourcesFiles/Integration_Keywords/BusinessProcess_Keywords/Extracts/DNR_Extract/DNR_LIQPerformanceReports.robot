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

Write Details for Facility Performance
    [Documentation]    This keyword is used to write needed details in Facility Performance sheet.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    FACPF    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_LIQPERFORMANCE_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    
Validate Facility Performance Report File with Pending Status
    [Documentation]    This keyword is used to validate facility performance report files where the Facility Name value does not exists.
    ...    @author: ccarriedo    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${LIQPerformance_Report}    Set Variable    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]
    ${Sheet_Name}    Set Variable    &{ExcelPath}[Sheet_Name]
    ${Facility_Name}    Set Variable    &{ExcelPath}[Facility_Name]
    
    Validate Facility Name Value if Existing    ${LIQPerformance_Report}    ${Sheet_Name}    ${Facility_Name}
    
Validate Facility Performance Report File for Active Facility
    [Documentation]    This keyword is used to validate facility performance report files.
    ...    @author: ccarriedo    07DEC2020    - initial create
    ...    @update: clanding    11DEC2020    - updated keyword name from 'Validate Facility Performance Report File' to 'Validate Facility Performance Report File for Active Facility'
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Set Variable    &{ExcelPath}[Deal_Name]
    ${Sheet_Name}    Set Variable    &{ExcelPath}[Sheet_Name]
    ${Facility_Name}    Set Variable    &{ExcelPath}[Facility_Name]
    ${Columns_To_Validate}    Set Variable    &{ExcelPath}[Columns_To_Validate]
    ${Delimiter}    Set Variable    &{ExcelPath}[Delimiter]
    ${Column_Headers_RowID}    Set Variable    &{ExcelPath}[Column_Headers_RowID]    ### The report file does not start at row 1 so the column headers are at row 5 ###
    ${Facility_Outstandings}    Set Variable    &{ExcelPath}[Facility_Outstandings]
    ${Facility_Status}    Set Variable    &{ExcelPath}[Facility_Status]        
    ${Facility_FCN}    Set Variable    &{ExcelPath}[Facility_FCN]
    
    Validate Facility Performance Report File    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    ${Sheet_Name}    ${Facility_Name}    ${Columns_To_Validate}    
    ...    ${Delimiter}    ${Column_Headers_RowID}    ${Facility_Status}    ${Facility_Outstandings}    ${Facility_FCN}

Validate Facility Performance Report File for Expired Facility
    [Documentation]    This keyword is used to validate facility performance report files for Expired Facility status.
    ...    @author: clanding    11DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Set Variable    &{ExcelPath}[Deal_Name]
    ${Sheet_Name}    Set Variable    &{ExcelPath}[Sheet_Name]
    ${Facility_Name}    Set Variable    &{ExcelPath}[Facility_Name]
    ${Columns_To_Validate}    Set Variable    &{ExcelPath}[Columns_To_Validate]
    ${Delimiter}    Set Variable    &{ExcelPath}[Delimiter]
    ${Column_Headers_RowID}    Set Variable    &{ExcelPath}[Column_Headers_RowID]    ### The report file does not start at row 1 ###
    ${Facility_Outstandings}    Set Variable    &{ExcelPath}[Facility_Outstandings]
    ${Facility_Status}    Set Variable    &{ExcelPath}[Facility_Status]        
    ${Facility_FCN}    Set Variable    &{ExcelPath}[Facility_FCN]
    
    Validate Facility Performance Report File    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    ${Sheet_Name}    ${Facility_Name}    ${Columns_To_Validate}    
    ...    ${Delimiter}    ${Column_Headers_RowID}    ${Facility_Status}    ${Facility_Outstandings}    ${Facility_FCN}
