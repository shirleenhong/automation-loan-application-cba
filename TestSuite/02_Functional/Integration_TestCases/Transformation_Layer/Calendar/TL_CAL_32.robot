*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_32
    [Documentation]    Send Copp Clark Files 1 and 2 with duplicate headers and verify that holiday will not be processed.
    ...    @author: dahijara    23JAN2020    - initial create

    Set Global Variable    ${rowid}    32
    Mx Execute Template With Multiple Data    Send Copp Clark File 1 and 2 with Duplicate Headers    ${ExcelPath}    ${rowid}    Calendar_Fields
