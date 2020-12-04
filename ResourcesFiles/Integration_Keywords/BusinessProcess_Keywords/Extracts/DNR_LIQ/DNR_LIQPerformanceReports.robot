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
    
Validate Facility Performance Report File With Pending Status
    [Documentation]    This keyword is used to validate facility performance report files with pending status.
    ...    @author: ccarriedo    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${LIQPerformance_Report}    Set Variable    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]
    ${Sheet_Name}    Set Variable    &{ExcelPath}[Sheet_Name]
    ${Facility_Name}    Set Variable    &{ExcelPath}[Facility_Name]
    ${Total_Utilization_Amount_Column_Index}    Set Variable    16
    
    CustomExcelLibrary.Open Excel    ${LIQPerformance_Report}
    
    ${Report_Sheet_Column_Value_List}    CustomExcelLibrary.Get Column Values    ${Sheet_Name}    ${Total_Utilization_Amount_Column_Index}
    ${Report_Sheet_Column_Value_ListString}    Convert To String    ${Report_Sheet_Column_Value_List}
    
    ${Status_Contains_FacilityName}    Run Keyword and Return Status    Should Contain    ${Report_Sheet_Column_Value_ListString}    ${Facility_Name}
    Run Keyword If    ${Status_Contains_FacilityName}==False    Log    Expected: Facility Name ${Facility_Name} is not present in report file ${LIQPerformance_Report}.
    ...    ELSE    FAIL    Facility Name ${Facility_Name} is present in report file ${LIQPerformance_Report}.
