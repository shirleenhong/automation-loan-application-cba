*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down
 
*** Test Cases ***
TL_FXRATES_05
    [Documentation]    Send more than one GS file on hold and verify FIFO
    ...    this will cover for scenario 16 in alm 
    ...    @author: mnanquil    20MAR2019    - initial create
    ...    @update: cfrancis    08AUG2019    - modified keyword to fit scenario and updated documentation
    ...    @update: ccarriedo   19NOV2020    - updated ${ExcelPath} to ${TL_DATASET}
    Set Global Variable    ${rowid}    5
    Mx Execute Template With Multiple Data    Send FXRates GS Group Multiple Files for FIFO    ${TL_DATASET}    ${rowid}    FXRates_Fields
   
