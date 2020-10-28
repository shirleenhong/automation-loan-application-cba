*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_10
    [Documentation]    Send Copp Clark Files that with holiday for next business day (T+1) and verify that holiday will not be processed.
    ...    @author: dahijara    20DEC2019    - initial create

    Set Global Variable    ${rowid}    10
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Holiday for Next Business Day    ${ExcelPath}    ${rowid}    Calendar_Fields

