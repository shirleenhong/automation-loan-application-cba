*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_28
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with non existing FX rate code.
    ...    @author: dahijara    17FEB2010    - initial create
    ...    @update: clanding    06OCT2020    - updated ${ExcelPath} to ${TL_DATASET}

    Set Global Variable    ${rowid}    28
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Non Existing FX Rate Code    ${TL_DATASET}    ${rowid}    FXRates_Fields
    
   
