*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_29
    [Documentation]    Send Golden Source File to SFTP with invalid base rate code.
    ...    @author: dahijara    12FEB2020    - initial create
    
    Set Global Variable    ${rowid}    29
    Mx Execute Template With Multiple Data    Send Golden Source File with Invalid Base Rate Code    ${ExcelPath}    ${rowid}    BaseRate_Fields
