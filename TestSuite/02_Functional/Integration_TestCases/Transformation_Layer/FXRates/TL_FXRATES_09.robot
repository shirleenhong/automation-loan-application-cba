*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_09
    [Documentation]    Send Golden Source Group File for FX RATES to SFTP with Invalid Product Name in File Name.
    ...    @author: jloretiz    21JAN2020    - initial create

    Set Global Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid File Product Name    ${ExcelPath}    ${rowid}    FXRates_Fields