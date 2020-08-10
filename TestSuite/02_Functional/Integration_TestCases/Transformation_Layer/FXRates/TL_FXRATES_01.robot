*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot
# Suite Teardown    Test Suite Tear Down

*** Variables ***
${rowid}    1

*** Test Cases ***
TL_FXRATES_01
    [Documentation]    Send Golden Source Group 1 File to SFTP and verify if reflected in LoanIQ.
    ...    this will cover tl fx01, 02, 05, 12, 13, and 14 in alm.
    ...    @author: mnanquil    04MAR2019    - initial create        
    
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File    ${ExcelPath}    ${rowid}    FXRates_Fields