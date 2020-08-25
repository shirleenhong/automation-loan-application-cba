*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_12
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with XLS file type.
    ...    @author: dahijara    6FEB2010    - initial create

    Set Global Variable    ${rowid}    12
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with XLS File Type    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
