*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
 
*** Test Cases ***
TL_FXRATES_06
    [Documentation]     Send Golden Source Group File for FX RATES to SFTP with Invalid Date Format in File.
    ...    @author: mnanquil    20MAR2019    - initial create
    ...    @update: jloretiz    22JAN2020    - modify documentation to fit the new description for this ticket

    Set Global Variable    ${rowid}    6
    Mx Execute Template With Multiple Data    Send GSFile for FX Rates with Invalid Date Format    ${ExcelPath}    ${rowid}    FXRates_Fields
    
   
