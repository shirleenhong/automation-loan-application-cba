*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_16
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with invalid field length.
    ...    @author: dahijara    13FEB2010    - initial create

    Set Global Variable    ${rowid}    16
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid Field Length    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
