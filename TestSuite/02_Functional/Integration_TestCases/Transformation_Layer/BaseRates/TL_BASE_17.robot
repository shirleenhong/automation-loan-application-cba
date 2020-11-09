*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
# Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_17
    [Documentation]    Send Golden Source File to SFTP with non-existing base rate code and price type config.
    ...    @author: dahijara    7FEB2020    - initial create
    
    Set Global Variable    ${rowid}    17
    Mx Execute Template With Multiple Data    Send Golden Source File with Non-Existing Base Rate Code and Price Type Config    ${ExcelPath}    ${rowid}    BaseRate_Fields
