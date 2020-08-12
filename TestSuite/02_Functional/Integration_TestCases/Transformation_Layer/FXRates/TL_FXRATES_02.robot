*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_02
    [Documentation]    Send AS GS file with valid data and verify that the transformation Layer is able to process
    ...    this will update NY funding desk 
    ...    @author: mnanquil    04MAR2019    - initial create
    ...    @update: cfrancis    23JUL2019    - updated documentation
    Set Global Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Send FXRates GS Group 2 File    ${ExcelPath}    ${rowid}    FXRates_Fields
   
