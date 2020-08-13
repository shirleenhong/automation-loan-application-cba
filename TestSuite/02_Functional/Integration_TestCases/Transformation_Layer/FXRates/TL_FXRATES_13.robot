*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_13
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with XLSX file type.
    ...    @author: dahijara    6FEB2010    - initial create

    Set Global Variable    ${rowid}    13
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with XLSX File Type    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
