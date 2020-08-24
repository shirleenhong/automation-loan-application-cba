*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_07
    [Documentation]    Send Golden Source Group File for FX RATES to SFTP with Invalid Funding Desk in File Name.
    ...    @author: jloretiz    21JAN2020    - initial create

    Set Global Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid Funding Desk    ${ExcelPath}    ${rowid}    FXRates_Fields