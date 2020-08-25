*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_CAL_11
    [Documentation]    Send Copp Clark files with Holiday for future date and verify that holiday be processed (T+2).
    ...    Manual update of XLS file to have a holiday date of T+2 days of LIQ date.
    ...    @author: clanding    29JUL2019    - initial create
    
    Set Global Variable    ${rowid}    11
    Mx Execute Template With Multiple Data    Send Copp Clark Files with Future Date - LIQ Date Plus 2 Days    ${ExcelPath}    ${rowid}    Calendar_Fields
