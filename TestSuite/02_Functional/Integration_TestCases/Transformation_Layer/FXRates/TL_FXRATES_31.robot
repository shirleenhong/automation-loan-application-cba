*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
# Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_31
    [Documentation]    Send Golden Source Group 1 File with same records to SFTP and verify if reflected in LoanIQ.
    ...    @author: cfrancis    19AUG2019    - initial create       
    ...    @update: clanding    02OCT2020    - updated ${ExcelPath} to ${TL_DATASET} 
    Set Global Variable    ${rowid}    31
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File with Duplicate Records    ${TL_DATASET}    ${rowid}    FXRates_Fields
            
