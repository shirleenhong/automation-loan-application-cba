*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_13
    [Documentation]    Send Copp Clark Files with invalid field values and verify that holiday will not be processed.
    ...    @author: dahijara    30JAN2020    - initial create

    Set Global Variable    ${rowid}    13
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Invalid Field Values    ${ExcelPath}    ${rowid}    Calendar_Fields
