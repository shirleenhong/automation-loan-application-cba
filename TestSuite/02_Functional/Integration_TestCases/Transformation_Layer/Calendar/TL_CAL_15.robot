*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_15
    [Documentation]    Send Copp Clark files with Holiday Dates not existing in LoanIQ (valid calendar id) and verify that files are processed successfully.
    ...    Manual change of XLS files - non existing Holiday Date in LIQ should be included on the file/s.
    ...    @author: clanding    30JUL2019    - initial create
    
    Set Global Variable    ${rowid}    15
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Holiday Dates Not Existing in LIQ    ${ExcelPath}    ${rowid}    Calendar_Fields
