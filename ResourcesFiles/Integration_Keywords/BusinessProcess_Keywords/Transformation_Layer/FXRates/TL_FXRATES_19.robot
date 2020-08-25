*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Verify Future Date Polling Time for FX Rates
    [Documentation]    Verify future date polling time is every 10 minutes.
    ...    @author: dahijara    19FEB2020    - initial create
    [Arguments]    ${ExcelPath}
   
    Run Keyword And Continue On Failure    Validate Future Date Polling Time For FX Rates    &{ExcelPath}[InputFilePath]    &{ExcelPath}[Log_FileName]