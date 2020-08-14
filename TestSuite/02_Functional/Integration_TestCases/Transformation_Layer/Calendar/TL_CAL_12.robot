*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_12
    [Documentation]    Send Copp Clark Files with missing headers and verify that holiday will not be processed.
    ...    @author: dahijara    29JAN2020    - initial create

    Set Global Variable    ${rowid}    12
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Missing Headers    ${ExcelPath}    ${rowid}    Calendar_Fields
