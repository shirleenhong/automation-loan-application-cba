*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_22
    [Documentation]    Send GS File with same base rate code but different price from an existing GS File on hold
    ...    @author: jdelacru    06AUG2019    - initial create
    
    Set Global Variable    ${rowid}    22
    Mx Execute Template With Multiple Data    Send GS File with Future Date and Existing Base Rate Record in Holding Table    ${ExcelPath}    ${rowid}    BaseRate_Fields   
