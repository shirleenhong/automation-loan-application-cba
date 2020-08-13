*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_04
    [Documentation]    Send Copp Clark Files with invalid filename for xls File misc and verify that holiday will not be processed.
    ...    @author: dahijara    15JAN2020    - initial create

    Set Global Variable    ${rowid}    4
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Invalid File Name for XLS Misc File    ${ExcelPath}    ${rowid}    Calendar_Fields