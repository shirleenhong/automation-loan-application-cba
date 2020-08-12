*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_09
    [Documentation]    Send Copp Clark Files that with holiday less than current system date and verify that holiday will not be processed.
    ...    @author: dahijara    10DEC2019    - initial create

    Set Global Variable    ${rowid}    9
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Holiday Same with Current System Date    ${ExcelPath}    ${rowid}    Calendar_Fields

