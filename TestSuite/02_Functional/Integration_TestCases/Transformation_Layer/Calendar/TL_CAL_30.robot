*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_30
    [Documentation]    Send Copp Clark Files 2 with incorrect sequence of headers and verify that holiday will not be processed.
    ...    @author: dahijara    21JAN2020    - initial create

    Set Global Variable    ${rowid}    30
    Mx Execute Template With Multiple Data    Send Copp Clark Files 2 with Incorrect Sequence of Headers    ${ExcelPath}    ${rowid}    Calendar_Fields
