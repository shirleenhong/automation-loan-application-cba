*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_17
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with invalid field data format.
    ...    @author: dahijara    14FEB2010    - initial create

    Set Global Variable    ${rowid}    17
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid Field Data Format    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
