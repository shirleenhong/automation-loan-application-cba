*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_29
    [Documentation]     Send GS file with non-existing CCY Pair.
    ...    @author: dahijara    18FEB2010    - initial create

    Set Global Variable    ${rowid}    29
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Non-Existing CCY Pair    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
