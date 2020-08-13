*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_27
    [Documentation]    Send Golden Source Group 1 File that contains empty rows to SFTP and verify if reflected in LoanIQ.
    ...    @author: cfrancis    15AUG2019    - initial create        
    Set Global Variable    ${rowid}    27
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File with Empty Rows    ${ExcelPath}    ${rowid}    FXRates_Fields
            
