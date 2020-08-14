*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_02
    [Documentation]    Send Copp Clark Files with invalid filename and verify that holiday will not be processed.
    ...    @author: dahijara    28NOV2019    - initial create

    Set Global Variable    ${rowid}    2
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Invalid File Name for XLS File    ${ExcelPath}    ${rowid}    Calendar_Fields
