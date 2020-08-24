*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_11
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with TXT file type.
    ...    @author: dahijara    4FEB2010    - initial create

    Set Global Variable    ${rowid}    11
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with TXT File Type    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
