*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot 
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_32
    [Documentation]    Send Golden Source Group 1 File with duplicate records of different value to SFTP and verify if reflected in LoanIQ.
    ...    @author: cfrancis    21AUG2019    - initial create        
    Set Global Variable    ${rowid}    32
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File with Duplicate Records of Different Value    ${ExcelPath}    ${rowid}    FXRates_Fields
            
