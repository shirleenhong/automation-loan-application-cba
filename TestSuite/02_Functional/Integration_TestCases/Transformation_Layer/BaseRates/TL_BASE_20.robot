*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_20
    [Documentation]    Send GS File with tenor other than DAYS  that will be transformed (ALL-002WEEK) and verify if reflected in LoanIQ.
    ...    @author: jdelacru    23JUL2019    - initial create
    
    Set Global Variable    ${rowid}    20
    Mx Execute Template With Multiple Data    Send GS File with Week as Tenor    ${ExcelPath}    ${rowid}    BaseRate_Fields
    
    
