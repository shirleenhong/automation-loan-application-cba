*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

TL_CAL_14
    [Documentation]    Send Copp Clark Files that with non-existing calendar ID and verify that holiday will not be processed.
    ...    @author: dahijara    17JAN2020    - initial create

    # Mx Launch UFT    Visibility=True    UFTAddins=Java
    Set Global Variable    ${rowid}    14
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Not Existing Calendar ID    ${ExcelPath}    ${rowid}    Calendar_Fields

