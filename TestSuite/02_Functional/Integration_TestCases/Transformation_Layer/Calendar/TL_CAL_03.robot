*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_03
    [Documentation]    Send Copp Clark Files with invalid filename for xls File 2 and verify that holiday will not be processed.
    ...    @author: dahijara    15JAN2020    - initial create

    Set Global Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Invalid File Name for XLS File 2    ${ExcelPath}    ${rowid}    Calendar_Fields