*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_31
    [Documentation]    Send Copp Clark Files Misc with incorrect sequence of headers and verify that holiday will not be processed.
    ...    @author: dahijara    21JAN2020    - initial create

    Set Global Variable    ${rowid}    31
    Mx Execute Template With Multiple Data    Send Copp Clark File Misc with Incorrect Sequence of Headers    ${ExcelPath}    ${rowid}    Calendar_Fields
