*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_19
    [Documentation]    Send Copp Clark Files without the holiday dates existing in LIQ together with a new holiday 
    ...    and verify that those holiday dates existing in LIQ will become inactive and new holiday will be added.
    ...    Manual change of XLS files - add non-existing holiday date and remove row for record/s that are already existing in LIQ.
    ...    @author: clanding    07AUG2019    - initial create
    
    Set Global Variable    ${rowid}    19
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Missing Existing Holiday Date and New Holiday Date    ${ExcelPath}    ${rowid}    Calendar_Fields
