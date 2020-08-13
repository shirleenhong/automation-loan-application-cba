*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_15
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with invalid data type.
    ...    @author: dahijara    5FEB2010    - initial create

    Set Global Variable    ${rowid}    15
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid Data Type    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
