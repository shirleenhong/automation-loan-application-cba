*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_04
    [Documentation]    Send more than one GS file and verify sequential processing
    ...    @author: mnanquil    20MAR2019    - initial create
    ...    @update: cfrancis    23JUL2019    - updated documentation
    ...    @update: ccarriedo   11NOV2020    - updated ${ExcelPath} to ${TL_DATASET} 
    Set Global Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Send FXRates GS Group Multiple Files    ${TL_DATASET}    ${rowid}    FXRates_Fields
   
