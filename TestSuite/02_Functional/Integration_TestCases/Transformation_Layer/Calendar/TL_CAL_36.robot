*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_36
    [Documentation]    Send Copp Clark Files with inactive holiday date status 
    ...    and verify that holiday dates status will be updated to active status
    ...    Manual change of XLS files - add inactive holiday date.
    ...    @author: jloretiz    12AUG2019    - initial create
    
    Set Global Variable    ${rowid}    36
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Inactive Holiday Date    ${ExcelPath}    ${rowid}    Calendar_Fields
