*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_26
    [Documentation]    Send Golden Source Group 1 File to SFTP and Verify Triangulation when Funding Desk Currency is not USD.
    ...    @author: cfrancis    13AUG2019    - Initial Create        
    Set Global Variable    ${rowid}    26
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File and Verify Triangulation    ${ExcelPath}    ${rowid}    FXRates_Fields
            
