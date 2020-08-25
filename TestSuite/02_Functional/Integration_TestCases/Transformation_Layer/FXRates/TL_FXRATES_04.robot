*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_04
    [Documentation]    Send more than one GS file and verify sequential processing
    ...    @author: mnanquil    20MAR2019    - initial create
    ...    @update: cfrancis    23JUL2019    - updated documentation
    Set Global Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Send FXRates GS Group Multiple Files    ${ExcelPath}    ${rowid}    FXRates_Fields
   
