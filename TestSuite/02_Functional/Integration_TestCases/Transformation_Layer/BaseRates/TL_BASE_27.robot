*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_27
    [Documentation]    Send GS file with publish date equal to business date
    ...    @author: jdelacru    15AUG2019    - initial create
    
    Set Global Variable    ${rowid}    27
    Mx Execute Template With Multiple Data    Send GS Files with Publish Date Equal to Business Date    ${ExcelPath}    ${rowid}    BaseRate_Fields   
