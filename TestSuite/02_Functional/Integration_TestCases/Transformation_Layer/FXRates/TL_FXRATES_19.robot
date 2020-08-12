*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_19
    [Documentation]     Verify future date polling time is every 10 minutes.
    ...    @author: dahijara    19FEB2010    - initial create

    Set Global Variable    ${rowid}    19
    Mx Execute Template With Multiple Data    Verify Future Date Polling Time for FX Rates    ${ExcelPath}    ${rowid}    FXRates_Fields
    