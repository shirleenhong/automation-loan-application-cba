*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Control Value of Control Matrix for Existing Records
    [Documentation]    This keyword is used to get DAT File and validate each row's Control Value against LoanIQ database and extracted csv files.
    ...    @author: clanding    15OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Verify DAT File Control Value and DB Record are Matched    &{ExcelPath}[Zone]    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[DAT_File]    &{ExcelPath}[Branch_Code]
    Verify DAT File Control Value and CSV Files are Matched    &{ExcelPath}[Zone]    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[DAT_File]    &{ExcelPath}[Branch_Code]
    ...    &{ExcelPath}[DWE_Extract_Files_Path]    &{ExcelPath}[Business_Date]    &{ExcelPath}[Delimiter]