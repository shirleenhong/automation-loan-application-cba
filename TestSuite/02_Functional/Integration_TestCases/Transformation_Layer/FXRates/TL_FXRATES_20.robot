*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***
TL_FXRATES_20
    [Documentation]    Send Golden Source Group 1 File to SFTP then validate if future date will not be
    ...    consumed in ffc and will be stored in hold table
    ...    ensure that current rates in LIQ does not match the rates to be used on the file
    ...    @author: cfrancis    06AUG2018    - initial create        
    Set Global Variable    ${rowid}    20
    Mx Execute Template With Multiple Data    Send FXRates GS Group 1 File for Future Date    ${ExcelPath}    ${rowid}    FXRates_Fields       
