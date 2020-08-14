*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down 

*** Test Cases ***
TL_FXRATES_03
    [Documentation]    Send Golden Source Group 3 File to SFTP then validate if future date will not be
    ...    consumed in ffc. This test case will cover for tl fxrates scenario 10 
    ...    @author: mnanquil    19MAR2019    - initial create
    Set Global Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send FXRates GS Group 3 File    ${ExcelPath}    ${rowid}    FXRates_Fields
   
