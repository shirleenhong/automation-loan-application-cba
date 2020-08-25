*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_29
    [Documentation]    Send Copp Clark Files 1 with incorrect sequence of headers and verify that holiday will not be processed.
    ...    @author: dahijara    20JAN2020    - initial create

    Set Global Variable    ${rowid}    29
    Mx Execute Template With Multiple Data    Send Copp Clark Files 1 with Incorrect Sequence of Headers    ${ExcelPath}    ${rowid}    Calendar_Fields
