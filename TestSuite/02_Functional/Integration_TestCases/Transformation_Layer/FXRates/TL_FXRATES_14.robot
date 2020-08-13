*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_14
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with empty field value.
    ...    @author: dahijara    5FEB2010    - initial create

    Set Global Variable    ${rowid}    14
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Empty Field Value    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
