*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_28
    [Documentation]    Send Copp Clark Files Misc with missing mandatory field and verify that holiday will not be processed.
    ...    @author: dahijara    14JAN2020    - initial create

    Set Global Variable    ${rowid}    28
    Mx Execute Template With Multiple Data    Send Copp Clark Files Misc with Missing Mandatory Field    ${ExcelPath}    ${rowid}    Calendar_Fields
