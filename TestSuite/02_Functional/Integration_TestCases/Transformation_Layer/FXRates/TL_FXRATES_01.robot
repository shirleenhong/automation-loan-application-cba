*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_01
    [Documentation]    Send Golden Source Group 1 File to SFTP and verify if reflected in LoanIQ.
    ...    this will cover tl fx01, 02, 05, 12, 13, and 14 in alm.
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: ccarriedo   27OCT2020    - updated ${ExcelPath} to ${TL_DATASET}        
    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File    ${TL_DATASET}    ${rowid}    FXRates_Fields
            
