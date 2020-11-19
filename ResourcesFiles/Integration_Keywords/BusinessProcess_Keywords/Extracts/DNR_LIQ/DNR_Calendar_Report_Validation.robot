*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate The Branch, Process Area and Deal Calendar of Calendar Report
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate Calendar Report based on the Filters of Branch, Proc Area and Financial Center - CLAND_001
    ...    @author: fluberio    18NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    ### Get The Total Number of Row in the Given Excel Sheet ###
    Open Excel Document    &{ExcelPath}[Report_Path]${CBA_CALENDER_REPORTFILE}.xlsx    0
    ${Row_Count}    Get Row Count    &{ExcelPath}[Sheet_Name]
    Close Current Excel Document
    
    ### Get the Branch Value in the Generated Report ###
    ${Actual_Branch}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Branch    1    sFilePath=&{ExcelPath}[Report_Path]${CBA_CALENDER_REPORTFILE}.xlsx    readAllData=Y   
    Close Current Excel Document
    
    ### Get The Processing Area in the Generated Report ### 
    ${Actual_Processing_Area}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Processing Area    1    &{ExcelPath}[Report_Path]${CBA_CALENDER_REPORTFILE}.xlsx    readAllData=Y
    Close Current Excel Document
    
    ### Get The Deal Calender in the Generated Report
    ${Actual_Deal_Calendar}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Calendar    1    &{ExcelPath}[Report_Path]${CBA_CALENDER_REPORTFILE}.xlsx    readAllData=Y  
    Close Current Excel Document
    
    ### Validation of Expected and Actuals Values from Generated Report ###
    ${Row_Count}    Evaluate    ${Row_Count}-1
    :FOR    ${INDEX}    IN RANGE    0    ${Row_Count}
    \    Compare Two Strings    &{ExcelPath}[Branch]    @{Actual_Branch}[${INDEX}]   
    \    Compare Two Strings    &{ExcelPath}[Processing_Area]    @{Actual_Processing_Area}[${INDEX}]
    \    Compare Two Strings    &{ExcelPath}[Deal_Calender]    @{Actual_Deal_Calendar}[${INDEX}]