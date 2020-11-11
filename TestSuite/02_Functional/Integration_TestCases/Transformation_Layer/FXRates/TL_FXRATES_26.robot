*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_26
    [Documentation]    Send Golden Source Group 1 File to SFTP and Verify Triangulation when Funding Desk Currency is not USD.
    ...    @author: cfrancis    13AUG2019    - Initial Create
    ...    @update: ccarriedo   09NOV2020    - updated ${ExcelPath} to ${TL_DATASET}        
    Set Global Variable    ${rowid}    26
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File and Verify Triangulation    ${TL_DATASET}    ${rowid}    FXRates_Fields
            
