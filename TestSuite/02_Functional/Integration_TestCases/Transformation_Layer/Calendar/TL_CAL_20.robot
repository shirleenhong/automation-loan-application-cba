*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_20
    [Documentation]    Send Copp Clark Files when another files are being processed
    ...    And Verify that the first batch is successfully processed
    ...    And the second batch has no request and only exist in logs 
    ...    @author: jloretiz    21AUG2019    - initial create
    
    Set Global Variable    ${rowid}    21
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Inactive Holiday Date    ${ExcelPath}    ${rowid}    Calendar_Fields
    
    Test Suite Tear Down
    
    Set Global Variable    ${rowid}    20
    Mx Execute Template With Multiple Data    Send Copp Clark When Another Files Are Being Processed    ${ExcelPath}    ${rowid}    Calendar_Fields
