*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_39
    [Documentation]    Send Golden Source File to SFTP with duplicate rows with the same values and validate that the file will not be processed.
    ...    @author: dahijara    12FEB2020    - initial create
    
    Set Global Variable    ${rowid}    39
    Mx Execute Template With Multiple Data    Send Golden Source File with Duplicate Rows with Same Values    ${ExcelPath}    ${rowid}    BaseRate_Fields
