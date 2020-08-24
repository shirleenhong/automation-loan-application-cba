*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_26
    [Documentation]    Send Copp Clark Files 1 with missing mandatory field and verify that holiday will not be processed.
    ...    @author: dahijara    10JAN2020    - initial create

    Set Global Variable    ${rowid}    26
    Mx Execute Template With Multiple Data    Send Copp Clark Files 1 with Missing Mandatory Field    ${ExcelPath}    ${rowid}    Calendar_Fields
