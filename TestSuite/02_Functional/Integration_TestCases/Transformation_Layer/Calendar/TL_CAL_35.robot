*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_35
    [Documentation]    Send Copp Clark Files that with inactive calendar ID and verify that holiday will not be processed.
    ...    @author: dahijara    16JAN2020    - initial create

    Set Global Variable    ${rowid}    35
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Inactive Calendar ID    ${ExcelPath}    ${rowid}    Calendar_Fields

