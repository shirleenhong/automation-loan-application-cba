*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_30
    [Documentation]     Send GS file with invalid GS_INSTR_TYPE.
    ...    @author: dahijara    18FEB2010    - initial create
    ...    @update: clanding    05OCT2020    - updated ${ExcelPath} to ${TL_DATASET}

    Set Global Variable    ${rowid}    30
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid GS_INSTR_TYPE    ${TL_DATASET}    ${rowid}    FXRates_Fields
    
   
