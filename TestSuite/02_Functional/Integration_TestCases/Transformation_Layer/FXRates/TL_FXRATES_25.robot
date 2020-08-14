*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_25
    [Documentation]    Send Golden Source Group 2 File to SFTP and Verify Triangulation when Funding Desk Currency is USD.
    ...    @author: cfrancis    12AUG2019    - Initial Create        
    Set Global Variable    ${rowid}    25
    Mx Execute Template With Multiple Data    Send FXRates GS Group 2 File and Verify Triangulation    ${ExcelPath}    ${rowid}    FXRates_Fields
            
