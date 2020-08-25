*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_33
    [Documentation]    Send Copp Clark Files Misc with duplicate headers and verify that holiday will not be processed.
    ...    @author: dahijara    24JAN2020    - initial create

    Set Global Variable    ${rowid}    33
    Mx Execute Template With Multiple Data    Send Copp Clark File Misc with Duplicate Headers    ${ExcelPath}    ${rowid}    Calendar_Fields
