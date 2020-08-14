*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot
Suite Teardown    Test Suite Tear Down

*** Test Cases ***

TL_BASE_21
    [Documentation]    Send GS File with overnight rates and Floating Rates will be removed (RBA-AUD-LAST-001DAYS) and verify if reflected in LoanIQ.
    ...    @author: jdelacru    06AUG2019    - initial create
    
    Set Global Variable    ${rowid}    21
    Mx Execute Template With Multiple Data    Send GS File with Overnight Rates    ${ExcelPath}    ${rowid}    BaseRate_Fields
    
    
