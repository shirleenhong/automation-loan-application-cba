*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_21
    [Documentation]    Send Golden Source Group 1 File to SFTP with rate exceeding 8 decimal points and verify if reflected in LoanIQ.
    ...    @author: cfrancis    06AUG2019    - Initial Create      
    ...    @update: clanding    02OCT2020    - updated ${ExcelPath} to ${TL_DATASET}  
    Set Global Variable    ${rowid}    21
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File with more than 8 decimal places    ${TL_DATASET}    ${rowid}    FXRates_Fields
            
