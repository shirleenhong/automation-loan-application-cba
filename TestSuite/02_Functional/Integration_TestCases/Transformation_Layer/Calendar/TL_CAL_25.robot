*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_25
    [Documentation]    Send Copp Clark Files with 1 file missing and verify that holiday will not be processed.
    ...    @author: dahijara    3FEB2020    - initial create
    ...    @update: clanding    30SEP2020    - updated ${ExcelPath} to ${TL_DATASET}

    Set Global Variable    ${rowid}    25
    
    Mx Execute Template With Multiple Data    Send Copp Clark Files with 1 File Missing    ${TL_DATASET}    ${rowid}    Calendar_Fields
