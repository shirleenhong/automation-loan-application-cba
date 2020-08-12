*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_21
    [Documentation]    Send Copp Clark Files for Newly Created Calendar ID
    ...    and Verify that holiday dates are added successfully.
    ...    @author: jloretiz    16AUG2019    - initial create
    
    Set Global Variable    ${rowid}    21
    Mx Execute Template With Multiple Data    Send Copp Clark Files for New Created Calendar ID    ${ExcelPath}    ${rowid}    Calendar_Fields
