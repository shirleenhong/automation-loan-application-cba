*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_37
    [Documentation]    Send Copp Clark Files with the multiple rows having the same dates
    ...    but different Event Name and Verify that only the 1st record will be processed successfully
    ...    and the rest will be ignored.
    ...    @author: jloretiz    14AUG2019    - initial create
    
    Set Global Variable    ${rowid}    37
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Multiple Rows and Same Date    ${ExcelPath}    ${rowid}    Calendar_Fields
