*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_31
    [Documentation]    Send Golden Source Group 1 File with same records to SFTP and verify if reflected in LoanIQ.
    ...    @author: cfrancis    19AUG2019    - initial create        
    Set Global Variable    ${rowid}    31
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File with Duplicate Records    ${ExcelPath}    ${rowid}    FXRates_Fields
            
