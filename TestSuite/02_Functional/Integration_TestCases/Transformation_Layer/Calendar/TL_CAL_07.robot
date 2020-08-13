*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_07
    [Documentation]    Send Copp Clark Files with invalid file format and verify that holiday will not be processed.
    ...    @author: dahijara    28NOV2019    - initial create

    Set Global Variable    ${rowid}    7
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Invalid File Format    ${ExcelPath}    ${rowid}    Calendar_Fields
