*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_18
    [Documentation]    Send Copp Clark Files with the holiday dates existing in LIQ and removed them in Copp Clark Files
    ...    and verify that those holiday dates will be updated to inactive status 
    ...    (Reference will be all the holidays with the same calendar id).
    ...    Manual change of XLS files - remove row for record/s that are already existing in LIQ.
    ...    @author: clanding    06AUG2019    - initial create
    
    Set Global Variable    ${rowid}    18
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Missing Existing Holiday Date    ${ExcelPath}    ${rowid}    Calendar_Fields
