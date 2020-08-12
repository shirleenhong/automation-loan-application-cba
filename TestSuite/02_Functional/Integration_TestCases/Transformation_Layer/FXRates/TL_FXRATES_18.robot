*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_18
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with missing mandatory header.
    ...    @author: dahijara    17FEB2010    - initial create

    Set Global Variable    ${rowid}    18
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Missing Mandatory Header    ${ExcelPath}    ${rowid}    FXRates_Fields
    
