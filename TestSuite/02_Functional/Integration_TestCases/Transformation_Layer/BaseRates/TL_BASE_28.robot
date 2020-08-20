*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_28
    [Documentation]   Send Update GS file (Any group) and verify that the latest GS file should be processed in LIQ.
    ...    @author: jdelacru    27AUG2019    - initial create
    
    Set Global Variable    ${rowid}    28
    Mx Execute Template With Multiple Data    Send Update GS file (Any group)    ${ExcelPath}    ${rowid}    BaseRate_Fields   
