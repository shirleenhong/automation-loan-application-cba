*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_01
    [Documentation]    Send 5 Copp Clark Files (3 xlsx and 2 csv) and verify if files will be processed successfully.
    ...    @author: clanding    31MAY2019    - initial create

    Set Global Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Send Valid Copp Clark Files    ${ExcelPath}    ${rowid}    Calendar_Fields
    
