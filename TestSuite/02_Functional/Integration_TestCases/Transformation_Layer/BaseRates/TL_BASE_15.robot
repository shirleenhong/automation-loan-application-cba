*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_15
    [Documentation]    Send GS file with duplicate mandatory header columns
    ...    @author: jdelacru    01JUL2019    - initial create
    
    Set Global Variable    ${rowid}    15
    Mx Execute Template With Multiple Data    Send GS file with Duplicate Mandatory Header Columns    ${ExcelPath}    ${rowid}    BaseRate_Fields
